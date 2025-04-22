package extendable;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;

import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxTimer;

import flixel.util.FlxTimer.FlxTimerManager;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

import music.Conductor;

using util.ArrayUtil;

/**
 * An extended `flixel.FlxState` with a few additional resources.
 */
class ResourceState extends FlxState
{
    public static var skipTransition:Bool = false;

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

        if (!skipTransition)
            openSubState(new CustomTransition(OUT));
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
        if (skipTransition)
        {
            super.startOutro(onOutroComplete);

            return;
        }

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
    
    public var onComplete:()->Void;

    public function new(_fade:CustomTransitionFade, _onComplete:()->Void = null):Void
    {
        super();

        fade = _fade;

        onComplete = _onComplete;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.newest();

        var backdrop:FlxBackdrop = new FlxBackdrop();

        backdrop.loadGraphic(Assets.getGraphic("extendable/ResourceState/gradient"), true, 16, 16);

		backdrop.animation.add("this", [for (i in 0 ... 7) i], 12, false);

		backdrop.animation.play("this", true, fade == IN);

		add(backdrop);

        FlxTimer.wait(0.5, () ->
        {
            if (fade == OUT)
                close();

            if (onComplete != null)
                onComplete();
        });
    }

    override function destroy():Void
    {
        super.destroy();

        onComplete = null;
    }
}

enum CustomTransitionFade
{
    IN;

    OUT;
}