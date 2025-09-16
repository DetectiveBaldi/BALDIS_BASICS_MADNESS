package music;

import data.Chart.TimingPointData;

@:structInit
class TimingPoint
{
    public var time:Float;

    public var tempo:Float;

    public var beatLength(get, never):Float;

    @:noCompletion
    function get_beatLength():Float
    {
        return 60.0 / tempo * 1000.0;
    }

    public var beatOffset:Float;

    public function new(time:Float, tempo:Float):Void
    {
        this.time = time;

        this.tempo = tempo;

        beatOffset = 0.0;
    }

    public static function decodeData(v:TimingPointData):TimingPoint
    {
        return {time: v.time, tempo: v.tempo}
    }
}