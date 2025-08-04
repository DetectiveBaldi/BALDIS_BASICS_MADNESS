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
import game.notes.events.SustainHoldEvent;
import game.notes.events.SustainMissEvent;
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

    public var noteSpawner:NoteSpawner;

    public var strumlines:FlxTypedGroup<Strumline>;

    public var opponentStrumline:Strumline;

    public var playerStrumline:Strumline;

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

        scoreClip = new FlxSprite(0.0, 0.0, Assets.getGraphic("shared/clipboard"));

        scoreClip.active = false;

        scoreClip.flipY = Options.downscroll;

        scoreClip.setPosition(25.0, Options.downscroll ? -scoreClip.height * 0.35 : FlxG.height - scoreClip.height * 0.65);

        add(scoreClip);

        scoreTxt = new FlxText(0.0, 0.0, scoreClip.width, "", 18);

        scoreTxt.color = FlxColor.BLACK;

        scoreTxt.font = Paths.font(Paths.ttf("Comic Sans MS"));

        scoreTxt.alignment = LEFT;

        scoreTxt.textField.antiAliasType = ADVANCED;

        var tf:TextFormat = scoreTxt.textField.defaultTextFormat;

        tf.leading = 5;

        scoreTxt.textField.defaultTextFormat = tf;

        scoreTxt.textField.sharpness = 400.0;

        add(scoreTxt);

        updateScoreTxt();

        healthBar = new HealthBar(0.0, 0.0, conductor);

        healthBar.setPosition(healthBar.getCenterX(),
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

        noteSpawner = new NoteSpawner(conductor, chart.notes, null);

        add(noteSpawner);

        strumlines = new FlxTypedGroup<Strumline>();

        strumlines.memberAdded.add((strumline:Strumline) ->
        {
            strumline.onNoteHit.add(noteHit);

            strumline.onNoteMiss.add(noteMiss);

            strumline.onSustainHold.add(sustainHold);

            strumline.onSustainMiss.add(sustainMiss);

            strumline.onGhostTap.add(ghostTap);
        });

        strumlines.memberRemoved.add((strumline:Strumline) ->
        {
            strumline.onNoteHit.remove(noteHit);

            strumline.onNoteMiss.remove(noteMiss);

            strumline.onSustainHold.remove(sustainHold);

            strumline.onSustainMiss.remove(sustainMiss);

            strumline.onGhostTap.remove(ghostTap);
        });

        add(strumlines);

        noteSpawner.strumlines = strumlines;

        opponentStrumline = new Strumline(conductor);

        opponentStrumline.botplay = true;

        opponentStrumline.clearKeys();

        opponentStrumline.strums.setPosition(45.0,opponentStrumline.downscroll ?
            FlxG.height - opponentStrumline.strums.height - 15.0 : 15.0);

        strumlines.add(opponentStrumline);

        playerStrumline = new Strumline(conductor);

        if (Options.botplay)
        {
            playerStrumline.botplay = true;

            playerStrumline.clearKeys();
        }

        playerStrumline.strums.setPosition(FlxG.width - playerStrumline.strums.width - 45.0, playerStrumline.downscroll ?
            FlxG.height - playerStrumline.strums.height - 15.0 : 15.0);

        strumlines.add(playerStrumline);

        scrollSpeed = chart.scrollSpeed;
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
        if (playStats.isEmpty())
        {
            if (Options.downscroll)
                scoreTxt.text = "Grade: N/A\nAccuracy: 0%\nMisses: 0\nScore: 0";
            else
                scoreTxt.text = "Score: 0\nMisses: 0\nAccuracy: 0%\nGrade: N/A";

            scoreTxt.setPosition(scoreClip.x + 28.5, Options.downscroll ? scoreClip.y + scoreClip.height -
                scoreTxt.height - 25.0 : scoreClip.y + 25.0);

            return;
        }

        var score:Int = playStats.score;

        var misses:Int = playStats.misses;

        var accuracy:Float = FlxMath.roundDecimal(playStats.accuracy, 1);

        var grade:String = playStats.grade;

        if (Options.downscroll)
            scoreTxt.text = 'Grade: ${grade}\nAccuracy: ${accuracy}%\nMisses: ${misses}\nScore: ${score}';
        else
            scoreTxt.text = 'Score: ${score}\nMisses: ${misses}\nAccuracy: ${accuracy}%\nGrade: ${grade}';
    }

    public function noteHit(event:NoteHitEvent):Void
    {
        var rating:Rating = Rating.fromTiming(Math.abs(event.note.time - conductor.time));

        if (rating != Rating.list[0])
            event.playSplash = false;

        if (!event.note.strumline.botplay)
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

    public function sustainHold(ev:SustainHoldEvent):Void
    {
        if (ev.note.strumline.botplay)
            return;

        playStats.score += Math.floor(250.0 * ev.elapsed);

        updateScoreTxt();

        healthBar.value += 10.0 * ev.elapsed;
    }

    public function sustainMiss(ev:SustainMissEvent):Void
    {
        playStats.score -= Math.floor(250.0 * ev.elapsed);

        updateScoreTxt();

        healthBar.value -= 10.0 * ev.elapsed;
    }

    public function ghostTap(ev:GhostTapEvent):Void
    {
        if (!ev.ghostTapping)
        {
            playStats.score -= 500;

            playStats.misses++;

            updateScoreTxt();

            healthBar.value -= 1.5;
        }
    }
}