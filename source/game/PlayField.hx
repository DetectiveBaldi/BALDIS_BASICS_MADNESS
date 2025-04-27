package game;

import openfl.text.TextFormat;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import data.Chart;
import data.PlayStats;

import game.notes.Note;
import game.notes.events.GhostTapEvent;
import game.notes.events.NoteHitEvent;
import game.notes.NoteSpawner;
import game.notes.Strumline;

import core.Assets;
import core.Options;
import core.Paths;

import music.Conductor;

using util.MathUtil;
using util.StringUtil;

class PlayField extends FlxGroup
{
    public var tween:FlxTweenManager;

    public var timer:FlxTimerManager;

    public var conductor:Conductor;

    public var chart:Chart;

    public var instrumental:FlxSound;

    public var playStats:PlayStats;

    public var scoreClip:FlxSprite;

    public var scoreTxt:FlxText;

    public var healthBar:HealthBar;

    public var timerClock:FlxSprite;

    public var timerNeedle:FlxSprite;

    public var creditsPop:CreditsPopup;

    public var scrollSpeed(default, set):Float;

    @:noCompletion
    function set_scrollSpeed(_scrollSpeed:Float):Float
    {
        scrollSpeed = _scrollSpeed;

        strumlines.forEach((strumline:Strumline) -> strumline.scrollSpeed = scrollSpeed);

        return scrollSpeed;
    }

    public var strumlines:FlxTypedGroup<Strumline>;

    public var opponentStrumline:Strumline;

    public var playerStrumline:Strumline;

    public var noteSpawner:NoteSpawner;

    public function new(?tween:FlxTweenManager, ?timer:FlxTimerManager, _conductor:Conductor, 
        _chart:Chart, _instrumental:FlxSound):Void
    {
        super();

        this.tween = tween ?? FlxTween.globalManager;

        this.timer = timer ?? FlxTimer.globalManager;

        conductor = _conductor;

        conductor.onStepHit.add(stepHit);

        chart = _chart;

        instrumental = _instrumental;

        playStats = {score: 0, hits: 0, misses: 0, bonus: 0.0}

        scoreClip = new FlxSprite(0.0, 0.0, Assets.getGraphic("globals/clipboard"));

        scoreClip.active = false;

        scoreClip.flipY = Options.downscroll;

        scoreClip.setPosition(25.0, Options.downscroll ? -scoreClip.height * 0.35 : FlxG.height - scoreClip.height * 0.65);

        add(scoreClip);

        scoreTxt = new FlxText(0.0, 0.0, scoreClip.width, "Score: 0\nMisses: 0\nAccuracy: 0%\nGrade: N/A", 18);

        scoreTxt.color = FlxColor.BLACK;

        scoreTxt.font = Paths.font(Paths.ttf("Comic Sans MS"));

        scoreTxt.alignment = LEFT;

        scoreTxt.textField.antiAliasType = ADVANCED;

        var tf:TextFormat = scoreTxt.textField.defaultTextFormat;

        tf.leading = 5;

        scoreTxt.textField.defaultTextFormat = tf;

        scoreTxt.textField.sharpness = 400.0;

        scoreTxt.setPosition(scoreClip.x + 28.5,
            Options.downscroll ? scoreClip.y + scoreClip.height - scoreTxt.height - 25.0 : scoreClip.y + 25.0);

        add(scoreTxt);

        if (Options.downscroll)
            scoreTxt.text = scoreTxt.text.reverse("\n", "\n");

        healthBar = new HealthBar(0.0, 0.0, conductor);

        healthBar.setPosition((FlxG.width - healthBar.width) * 0.5,
            Options.downscroll ? -20.0 : FlxG.height - healthBar.height + 20.0);

        add(healthBar);

        timerClock = new FlxSprite(0.0, 0.0, Assets.getGraphic("game/PlayField/timerClock"));
        
        timerClock.active = false;

        timerClock.scale.set(0.5, 0.5);

        timerClock.updateHitbox();

        timerClock.setPosition(FlxG.width - timerClock.width - 25.0, Options.downscroll ? 25.0 : FlxG.height - timerClock.height - 25.0);
        
        add(timerClock);

        timerNeedle = new FlxSprite(0.0, 0.0, Assets.getGraphic("game/PlayField/timerNeedle"));

        timerNeedle.active = false;

        timerNeedle.scale.set(0.5, 0.5);

        timerNeedle.updateHitbox();

        timerNeedle.setPosition(timerClock.x + (timerClock.width * 0.5) - ((timerNeedle.width * 0.5)), 
            timerClock.y + (timerClock.height * 0.5) - ((timerNeedle.height * 0.25) + 20.0));

        add(timerNeedle);

        creditsPop = new CreditsPopup(0.0, 0.0, tween, timer, chart.credits);

        add(creditsPop);

        strumlines = new FlxTypedGroup<Strumline>();

        strumlines.memberAdded.add((strumline:Strumline) ->
        {
            strumline.onNoteHit.add(noteHit);

            strumline.onNoteMiss.add(noteMiss);

            strumline.onGhostTap.add(ghostTap);
        });

        strumlines.memberRemoved.add((strumline:Strumline) ->
        {
            strumline.onNoteHit.remove(noteHit);

            strumline.onNoteMiss.remove(noteMiss);

            strumline.onGhostTap.remove(ghostTap);
        });

        add(strumlines);

        opponentStrumline = new Strumline(conductor);

        opponentStrumline.visible = !Options.middlescroll;

        opponentStrumline.automated = true;

        opponentStrumline.clearKeys();

        opponentStrumline.strums.setPosition(Options.middlescroll ? (FlxG.width - opponentStrumline.strums.width) * 0.5 : 45.0, opponentStrumline.downscroll ? FlxG.height - opponentStrumline.strums.height - 15.0 : 15.0);

        strumlines.add(opponentStrumline);

        playerStrumline = new Strumline(conductor);

        if (Options.automatedInputs)
        {
            playerStrumline.automated = true;

            playerStrumline.clearKeys();
        }

        playerStrumline.strums.setPosition(Options.middlescroll ? (FlxG.width - playerStrumline.strums.width) * 0.5 : FlxG.width - playerStrumline.strums.width - 45.0, playerStrumline.downscroll ? FlxG.height - playerStrumline.strums.height - 15.0 : 15.0);

        strumlines.add(playerStrumline);

        scrollSpeed = chart.scrollSpeed;

        noteSpawner = new NoteSpawner(conductor, chart, strumlines);

        add(noteSpawner);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (conductor.time > 0.0)
            timerNeedle.angle = (conductor.time / instrumental.length) * 360.0;
    }

