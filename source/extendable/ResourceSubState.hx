package extendable;

import flixel.FlxSubState;

import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxTimer.FlxTimerManager;

import music.Conductor;

/**
 * An extended `flixel.FlxSubState` with a few additional resources.
 */
class ResourceSubState extends FlxSubState
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