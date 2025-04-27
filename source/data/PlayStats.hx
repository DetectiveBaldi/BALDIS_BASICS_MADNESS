package data;

@:structInit
class PlayStats
{
    public var score:Int;

    public var hits:Int;

    public var misses:Int;

    public var bonus:Float;

    public var accuracy(get, never):Float;

    @:noCompletion
    function get_accuracy():Float
    {
        return bonus / (hits + misses) * 100.0;
    }

    public var grade(get, never):String;

    @:noCompletion
    function get_grade():String
    {
        if (Math.isNaN(accuracy))
            return "N/A";

        if (accuracy >= 97.0)
            return "A+";

        if (accuracy >= 90.0)
            return "A";

        if (accuracy >= 80.0)
            return "B";

        if (accuracy >= 70.0)
            return "C";

        if (accuracy >= 60.0)
            return "D";

        return "F";
    }
}