    override function destroy():Void
    {
        super.destroy();

        conductor?.onStepHit?.remove(stepHit);
    }

    public function stepHit(step:Int):Void
    {
        if (creditsPop.credits.step ?? 0.0 == step)
            creditsPop.popUp();
    }

    public function updateScoreTxt():Void
    {
        var score:Int = playStats.score;

        var misses:Int = playStats.misses;

        var accuracy:Float = playStats.accuracy;

        var grade:String = playStats.grade;

        scoreTxt.text = 'Score: ${score}\nMisses: ${misses}\nAccuracy: ${FlxMath.roundDecimal(accuracy, 1)}%\nGrade: ${grade}';

        if (Options.downscroll)
            scoreTxt.text = scoreTxt.text.reverse("\n", "\n");
    }

    public function noteHit(event:NoteHitEvent):Void
    {
        var ratings:Array<Rating> = Rating.list;

        var rating:Rating = Rating.fromTiming(Math.abs(event.note.time - conductor.time));

        if (rating != ratings[0])
            event.showPop = false;

        if (!event.note.strumline.automated)
        {
            playStats.score += 500 - Math.ceil(Math.abs(event.note.time - conductor.time));

            playStats.hits++;

            playStats.bonus += rating.bonus;

            updateScoreTxt();

            healthBar.value += rating.health;
        }
    }

    public function noteMiss(note:Note):Void
    {
        playStats.score -= 500;

        playStats.misses++;

        updateScoreTxt();

        healthBar.value -= 1.5;
    }

    public function ghostTap(event:GhostTapEvent):Void
    {
        if (!event.ghostTapping)
        {
            playStats.score -= 500;

            playStats.misses++;

            updateScoreTxt();

            healthBar.value -= 1.5;
        }
    }
}