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
            var raw:RawWeekData = Json.parse(Assets.getText('assets/data/game/WeekData/${files[i]}'));

            var week:WeekData = {id: raw.id, name: raw.name, levels:
                [for (i in 0 ... raw.levels.length) LevelData.fromRaw(raw.levels[i])]}

            for (i in 0 ... week.levels.length)
                week.levels[i].week = week.name;

            list.push(week);
        }

        ArraySort.sort(list, function (a:WeekData, b:WeekData):Int return a.id - b.id);

        return list;
    }

    public var id:Int;

    public var name:String;

    public var levels:Array<LevelData>;
}

typedef RawWeekData =
{
    public var id:Int;

    public var name:String;

    public var levels:Array<RawLevelData>;
}