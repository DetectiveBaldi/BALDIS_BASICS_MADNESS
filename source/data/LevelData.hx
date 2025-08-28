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

    public var showInMysteryMenu:Bool;

    public function new(week:WeekData, name:String, difficulty:String = "Normal"):Void
    {
        this.week = week;

        this.name = name;

        this.difficulty = difficulty;

        showInFreeplayMenu = true;

        showInMysteryMenu = false;
    }

    public function getFormattedName():String
    {
        var split:Array<String> = name.split(" ");

        for (i in 1 ... split.length)
        {
            var s:String = split[i];

            split[i] = s.getFirstCharacter().toUpperCase();
        }

        var difficultyToAppend:String = "";

        if (difficulty != "Normal")
            difficultyToAppend = difficulty.toUpperCase();

        return '${split.join("")}L_${difficultyToAppend}';
    }

    public function getClassPath(sep:String = "/"):String
    {
        var path:String = "game/levels";

        if (week != null)
            path += '/${week.getFormattedName()}';

        path += '/${getFormattedName()}';

        return path.replace("/", sep);
    }
}