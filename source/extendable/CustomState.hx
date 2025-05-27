package extendable;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;

import flixel.animation.FlxAnimation;

import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxTimer.FlxTimerManager;

import flixel.addons.display.FlxBackdrop;

import core.Assets;

import music.Conductor;

using util.ArrayUtil;

/**
 * An extended `flixel.FlxState` with a few additional resources.
 */
class CustomState extends FlxState
{
    public var tween:FlxTweenManager;

    public var timer:FlxTimerManager;

    public var conductor:Conductor;

    override function create():Void
    {
        super.create();

        persistentUpdate = true;

        tween = new FlxTweenManager();

        add(tween);

        timer = new FlxTimerManager();

        add(timer);

        conductor = new Conductor();

        conductor.active = false;

        conductor.onStepHit.add(stepHit);

        conductor.onBeatHit.add(beatHit);
        
        conductor.onMeasureHit.add(measureHit);

        add(conductor);

        openSubState(new CustomTransition(OUT, () -> { persistentUpdate = false; closeSubState(); } ));
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
        openSubState(new CustomTransition(IN, onOutroComplete));
    }

    public function getTransitionSprite(duration:Float, fade:CustomTransitionFade):FlxSprite
    {
        var spr:CustomTransitionSprite = new CustomTransitionSprite(duration, fade, null);
        
        spr.onFinish = spr.kill;

        add(spr);

        return spr;
    }

    public function stepHit(step:Int):Void
    {

    }

    public function beatHit(beat:Int):Void
    {

    }

    public function measureHit(measure:Int):Void
    {

    }
}

class CustomTransition extends FlxSubState
{
    public var fade:CustomTransitionFade;
    
    public var onFinish:()->Void;

    public function new(fad:CustomTransitionFade, onFinis:()->Void):Void
    {
        super();

        fade = fad;

        onFinish = onFinis;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.last();

        getTransitionSprite();
    }

    public function getTransitionSprite():FlxSprite
    {
        var spr:CustomTransitionSprite = new CustomTransitionSprite(0.5, fade, onFinish);

        add(spr);

        return spr;
    }
}

class CustomTransitionSprite extends FlxBackdrop
{
    public var duration:Float;

    public var fade:CustomTransitionFade;

    public var onFinish:()->Void;

    public function new(durat:Float, fad:CustomTransitionFade, onFinis:()->Void):Void
    {
        super();

        camera = FlxG.cameras.list.last();

        duration = durat;

        fade = fad;

        onFinish = onFinis;

        loadGraphic(Assets.getGraphic("extendable/CustomState/gradient"), true, 16, 16);

        animation.onFinish.add((name:String) -> if (onFinish != null) onFinish());

		animation.add("fade", [0, 1, 2, 3, 4, 5, 6], 12, false);

        var anim:FlxAnimation = animation.getByName("fade");

        anim.frameRate = anim.numFrames / duration;

		animation.play("fade", true, fade == IN);
    }
}

enum CustomTransitionFade
{
    IN;

    OUT;
}