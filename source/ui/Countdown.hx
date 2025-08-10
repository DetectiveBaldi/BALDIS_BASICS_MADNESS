package ui;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;

import flixel.sound.FlxSound;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxSignal.FlxTypedSignal;

import core.AssetCache;

import music.Conductor;

using util.MathUtil;

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

    public var threeSnd:FlxSound;

    public var twoSnd:FlxSound;

    public var oneSnd:FlxSound;

    public var goSnd:FlxSound;

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

        goSpr.setPosition(goSpr.getCenterX(), FlxG.height);

        threeSnd = FlxG.sound.load(AssetCache.getSound("ui/Countdown/threeSnd"), 0.65);

        twoSnd = FlxG.sound.load(AssetCache.getSound("ui/Countdown/twoSnd"), 0.65);

        oneSnd = FlxG.sound.load(AssetCache.getSound("ui/Countdown/oneSnd"), 0.65);

        goSnd = FlxG.sound.load(AssetCache.getSound("ui/Countdown/goSnd"), 0.65);
    }

    override function destroy():Void
    {
        super.destroy();

        onStart = cast FlxDestroyUtil.destroy(onStart);

        onTick = cast FlxDestroyUtil.destroy(onTick);

        onFinish = cast FlxDestroyUtil.destroy(onFinish);

        onSkip = cast FlxDestroyUtil.destroy(onSkip);

        threeSnd.destroy();

        twoSnd.destroy();

        oneSnd.destroy();

        goSnd.destroy();
    }

    public function start():Void
    {
        started = true;

        onStart.dispatch();
    }

    public function pause():Void
    {
        tween.active = false;

        threeSnd.pause();

        twoSnd.pause();

        oneSnd.pause();

        goSnd.pause();

        paused = true;

        onPause.dispatch();
    }

    public function resume():Void
    {
        tween.active = true;

        threeSnd.resume();

        twoSnd.resume();

        oneSnd.resume();

        goSnd.resume();

        paused = false;

        onResume.dispatch();
    }

    public function skip():Void
    {
        kill();

        skipped = true;

        onSkip.dispatch();
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

                threeSnd.play();
            }

            case 1:
            {
                tween.tween(twoSpr, {y: twoSpr.getCenterY()}, conductor.beatLength * 0.5 * 0.001, 
                    {ease: FlxEase.quartOut});

                twoSnd.play();
            }

            case 2:
            {
                tween.tween(oneSpr, {y: FlxG.height - oneSpr.height}, conductor.beatLength * 0.5 * 0.001, 
                    {ease: FlxEase.quartOut});

                oneSnd.play();
            }

            case 3:
            {
                tween.tween(threeSpr, {x: -threeSpr.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tween.tween(twoSpr, {x: FlxG.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tween.tween(oneSpr, {x: -oneSpr.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tween.tween(goSpr, {y: FlxG.height - goSpr.height * 0.75}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartOut});
                
                goSnd.play();
            }

            case 4:
            {
                tween.tween(goSpr, {y: FlxG.height}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartIn});

                finished = true;

                onFinish.dispatch();
            }

            case 5:
                kill();
        }

        tick++;

        onTick.dispatch(tick);
    }

    public function createCountdownSprite(name:String):FlxSprite
    {
        var sprite:FlxSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic('ui/Countdown/${name}Spr'));

        sprite.scale.set(1.5, 1.5);

        sprite.updateHitbox();

        add(sprite);

        return sprite;
    }
}