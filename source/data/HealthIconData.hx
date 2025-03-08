package data;

import haxe.Json;

import core.Assets;
import core.Paths;

class HealthIconData
{
    public static var list:Map<String, RawHealthIconData> = new Map<String, RawHealthIconData>();

    public static function get(path:String):RawHealthIconData
    {
        if (exists(path))
            return list[path];

        list[path] = Json.parse(Assets.getText(Paths.json('assets/data/game/HealthIcon/${path}')));

        return list[path];
    }

    public static function exists(path:String):Bool
    {
        return list.exists(path);
    }
}

typedef RawHealthIconData =
{
    var png:String;

    var ?antialiasing:Bool;

    var ?scale:{?x:Float, ?y:Float};
}