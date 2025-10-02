package data;

import flixel.util.FlxColor;

using util.ArrayUtil;

@:structInit
class PlayStats
{
    public static var allGrades:Array<String> = ["A+", "A", "B", "C", "D", "F"];

    public static var gradePercentages:Array<Float> = [97.0, 90.0, 80.0, 70.0, 60.0, 50.0];

    public static function empty():PlayStats
    {
        return {score: 0, hits: 0, misses: 0, bonus: 0.0}
    }

    public static function getColorForGrade(grade:String):FlxColor
    {
        var indexOf:Int = allGrades.indexOf(grade);

        if (indexOf == -1)
            return FlxColor.BLACK;

        return FlxColor.interpolate(0xFF0EF403, 0xFFF70001, indexOf / (allGrades.length - 1));
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

        for (i in 0 ... allGrades.length - 1)
        {
            var gradeStr:String = allGrades[i];

            var percentage:Float = gradePercentages[i];

            if (accuracy >= percentage)
                return gradeStr;
        }

        return allGrades.last();
    }

    public function isEmpty():Bool
    {
        return score == 0 && hits == 0 && misses == 0 && bonus == 0.0;
    }

    public function concat(...stats:PlayStats):Void
    {
        for (i in 0 ... stats.length)
        {
            var stat:PlayStats = stats[i];

            score += stat.score;

            hits += stat.hits;

            misses += stat.misses;

            bonus += stat.bonus;
        }
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