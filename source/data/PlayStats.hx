package data;

import flixel.util.FlxColor;

using util.ArrayUtil;

@:structInit
class PlayStats
{
    public static var grades:Array<String> = ["A+", "A", "B", "C", "D", "F"];

    public static var gradeThreshold:Array<Float> = [97.0, 90.0, 80.0, 70.0, 60.0, 50.0];

    public static function empty():PlayStats
    {
        return {score: 0, hits: 0, misses: 0, bonus: 0.0}
    }

    public static function getColor(grade:String):FlxColor
    {
        if (!grades.contains(grade))
            return FlxColor.BLACK;

        var i:Int = grades.indexOf(grade);

        return FlxColor.interpolate(0xFF0EF403, 0xFFF70001, i / (grades.length - 1.0));
    }
    
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

        for (i in 0 ... grades.length - 1)
        {
            if (accuracy >= gradeThreshold[i])
                return grades[i];
        }

        return grades.last();
    }

    public function isEmpty():Bool
    {
        return hits == 0 && misses == 0;
    }

    public function concat(stats:PlayStats):Void
    {
        score += stats.score;

        hits += stats.hits;

        misses += stats.misses;

        bonus += stats.bonus;
    }

    public function copy():PlayStats
    {
        return {score: score, hits: hits, misses: misses, bonus: bonus}
    }

    public function toString():String
    {
        return 'Score: ${score}, Grade: ${grade}';
    }
}