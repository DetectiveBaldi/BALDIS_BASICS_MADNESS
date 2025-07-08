package music;

import flixel.FlxBasic;

import flixel.util.FlxDestroyUtil;

import flixel.util.FlxSignal.FlxTypedSignal;

import data.Chart.TimeChangeSchema;

/**
 * A class which handles musical timing events throughout the game. It is the heart of `game.PlayState`.
 */
class Conductor extends FlxBasic
{
    public var preciseStep(get, never):Float;

    @:noCompletion
    function get_preciseStep():Float
    {
        return (time - timeChange.time) / stepLength + timeChange.step;
    }

    public var preciseBeat(get, never):Float;

    @:noCompletion
    function get_preciseBeat():Float
    {
        return preciseStep * 0.25;
    }

    public var preciseMeasure(get, never):Float;

    @:noCompletion
    function get_preciseMeasure():Float
    {
        return preciseBeat * 0.25;
    }

    public var step(get, never):Int;

    @:noCompletion
    function get_step():Int
    {
        return Math.floor(preciseStep);
    }

    public var beat(get, never):Int;

    @:noCompletion
    function get_beat():Int
    {
        return Math.floor(preciseBeat);
    }

    public var measure(get, never):Int;

    @:noCompletion
    function get_measure():Int
    {
        return Math.floor(preciseMeasure);
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

    public var timeChange:TimeChangeSchema;

    public var timeChanges:Array<TimeChangeSchema>;

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

        timeChanges = new Array<TimeChangeSchema>();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        var lastStep:Int = step;

        var lastBeat:Int = beat;

        var lastMeasure:Int = measure;

        time += elapsed * 1000.0;

        var i:Int = timeChanges.length - 1;

        while (i >= 0)
        {
            var newTimeChange = timeChanges[i];
            
            if (time < newTimeChange.time)
            {
                i--;

                continue;
            }

            if (tempo != newTimeChange.tempo)
            {
                var lastTime:Float = timeChange.time;

                timeChange.time = newTimeChange.time;

                timeChange.tempo = newTimeChange.tempo;

                timeChange.step += (timeChange.time - lastTime) / stepLength;

                tempo = timeChange.tempo;
            }
            
            break;
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