package data;

import haxe.Json;

import haxe.ds.ArraySort;

import sys.FileSystem;

import core.Assets;

import data.LevelData;

@:structInit
class WeekData
{
    public static var list:Array<WeekData>;

    public static function reloadWeeksList():Array<WeekData>
    {
        list ??= new Array<WeekData>();

        list.resize(0);

        var files:Array<String> = FileSystem.readDirectory("assets/data/game/WeekData/");

        for (i in 0 ... files.length)
        {
            var rawWeek:RawWeekData = Json.parse(Assets.getText('assets/data/game/WeekData/${files[i]}'));

            var week:WeekData = {id: rawWeek.id, name: rawWeek.name, levels: new Array<LevelData>()}

            for (i in 0 ... rawWeek.levels.length)
            {
                var rawLevel:RawLevelData = rawWeek.levels[i];

                week.levels.push({week: week, name: rawLevel.name});
            }

            list.push(week);
        }

        ArraySort.sort(list, function (a:WeekData, b:WeekData):Int return a.id - b.id);

        return list;
    }

    public var id:Int;

    public var name:String;

    public var levels:Array<LevelData>;

    public function getLevelIndex(lv:LevelData):Int
    {
        return levels.indexOf(lv);
    }
}

typedef RawWeekData =
{
    public var id:Int;

    public var name:String;

    public var levels:Array<RawLevelData>;
}