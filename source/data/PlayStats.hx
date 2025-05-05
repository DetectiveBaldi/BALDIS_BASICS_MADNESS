package data;

@:structInit
class PlayStats
{
    public static function empty():PlayStats
    {
        return {score: 0, hits: 0, misses: 0, bonus: 0.0}
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

    public function concat(...stats:PlayStats):PlayStats
    {
        var result:PlayStats = copy();

        for (i in 0 ... stats.length)
        {
            var stat:PlayStats = stats[i];

            result.score += stat.score;

            result.hits += stat.hits;

            result.misses += stat.misses;

            result.bonus += stat.bonus;
        }

        return result;
    }

    public function copy():PlayStats
    {
        return {score: score, hits: hits, misses: misses, bonus: bonus}
    }
}