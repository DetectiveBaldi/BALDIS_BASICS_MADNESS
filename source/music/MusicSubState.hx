package music;

import extendable.ResourceSubState;

/**
 * An extended `extendable.ResourceSubState` designed to support musical timing events.
 */
class MusicSubState extends ResourceSubState
{
    public var conductor:Conductor;

    override function create():Void
    {
        super.create();

        conductor = new Conductor();

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