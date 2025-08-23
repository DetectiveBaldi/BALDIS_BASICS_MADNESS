package extendable;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;

import flixel.animation.FlxAnimation;

import flixel.math.FlxRect;

import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer.FlxTimerManager;

import flixel.addons.display.FlxBackdrop;

import core.AssetCache;

import music.Conductor;

using util.ArrayUtil;

class CustomState extends FlxState
{
    public static var cancelFadeOut:Bool;

    public static var cancelFadeIn:Bool;

    public static function cancelNextTransition():Void
    {
        CustomState.cancelFadeIn = true;

        CustomState.cancelFadeOut = true;
    }

    public var tween:FlxTweenManager;

    public var timer:FlxTimerManager;

    public var conductor:Conductor;

    override function create():Void
    {
        super.create();

        if (!cancelFadeOut)
            persistentUpdate = true;

        tween = new FlxTweenManager();

        add(tween);

        timer = new FlxTimerManager();

        add(timer);

        conductor = new Conductor();

        conductor.onStepHit.add(stepHit);

        conductor.onBeatHit.add(beatHit);
        
        conductor.onMeasureHit.add(measureHit);

        if (!cancelFadeOut)
            openSubState(new CustomTransition(OUT, () -> { persistentUpdate = false; closeSubState(); } ));

        cancelFadeOut = false;
    }

    override function openSubState(newSubState:FlxSubState):Void
    {
        super.openSubState(newSubState);

        var typeOf:Class<FlxSubState> = Type.getClass(newSubState);

        // If the sub state trying to open ISN'T of type `CustomTransition`, proceed.
        if (typeOf != CustomTransition)
        {
            // Get type of current sub state.
            typeOf = Type.getClass(subState);

            /**
             * We set `persistentUpdate` to false here because Flixel has internally already closed the `CustomTransition`
             * sub state, but it hasn't (and won't) dispatched the sub state's `close` method, which WOULD set this to false.
             * Therefore, we have to do it ourselves here.
             */
            if (typeOf == CustomTransition)
                persistentUpdate = false;
        }
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
        if (cancelFadeIn)
        {
            onOutroComplete();

            cancelFadeIn = false;

            return;
        }

        persistentUpdate = false;

        openSubState(new CustomTransition(IN, onOutroComplete));
    }

    public function getTransitionSprite(duration:Float, fade:CustomTransitionFade, onFinish:()->Void):FlxSprite
    {
        var spr:CustomTransitionSprite = new CustomTransitionSprite(duration, fade, onFinish);
        
        spr.onFinish.add(spr.kill);

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

    public var onFinish:FlxSignal;

    public function new(durat:Float, fad:CustomTransitionFade, onFinis:()->Void):Void
    {
        super();

        camera = FlxG.cameras.list.last();

        duration = durat;

        fade = fad;

        onFinish = new FlxSignal();

        onFinish.add(onFinis);

        loadGraphic(AssetCache.getGraphic("extendable/CustomState/gradient"), true, 16, 16);

        animation.onFinish.add((name:String) -> onFinish.dispatch());

		animation.add("fade", [0, 1, 2, 3, 4, 5, 6], 12, false);

        var anim:FlxAnimation = animation.getByName("fade");

        anim.frameRate = anim.numFrames / duration;

		animation.play("fade", true, fade == IN);
    }

    override function destroy():Void
    {
        super.destroy();

        onFinish = cast FlxDestroyUtil.destroy(onFinish);
    }
}

enum CustomTransitionFade
{
    IN;

    OUT;
}