package music;

import flixel.FlxBasic;

import flixel.util.FlxDestroyUtil;

import flixel.util.FlxSignal.FlxTypedSignal;

import data.Chart.TimeChange;

using util.ArrayUtil;

class Conductor extends FlxBasic
{
    public var decStep(get, never):Float;

    @:noCompletion
    function get_decStep():Float
    {
        return (time - timeChange.time) / stepLength + timeChange.step;
    }

    public var decBeat(get, never):Float;

    @:noCompletion
    function get_decBeat():Float
    {
        return decStep * 0.25;
    }

    public var decMeasure(get, never):Float;

    @:noCompletion
    function get_decMeasure():Float
    {
        return decBeat * 0.25;
    }

    public var step(get, never):Int;

    @:noCompletion
    function get_step():Int
    {
        return Math.floor(decStep);
    }

    public var beat(get, never):Int;

    @:noCompletion
    function get_beat():Int
    {
        return Math.floor(decBeat);
    }

    public var measure(get, never):Int;

    @:noCompletion
    function get_measure():Int
    {
        return Math.floor(decMeasure);
    }

    public var onStepHit:FlxTypedSignal<(step:Int)->Void>;

    public var onBeatHit:FlxTypedSignal<(beat:Int)->Void>;

    public var onMeasureHit:FlxTypedSignal<(measure:Int)->Void>;

    public var tempo:Float;

    public var stepLength(get, never):Float;

    @:noCompletion
    function get_stepLength():Float
    {
        return 60.0 / tempo * 0.25 * 1000.0;
    }

    public var beatLength(get, never):Float;

    @:noCompletion
    function get_beatLength():Float
    {
        return stepLength * 4.0;
    }

    public var time:Float;

    public var timeChange:TimeChange;

    public var timeChanges:Array<TimeChange>;

    public function new():Void
    {
        super();

        visible = false;

        onStepHit = new FlxTypedSignal<(step:Int)->Void>();

        onBeatHit = new FlxTypedSignal<(beat:Int)->Void>();

        onMeasureHit = new FlxTypedSignal<(measure:Int)->Void>();

        tempo = 100.0;

        time = 0.0;

        timeChange = {time: 0.0, tempo: 100.0, step: 0.0};

        timeChanges = new Array<TimeChange>();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        var lastStep:Int = step;

        var lastBeat:Int = beat;

        var lastMeasure:Int = measure;

        time += elapsed * 1000.0;

        if (timeChanges.length > 0.0)
        {
            var newTimeChange:TimeChange = timeChanges.last((timeCh:TimeChange) -> time >= timeCh.time);

            if (newTimeChange != null)
            {
                var newTempo:Float = newTimeChange.tempo;

                if (tempo != newTempo)
                {
                    var lastTime:Float = timeChange.time;

                    timeChange.time = newTimeChange.time;

                    timeChange.tempo = newTempo;

                    timeChange.step += (timeChange.time - lastTime) / stepLength;

                    tempo = timeChange.tempo;
                }
            }
        }

        if (step != lastStep)
            onStepHit.dispatch(step);

        if (beat != lastBeat)
            onBeatHit.dispatch(beat);

        if (measure != lastMeasure)
            onMeasureHit.dispatch(measure);
    }

    override function destroy():Void
    {
        super.destroy();

        onStepHit = cast FlxDestroyUtil.destroy(onStepHit);

        onBeatHit = cast FlxDestroyUtil.destroy(onBeatHit);

        onMeasureHit = cast FlxDestroyUtil.destroy(onMeasureHit);

        timeChange = null;

        timeChanges = null;
    }
}