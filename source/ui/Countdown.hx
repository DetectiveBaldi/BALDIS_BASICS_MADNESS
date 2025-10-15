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

import interfaces.ISequenceHandler;

import music.Conductor;

using util.MathUtil;

class Countdown extends FlxGroup
{
    public var conductor:Conductor;

    public var tweens:FlxTweenManager;

    public var tick:Int;

    public var threeSpr:FlxSprite;

    public var twoSpr:FlxSprite;

    public var oneSpr:FlxSprite;

    public var goSpr:FlxSprite;

    public var threeSnd:FlxSound;

    public var twoSnd:FlxSound;

    public var oneSnd:FlxSound;

    public var goSnd:FlxSound;

    public function new(beatDispatcher:IBeatDispatcher, sequenceHandler:ISequenceHandler):Void
    {
        super();

        conductor = beatDispatcher.conductor;

        conductor.onBeatHit.add(beatHit);

        tweens = sequenceHandler.tweens;

        tick = 0;

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

        conductor?.onBeatHit?.remove(beatHit);

        stopSounds();
    }

    public function beatHit(beat:Int):Void
    {
        switch (tick:Int)
        {
            case 0:
            {
                tweens.tween(threeSpr, {y: 0.0}, conductor.beatLength * 0.5 * 0.001, {ease: FlxEase.quartOut});

                threeSnd.play();
            }

            case 1:
            {
                tweens.tween(twoSpr, {y: twoSpr.getCenterY()}, conductor.beatLength * 0.5 * 0.001, 
                    {ease: FlxEase.quartOut});

                twoSnd.play();
            }

            case 2:
            {
                tweens.tween(oneSpr, {y: FlxG.height - oneSpr.height}, conductor.beatLength * 0.5 * 0.001, 
                    {ease: FlxEase.quartOut});

                oneSnd.play();
            }

            case 3:
            {
                tweens.tween(threeSpr, {x: -threeSpr.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tweens.tween(twoSpr, {x: FlxG.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tweens.tween(oneSpr, {x: -oneSpr.width}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tweens.tween(goSpr, {y: FlxG.height - goSpr.height * 0.75}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartOut});
                
                goSnd.play();
            }

            case 4:
            {
                tweens.tween(goSpr, {y: FlxG.height}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartIn});
            }

            case 5:
                kill();
        }

        tick++;
    }

    public function skip():Void
    {
        kill();

        conductor.update(0.0);
        
        conductor.onBeatHit.remove(beatHit);

        stopSounds(false);
    }

    public function createCountdownSprite(name:String):FlxSprite
    {
        var sprite:FlxSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic('ui/Countdown/${name}Spr'));

        sprite.scale.set(1.5, 1.5);

        sprite.updateHitbox();

        add(sprite);

        return sprite;
    }

    public function stopSounds(destroySounds:Bool = true):Void
    {
        threeSnd.stop();

        twoSnd.stop();

        oneSnd.stop();

        goSnd.stop();

        if (destroySounds)
        {
            threeSnd.destroy();

            twoSnd.destroy();

            oneSnd.destroy();

            goSnd.destroy();
        }
    }
}