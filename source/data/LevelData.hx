package data;

import flixel.util.typeLimit.NextState;

import game.PlayState;

using util.StringUtil;

using StringTools;

@:structInit
class LevelData
{
    public static var list:Array<LevelData> = new Array<LevelData>();

    public var week:WeekData;

    public var name:String;

    public var difficulty:String;

    public var showInFreeplayMenu:Bool;

    public var obscurity:ObscurityStatus;

    public function new(week:WeekData, name:String, difficulty:String = "Normal"):Void
    {
        this.week = week;

        this.name = name;

        this.difficulty = difficulty;

        showInFreeplayMenu = true;

        obscurity = NONE;
    }

    public function encodeName():String
    {
        var split:Array<String> = name.split(" ");

        for (i in 1 ... split.length)
        {
            var s:String = split[i];

            split[i] = s.charAt(0).toUpperCase();
        }

        return '${split.join("")}L';
    }

    public function getClassPath(sep:String = "/"):String
    {
        var path:String = "game/levels";

        if (week != null)
            path += '/${week.encodeName()}';

        if (difficulty != "Normal")
            path += '/diff_${difficulty.toLowerCase()}';

        path += '/${encodeName()}';

        return path.replace("/", sep);
    }
}

enum ObscurityStatus
{
    /**
     * Level only appears in the Freeplay Screen.
     */
    NONE;

    /**
     * Level only appears in the Mystery Screen, and has an unlock screen when initially completing the level.
     */
    MINIMAL;

    /**
     * Level only appears in the Mystery Screen, but does not have an unlock screen when initially completing the level.
     */
    OBSCURE;
}