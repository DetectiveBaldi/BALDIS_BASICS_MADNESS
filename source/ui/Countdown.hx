package ui;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;

import flixel.sound.FlxSound;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxSignal.FlxTypedSignal;

import core.Assets;
import core.Paths;

import music.Conductor;

/**
 * A `flixel.group.FlxGroup` representing the countdown you see in `game.PlayState`.
 */
class Countdown extends FlxGroup
{
    public var conductor(default, set):Conductor;

    @:noCompletion
    function set_conductor(_conductor:Conductor):Conductor
    {
        var __conductor:Conductor = conductor;

        conductor = _conductor;

        conductor?.onBeatHit?.add(beatHit);

        __conductor?.onBeatHit?.remove(beatHit);

        return conductor;
    }

    public var started:Bool;

    public var onStart:FlxSignal;

    public var tick:Int;

    public var onTick:FlxTypedSignal<(tick:Int)->Void>;

    public var paused:Bool;

    public var onPause:FlxSignal;

    public var onResume:FlxSignal;

    public var finished:Bool;

    public var onFinish:FlxSignal;

    public var skipped:Bool;

    public var onSkip:FlxSignal;

    public var tween:FlxTweenManager;

    public var threeSpr:FlxSprite;

    public var twoSpr:FlxSprite;

    public var oneSpr:FlxSprite;

    public var goSpr:FlxSprite;

    public var countdownSnd:FlxSound;

    public function new(_conductor:Conductor):Void
    {
        super();

        conductor = _conductor;

        started = false;

        onStart = new FlxSignal();

        tick = 0;

        onTick = new FlxTypedSignal<(tick:Int)->Void>();

        paused = false;

        onPause = new FlxSignal();

        onResume = new FlxSignal();

        finished = false;

        onFinish = new FlxSignal();

        skipped = false;

        onSkip = new FlxSignal();

        tween = new FlxTweenManager();

        add(tween);

        threeSpr = createCountdownSprite("three");

        threeSpr.setPosition(-threeSpr.width * 0.45, -threeSpr.height);

        twoSpr = createCountdownSprite("two");

        twoSpr.setPosition(FlxG.width - twoSpr.width * 0.55, -twoSpr.height);

        oneSpr = createCountdownSprite("one");

        oneSpr.setPosition(-oneSpr.width * 0.45, FlxG.height);

        goSpr = createCountdownSprite("go");

        goSpr.scale.set(3.0, 3.0);

        goSpr.updateHitbox();

        goSpr.setPosition((FlxG.width - goSpr.width) * 0.5, FlxG.height);

        countdownSnd = FlxG.sound.load(Assets.getSound("ui/Countdown/threeSnd"), 0.65);
    }

    override function destroy():Void
    {
        super.destroy();

        onStart = cast FlxDestroyUtil.destroy(onStart);

        onTick = cast FlxDestroyUtil.destroy(onTick);

        onFinish = cast FlxDestroyUtil.destroy(onFinish);

        onSkip = cast FlxDestroyUtil.destroy(onSkip);

        countdownSnd.destroy();
    }

    public function start():Void
    {
        started = true;

        onStart.dispatch();
    }

    public function pause():Void
    {
        tween.active = false;

        countdownSnd.pause();

        paused = true;

        onPause.dispatch();
    }

    public function resume():Void
    {
        tween.active = true;

        countdownSnd.resume();

        paused = false;

        onResume.dispatch();
    }

    public function beatHit(beat:Int):Void
    {
        if (!started || paused || finished || skipped)
            return;

        switch (tick:Int)
        {
            case 0:
            {
                tween.tween(threeSpr, {y: 0.0}, conductor.beatLength * 0.5 * 0.001, {ease: FlxEase.quartOut});

                countdownSnd.play();
            }

            case 1:
            {
                tween.tween(twoSpr, {y: (FlxG.height - twoSpr.height) * 0.5}, conductor.beatLength * 0.5 * 0.001, 
                    {ease: FlxEase.quartOut});

                countdownSnd.loadEmbedded(Assets.getSound("ui/Countdown/twoSnd"));

                countdownSnd.play();
            }

            case 2:
            {
                tween.tween(oneSpr, {y: FlxG.height - oneSpr.height}, conductor.beatLength * 0.5 * 0.001, 
                    {ease: FlxEase.quartOut});

                countdownSnd.loadEmbedded(Assets.getSound("ui/Countdown/oneSnd"));

                countdownSnd.play();
            }

            case 3:
            {
                tween.tween(threeSpr, {x: -threeSpr.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tween.tween(twoSpr, {x: FlxG.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tween.tween(oneSpr, {x: -oneSpr.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tween.tween(goSpr, {y: FlxG.height - goSpr.height * 0.75}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartOut});
                
                countdownSnd.loadEmbedded(Assets.getSound("ui/Countdown/goSnd"));

                countdownSnd.play();
            }

            case 4:
            {
                tween.tween(goSpr, {y: FlxG.height}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartIn});

                finished = true;

                onFinish.dispatch();
            }
        }

        tick++;

        onTick.dispatch(tick);
    }

    public function createCountdownSprite(name:String):FlxSprite
    {
        var sprite:FlxSprite = new FlxSprite(0.0, 0.0, Assets.getGraphic('ui/Countdown/${name}Spr'));

        sprite.scale.set(1.5, 1.5);

        sprite.updateHitbox();

        add(sprite);

        return sprite;
    }
}