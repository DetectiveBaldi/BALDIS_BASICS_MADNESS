package extendable;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;

import flixel.animation.FlxAnimation;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import flixel.addons.display.FlxBackdrop;

import core.AssetCache;

using util.ArrayUtil;

class TransitionState extends FlxState
{
    public static var cancelFadeIn:Bool;

    public static var cancelFadeOut:Bool;

    public static function cancelNextTransition():Void
    {
        cancelFadeIn = true;

        cancelFadeOut = true;
    }

    override function create():Void
    {
        super.create();

        if (!cancelFadeIn)
        {
            persistentUpdate = true;

            openSubState(new CustomTransition(IN, () ->
            {
                persistentUpdate = false;
                
                closeSubState();
            }));
        }

        cancelFadeIn = false;
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
        if (cancelFadeOut)
        {
            cancelFadeOut = false;

            onOutroComplete();

            return;
        }

        persistentUpdate = false;

        openSubState(new CustomTransition(OUT, onOutroComplete));
    }

    public function getTransitionSprite(duration:Float, fade:CustomTransitionFade, onFinish:()->Void):CustomTransitionSprite
    {
        var spr:CustomTransitionSprite = new CustomTransitionSprite(duration, fade);
        
        spr.onFinish.add(spr.kill);

        spr.onFinish.add(onFinish);

        add(spr);

        return spr;
    }
}

class CustomTransition extends FlxSubState
{
    public var fade:CustomTransitionFade;
    
    public var onFinish:()->Void;

    public function new(fade:CustomTransitionFade, onFinish:()->Void):Void
    {
        super();

        this.fade = fade;

        this.onFinish = onFinish;
    }

    override function create():Void
    {
        super.create();

        var spr:CustomTransitionSprite = getTransitionSprite();

        add(spr);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        camera = FlxG.cameras.list.last();
    }

    public function getTransitionSprite():CustomTransitionSprite
    {
        var spr:CustomTransitionSprite = new CustomTransitionSprite(0.5, fade);

        spr.onFinish.add(onFinish);

        return spr;
    }
}

class CustomTransitionSprite extends FlxBackdrop
{
    public var duration:Float;

    public var fade:CustomTransitionFade;

    public var onFinish:FlxSignal;

    public function new(duration:Float, fade:CustomTransitionFade):Void
    {
        super();

        this.duration = duration;

        this.fade = fade;

        onFinish = new FlxSignal();

        loadGraphic(AssetCache.getGraphic("extendable/TransitionState/gradient"), true, 16, 16);

        animation.onFinish.add((name:String) -> onFinish.dispatch());

		animation.add("fade", [0, 1, 2, 3, 4, 5, 6], 12, false);

        var anim:FlxAnimation = animation.getByName("fade");

        anim.frameRate = anim.numFrames / duration;

		animation.play("fade", true, fade == OUT);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        camera = FlxG.cameras.list.last();
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