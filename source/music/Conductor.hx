package music;

import flixel.FlxBasic;

import flixel.util.FlxDestroyUtil;

import flixel.util.FlxSignal.FlxTypedSignal;

import data.Chart.TimingPointData;

using util.ArrayUtil;
using util.TimingUtil;

class Conductor
{
    public var decStep(get, never):Float;

    @:noCompletion
    function get_decStep():Float
    {
        return getStepAt(time);
    }

    public var decBeat(get, never):Float;

    @:noCompletion
    function get_decBeat():Float
    {
        return getBeatAt(time);
    }

    public var decMeasure(get, never):Float;

    @:noCompletion
    function get_decMeasure():Float
    {
        return getMeasureAt(time);
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

    public var tempo(get, never):Float;

    @:noCompletion
    function get_tempo():Float
    {
        return getTimingPointAtTime(time).tempo;
    }

    public var stepLength(get, never):Float;

    @:noCompletion
    function get_stepLength():Float
    {
        return beatLength * 0.25;
    }

    public var beatLength(get, never):Float;

    @:noCompletion
    function get_beatLength():Float
    {
        return getTimingPointAtTime(time).beatLength;
    }

    public var measureLength(get, never):Float;

    @:noCompletion
    function get_measureLength():Float
    {
        return beatLength * 4.0;
    }

    public var time:Float;

    public var timingPoints:Array<TimingPoint>;

    public function new():Void
    {
        onStepHit = new FlxTypedSignal<(step:Int)->Void>();

        onBeatHit = new FlxTypedSignal<(beat:Int)->Void>();

        onMeasureHit = new FlxTypedSignal<(measure:Int)->Void>();

        time = 0.0;

        timingPoints = new Array<TimingPoint>();
    }

    public function update(time:Float):Void
    {
        var lastStep:Int = step;

        var lastBeat:Int = beat;

        var lastMeasure:Int = measure;

        this.time = time;

        if (step != lastStep)
            onStepHit.dispatch(step);

        if (beat != lastBeat)
            onBeatHit.dispatch(beat);

        if (measure != lastMeasure)
            onMeasureHit.dispatch(measure);
    }

    public function destroy():Void
    {
        onStepHit = cast FlxDestroyUtil.destroy(onStepHit);

        onBeatHit = cast FlxDestroyUtil.destroy(onBeatHit);

        onMeasureHit = cast FlxDestroyUtil.destroy(onMeasureHit);

        timingPoints = null;
    }
    
    public function getTimingPointAtTime(time:Float):TimingPoint
    {
        var res:TimingPoint = timingPoints[0];

        for (i in 1 ... timingPoints.length)
        {
            var timingPoint:TimingPoint = timingPoints[i];

            if (time < timingPoint.time)
                break;

            res = timingPoint;
        }

        return res;
    }

    public function getTimingPointAtBeat(beat:Float):TimingPoint
    {
        var output:TimingPoint = timingPoints[0];

        for (i in 1 ... timingPoints.length)
        {
            var point:TimingPoint = timingPoints[i];

            if (beat < point.beatOffset)
                break;

            output = point;
        }

        return output;
    }

    public function getStepAt(time:Float):Float
    {
        return getBeatAt(time) * 4.0;
    }

    public function getBeatAt(time:Float):Float
    {
        var point:TimingPoint = getTimingPointAtTime(time);
        
        return point.beatOffset + (time - point.time) / point.beatLength;
    }

    public function getMeasureAt(time:Float):Float
    {
        return getBeatAt(time) * 0.25;
    }

    public function stepToTime(step:Float):Float
    {
        return beatToTime(step) * 4.0;
    }

    public function beatToTime(beat:Float):Float
    {
        var point:TimingPoint = getTimingPointAtBeat(beat);

        return point.time + point.beatLength * (beat - point.beatOffset);
    }

    public function measureToTime(measure:Float):Float
    {
        return beatToTime(measure) * 0.25;
    }

    public function writeTimingPointData(list:Array<TimingPointData>):Void
    {
        for (i in 0 ... list.length)
            timingPoints.push(TimingPoint.decodeData(list[i]));
    }

    public function calibrateTimingPoints():Void
    {
        var timeOffset:Float = 0.0;

        var beatOffset:Float = 0.0;

        var lastTempo:Float = 0.0;

        for (timingPoint in timingPoints)
        {
            if (timingPoint.time == 0.0)
            {
                lastTempo = timingPoint.tempo;

                continue;
            }

            beatOffset += (timingPoint.time - timeOffset) / (60.0 / lastTempo * 1000.0);

            timeOffset = timingPoint.time;

            lastTempo = timingPoint.tempo;

            timingPoint.beatOffset = beatOffset;
        }
    }
}