package music;

import flixel.FlxBasic;

import flixel.util.FlxDestroyUtil;

import flixel.util.FlxSignal.FlxTypedSignal;

import data.Chart.RawTimeChange;

/**
 * A class which handles musical timing events throughout the game. It is the heart of `game.PlayState`.
 */
class Conductor extends FlxBasic
{
    public var step:Int;

    public var beat:Int;

    public var measure:Int;

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

    public var timeChange:RawTimeChange;

    public var timeChanges:Array<RawTimeChange>;

    public function new():Void
    {
        super();

        visible = false;

        step = 0;

        beat = 0;

        measure = 0;

        onStepHit = new FlxTypedSignal<(step:Int)->Void>();

        onBeatHit = new FlxTypedSignal<(beat:Int)->Void>();

        onMeasureHit = new FlxTypedSignal<(measure:Int)->Void>();

        tempo = 100.0;

        time = 0.0;

        timeChange = {time: 0.0, tempo: 100.0, step: 0.0};

        timeChanges = new Array<RawTimeChange>();
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
            var newTimeChange:RawTimeChange = timeChanges[i];
            
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

        step = Math.floor(((time - timeChange.time) / stepLength) + timeChange.step);

        beat = Math.floor(step * 0.25);

        measure = Math.floor(beat * 0.25);

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