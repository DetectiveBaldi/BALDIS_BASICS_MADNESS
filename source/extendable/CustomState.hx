package extendable;

import openfl.display.Sprite;

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

import core.Assets;

import music.Conductor;

using util.ArrayUtil;

/**
 * An extended `flixel.FlxState` with a few additional resources.
 */
class CustomState extends FlxState
{
    public var mouseRect:FlxRect;

    public var tween:FlxTweenManager;

    public var timer:FlxTimerManager;

    public var conductor:Conductor;

    override function create():Void
    {
        super.create();

        persistentUpdate = true;

        mouseRect = FlxRect.get();

        FlxG.stage.window.onMouseMove.add(updateMouseRect);

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

    override function destroy():Void
    {
        mouseRect.put();

        FlxG.stage.window.onMouseMove.remove(updateMouseRect);
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
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

    public function updateMouseRect(x:Float, y:Float):Void
    {
        var mouseX:Int = Math.floor(x);

        var mouseY:Int = Math.floor(y);

        if (!mouseRect.isEmpty)
        {
            // Thanks Arcadia.
            
            var left:Int = Math.floor(mouseRect.left * FlxG.scaleMode.scale.x);

            var top:Int = Math.floor(mouseRect.top * FlxG.scaleMode.scale.y);

            var bottom:Int = Math.floor((mouseRect.bottom - mouseRect.y) * FlxG.scaleMode.scale.y);

            var right:Int = Math.floor((mouseRect.right - mouseRect.x) * FlxG.scaleMode.scale.x);

            if (mouseX < left)
                FlxG.stage.window.warpMouse(left, mouseY);

            if (mouseY < top)
                FlxG.stage.window.warpMouse(mouseX, top);

            if (mouseY > bottom)
                FlxG.stage.window.warpMouse(mouseX, bottom);

            if (mouseX > right)
                FlxG.stage.window.warpMouse(right, mouseY);
        }
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

        loadGraphic(Assets.getGraphic("extendable/CustomState/gradient"), true, 16, 16);

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