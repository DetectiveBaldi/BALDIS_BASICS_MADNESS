package data;

import haxe.Json;

import sys.FileSystem;

import core.Assets;
import core.Paths;

import data.LevelData;

@:structInit
class WeekData
{
    public static var raw:Map<String, RawWeekData> = new Map<String, RawWeekData>();

    public static function fromRaw(raw:RawWeekData):WeekData
    {
        var week:WeekData = {name: raw.name, levels: [for (i in 0 ... raw.levels.length) LevelData.fromRaw(raw.levels[i])]}

        for (i in 0 ... week.levels.length)
            week.levels[i].week = week.name;

        return week;
    }

    public static function load():Void
    {
        var list:Array<String> = FileSystem.readDirectory("assets/data/game/WeekData/");

        for (i in 0 ... list.length)
            get(list[i].split(".")[0]);
    }

    public static function get(path:String):RawWeekData
    {
        if (exists(path))
            return raw[path];

        raw[path] = Json.parse(Assets.getText(Paths.json('assets/data/game/WeekData/${path}')));

        return raw[path];
    }

    public static function exists(path:String):Bool
    {
        return raw.exists(path);
    }

    public var name:String;

    public var levels:Array<LevelData>;
}

typedef RawWeekData =
{
    public var name:String;

    public var levels:Array<RawLevelData>;
}