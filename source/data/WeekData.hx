package data;

import haxe.Json;

import haxe.io.Path;

import sys.FileSystem;

import core.Assets;
import core.Paths;

import data.LevelData;

class WeekData
{
    public static var list:Map<String, RawWeekData> = new Map<String, RawWeekData>();

    public static function load():Void
    {
        var _list:Array<String> = FileSystem.readDirectory("assets/data/game/WeekData/");

        for (i in 0 ... _list.length)
            get(_list[i].split(".")[0]);
    }

    public static function get(path:String):RawWeekData
    {
        if (exists(path))
            return list[path];

        list[path] = Json.parse(Assets.getText(Paths.json('assets/data/game/WeekData/${path}')));

        return list[path];
    }

    public static function exists(path:String):Bool
    {
        return list.exists(path);
    }
}

typedef RawWeekData =
{
    public var name:String;

    public var levels:Array<RawLevelData>;
}