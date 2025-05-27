package extendable;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;

import flixel.animation.FlxAnimation;

import flixel.group.FlxGroup;

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

        openSubState(new CustomTransition(OUT, null));
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
        openSubState(new CustomTransition(IN, onOutroComplete));
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

        var spr:CustomTransitionSprite = CustomTransitionSprite.addToParent(this, 0.5, fade, () ->
        {
            if (fade == OUT)
                close();

            if (onFinish != null)
                onFinish();
        });
    }
}

class CustomTransitionSprite extends FlxBackdrop
{
    public static function addToParent(parent:FlxGroup, duration:Float, fade:CustomTransitionFade,
        onFinish:()->Void):CustomTransitionSprite
    {
        var sprite:CustomTransitionSprite = new CustomTransitionSprite(duration, fade, onFinish);

        parent.add(sprite);

        return sprite;
    }

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