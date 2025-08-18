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
import game.notes.events.SustainDropEvent;
import game.notes.events.SustainHoldEvent;
import game.notes.NoteSpawner;
import game.notes.Strumline;

import core.AssetCache;
import core.Options;
import core.Paths;

import music.Conductor;

using util.MathUtil;
using util.StringUtil;

// TODO: Have sustain drops add misses.
class PlayField extends FlxGroup
{
    public var tween:FlxTweenManager;

    public var timer:FlxTimerManager;

    public var conductor:Conductor;

    public var chart:Chart;

    public var instrumental:FlxSound;

    public var playStats:PlayStats;

    public var scoreClip:FlxSprite;

    public var scoreText:FlxText;

    public var scoreTextFormat:FlxTextFormat;

    public var formatRules:Array<FlxTextFormatMarkerPair>;

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

        scoreClip = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/clipboard"));

        scoreClip.active = false;

        scoreClip.flipY = Options.downscroll;

        scoreClip.scale.set(1.1, 1.1);

        scoreClip.updateHitbox();

        scoreClip.setPosition(25.0, Options.downscroll ? -scoreClip.height * 0.35 : FlxG.height - scoreClip.height * 0.65);

        add(scoreClip);

        scoreText = new FlxText(0.0, 0.0, scoreClip.width, "", 18);

        scoreText.color = FlxColor.BLACK;

        scoreText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        scoreText.alignment = LEFT;

        scoreText.textField.antiAliasType = ADVANCED;

        var tf:TextFormat = scoreText.textField.defaultTextFormat;

        tf.leading = 5;

        scoreText.textField.defaultTextFormat = tf;

        scoreText.textField.sharpness = 400.0;

        add(scoreText);

        scoreTextFormat = new FlxTextFormat(FlxColor.BLACK);

        formatRules = [new FlxTextFormatMarkerPair(scoreTextFormat, "<color-format>")];

        updateScoreText();

        healthBar = new HealthBar(0.0, 0.0, conductor);

        healthBar.setPosition(healthBar.getCenterX(),
            Options.downscroll ? -20.0 : FlxG.height - healthBar.height + 20.0);

        add(healthBar);

        timerClock = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/PlayField/timerClock"));
        
        timerClock.active = false;

        timerClock.scale.set(0.5, 0.5);

        timerClock.updateHitbox();

        timerClock.setPosition(FlxG.width - timerClock.width - 25.0, Options.downscroll ? 25.0 : FlxG.height - timerClock.height - 25.0);
        
        add(timerClock);

        timerNeedle = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/PlayField/timerNeedle"));

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

            strumline.onSustainDrop.add(sustainDrop);

            strumline.onGhostTap.add(ghostTap);
        });

        add(strumlines);

        noteSpawner.strumlines = strumlines;

        opponentStrumline = new Strumline(conductor);

        opponentStrumline.botplay = true;

        opponentStrumline.strums.setPosition(45.0, opponentStrumline.downscroll ?
            FlxG.height - opponentStrumline.strums.height - 15.0 : 15.0);

        strumlines.add(opponentStrumline);

        playerStrumline = new Strumline(conductor);

        playerStrumline.botplay = Options.botplay;

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

    public function updateScoreText():Void
    {
        if (playStats.isEmpty())
        {
            if (Options.downscroll)
                scoreText.text = "Grade: N/A\nAccuracy: 0%\nMisses: 0\nScore: 0";
            else
                scoreText.text = "Score: 0\nMisses: 0\nAccuracy: 0%\nGrade: N/A";

            scoreText.setPosition(scoreClip.x + 32.0, Options.downscroll ? scoreClip.y + scoreClip.height -
                scoreText.height - 28.0 : scoreClip.y + 28.0);

            return;
        }

        var score:Int = playStats.score;

        var misses:Int = playStats.misses;

        var accuracy:Float = FlxMath.roundDecimal(playStats.accuracy, 2);

        var grade:String = playStats.grade;

        @:privateAccess
        scoreTextFormat.format.color = PlayStats.getColorForGrade(grade);

        if (Options.downscroll)
            scoreText.applyMarkup
                ('<color-format>Grade: ${grade}<color-format>\nAccuracy: ${accuracy}%\nMisses: ${misses}\nScore: ${score}', formatRules);
        else
        {
            scoreText.applyMarkup
                ('Score: ${score}\nMisses: ${misses}\nAccuracy: ${accuracy}%\n<color-format>Grade: ${grade}<color-format>', formatRules);
        }
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

            updateScoreText();

            healthBar.value += rating.health;
        }
    }

    public function noteMiss(note:Note):Void
    {
        playStats.score -= 500;

        playStats.misses++;

        updateScoreText();

        healthBar.value -= 1.5;
    }

    public function sustainHold(ev:SustainHoldEvent):Void
    {
        if (ev.note.strumline.botplay)
            return;

        playStats.score += Math.floor(250.0 * ev.elapsed);

        updateScoreText();

        healthBar.value += 10.0 * ev.elapsed;
    }

    public function sustainDrop(ev:SustainDropEvent):Void
    {
        playStats.score -= 250;

        updateScoreText();

        healthBar.value -= 1.0;
    }

    public function ghostTap(ev:GhostTapEvent):Void
    {
        if (!ev.ghostTapping)
        {
            playStats.score -= 500;

            playStats.misses++;

            updateScoreText();

            healthBar.value -= 1.5;
        }
    }
}