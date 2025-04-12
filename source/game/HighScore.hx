package game;

import flixel.FlxG;

class HighScore
{
    public static var weeks(get, never):Map<String, WeekScore>;

    @:noCompletion
    static function get_weeks():Map<String, WeekScore>
    {
        return FlxG.save.data.scores.weeks ??= new Map<String, WeekScore>();
    }

    public static var levels(get, never):Map<String, LevelScore>;

    @:noCompletion
    static function get_levels():Map<String, LevelScore>
    {
        return FlxG.save.data.scores.levels ??= new Map<String, LevelScore>();
    }

    public static var version(get, never):String;

    @:noCompletion
    static function get_version():String
    {
        return FlxG.save.data.scores.version ??= "1.0.0";
    }

    public static function init():Void
    {
        FlxG.save.data.scores ??= {};
    }

    public static function isLevelHighScore(name:String, diff:String, score:Int):Bool
    {
        var level:LevelScore = levels[name] ??= getBlankLevel();

        return score > level.difficulties[diff];
    }

    public static function getLevelScore(name:String, diff:String):Int
    {
        var level:LevelScore = levels[name] ??= getBlankLevel();

        return level.difficulties[diff];
    }

    public static function setLevelScore(name:String, diff:String, score:Int):Void
    {
        var level:LevelScore = levels[name] ??= getBlankLevel();

        level.difficulties[diff] = score;
    }

    public static function isWeekHighScore(name:String, diff:String, score:Int):Bool
    {
        var week:WeekScore = weeks[name] ??= getBlankWeek();

        return score > week.difficulties[diff];
    }

    public static function getWeekScore(name:String, diff:String):Int
    {
        var week:WeekScore = weeks[name] ??= getBlankWeek();

        return week.difficulties[diff];
    }

    public static function setWeekScore(name:String, diff:String, score:Int):Void
    {
        var week:WeekScore = weeks[name] ??= getBlankWeek();

        week.difficulties[diff] = score;
    }

    public static function getBlankLevel():LevelScore
    {
        return {difficulties: new Map<String, Int>()}
    }

    public static function getBlankWeek():WeekScore
    {
        return {difficulties: new Map<String, Int>()}
    }
}

typedef LevelScore =
{
    public var difficulties:Map<String, Int>;
}

typedef WeekScore = LevelScore;