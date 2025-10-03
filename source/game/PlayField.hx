package game;

import openfl.text.TextFormat;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

import data.Chart;
import data.PlayStats;

import game.notes.Note;
import game.notes.events.GhostTapEvent;
import game.notes.events.NoteHitEvent;
import game.notes.events.SustainHoldEvent;
import game.notes.NoteSpawner;
import game.notes.Strumline;

import core.AssetCache;
import core.Options;
import core.Paths;

import interfaces.IBeatDispatcher;
import interfaces.ISequenceHandler;

import music.Conductor;

using util.MathUtil;
using util.StringUtil;

class PlayField extends FlxGroup implements ISequenceHandler
{
    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;

    public var conductor:Conductor;

    public var getSongTime:()->Float;

    public var getSongLength:()->Float;

    public var playStats:PlayStats;

    public var botplayIcon:FlxSprite;

    public var scoreClip:FlxSprite;

    public var scoreText:FlxText;

    public var scoreTextFormat:FlxTextFormat;

    public var formatRules:Array<FlxTextFormatMarkerPair>;

    public var healthBar:HealthBar;

    public var timerClock:FlxSprite;

    public var timerNeedle:FlxSprite;

    public var creditsPop:CreditsPopup;

    public var noteSpawner:NoteSpawner;

    public var strumlines:FlxTypedGroup<Strumline>;

    public var scrollSpeed:Float;

    public var opponentStrumline:Strumline;

    public var playerStrumline:Strumline;

    public var onUpdateScore:FlxTypedSignal<(playStats:PlayStats)->Void>;

    public function new(beatDispatcher:IBeatDispatcher, sequenceHandler:ISequenceHandler, chart:Chart):Void
    {
        super();

        tweens = sequenceHandler.tweens;

        timers = sequenceHandler.timers;

        conductor = beatDispatcher.conductor;

        conductor.onStepHit.add(stepHit);

        playStats = {score: 0, hits: 0, misses: 0, bonus: 0.0}

        botplayIcon = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/botplay-icon"));

        botplayIcon.active = false;

        botplayIcon.setPosition(10.0, Options.downscroll ? FlxG.height - botplayIcon.height - 10.0 : 10.0);

        add(botplayIcon);

        if (!Options.botplay)
            botplayIcon.kill();

        scoreClip = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/clipboard"));

        scoreClip.active = false;

        scoreClip.flipY = Options.downscroll;

        scoreClip.scale.set(1.1, 1.1);

        scoreClip.updateHitbox();

        scoreClip.setPosition(25.0, Options.downscroll ? -scoreClip.height * 0.35 : FlxG.height - scoreClip.height * 0.65);

        add(scoreClip);

        if (Options.botplay)
            scoreClip.kill();

        scoreText = new FlxText(0.0, 0.0, scoreClip.width, "", 18);

        scoreText.color = FlxColor.BLACK;

        scoreText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        var tf:TextFormat = scoreText.textField.defaultTextFormat;

        tf.leading = 5;

        scoreText.textField.defaultTextFormat = tf;

        add(scoreText);

        if (Options.botplay)
            scoreText.kill();

        scoreTextFormat = new FlxTextFormat(FlxColor.BLACK);

        formatRules = [new FlxTextFormatMarkerPair(scoreTextFormat, "<color-format>")];

        updateScoreText();

        healthBar = new HealthBar(0.0, 0.0, conductor);

        healthBar.setPosition(healthBar.getCenterX(),
            Options.downscroll ? -20.0 : FlxG.height - healthBar.height + 20.0);

        add(healthBar);

        if (Options.botplay)
            healthBar.kill();

        timerClock = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/PlayField/timerClock"));
        
        timerClock.active = false;

        timerClock.scale.set(0.5, 0.5);

        timerClock.updateHitbox();

        timerClock.setPosition(FlxG.width - timerClock.width - 25.0, Options.downscroll ? 25.0 : FlxG.height - timerClock.height - 25.0);
        
        add(timerClock);

        if (Options.botplay)
            timerClock.kill();

        timerNeedle = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/PlayField/timerNeedle"));

        timerNeedle.active = false;

        timerNeedle.scale.set(0.5, 0.5);

        timerNeedle.updateHitbox();

        timerNeedle.setPosition(timerClock.x + (timerClock.width * 0.5) - ((timerNeedle.width * 0.5)), 
            timerClock.y + (timerClock.height * 0.5) - ((timerNeedle.height * 0.25) + 20.0));

        add(timerNeedle);

        if (Options.botplay)
            timerNeedle.kill();

        creditsPop = new CreditsPopup(0.0, 0.0, this, chart.credits);

        add(creditsPop);

        noteSpawner = new NoteSpawner(conductor, chart.notes, null);

        add(noteSpawner);

        strumlines = new FlxTypedGroup<Strumline>();

        add(strumlines);

        scrollSpeed = chart.scrollSpeed;

        noteSpawner.strumlines = strumlines;

        opponentStrumline = new Strumline(conductor);

        opponentStrumline.scrollSpeed = scrollSpeed;

        opponentStrumline.botplay = true;

        opponentStrumline.strums.setPosition(45.0, opponentStrumline.downscroll ?
            FlxG.height - opponentStrumline.strums.height - 15.0 : 15.0);

        strumlines.add(opponentStrumline);

        playerStrumline = new Strumline(conductor);

        playerStrumline.onNoteHit.add(noteHit);

        playerStrumline.onNoteMiss.add(noteMiss);

        playerStrumline.onSustainHold.add(sustainHold);

        playerStrumline.onGhostTap.add(ghostTap);

        playerStrumline.scrollSpeed = scrollSpeed;

        playerStrumline.botplay = Options.botplay;

        playerStrumline.strums.setPosition(FlxG.width - playerStrumline.strums.width - 45.0, playerStrumline.downscroll ?
            FlxG.height - playerStrumline.strums.height - 15.0 : 15.0);

        strumlines.add(playerStrumline);

        onUpdateScore = new FlxTypedSignal<(playStats:PlayStats)->Void>();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (conductor.time > 0.0)
            timerNeedle.angle = (getSongTime() / getSongLength()) * 360.0;
    }

    override function destroy():Void
    {
        super.destroy();

        conductor?.onStepHit?.remove(stepHit);

        onUpdateScore = cast FlxDestroyUtil.destroy(onUpdateScore);
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

            onUpdateScore.dispatch(playStats);

            updateScoreText();
        }

        healthBar.value += rating.health;
    }

    public function noteMiss(note:Note):Void
    {
        playStats.score -= 500;

        playStats.misses++;

        onUpdateScore.dispatch(playStats);

        healthBar.value -= 2.5;

        updateScoreText();
    }

    public function sustainHold(ev:SustainHoldEvent):Void
    {
        if (!ev.note.strumline.botplay)
        {
            playStats.score += Math.floor(250.0 * ev.elapsed);

            onUpdateScore.dispatch(playStats);

            updateScoreText();
        }

        healthBar.value += 10.0 * ev.elapsed;
    }

    public function ghostTap(ev:GhostTapEvent):Void
    {
        if (!ev.ghostTapping)
        {
            playStats.score -= 500;

            playStats.misses++;

            onUpdateScore.dispatch(playStats);

            healthBar.value -= 2.5;

            updateScoreText();
        }
    }

    public function setScrollSpeed(v:Float):Void
    {
        scrollSpeed = v;

        opponentStrumline.scrollSpeed = scrollSpeed;

        playerStrumline.scrollSpeed = scrollSpeed;
    }
}