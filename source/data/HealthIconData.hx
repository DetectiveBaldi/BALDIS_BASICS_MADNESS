package data;

import haxe.Json;

import sys.FileSystem;

import core.Assets;
import core.Paths;

class HealthIconData
{
    public static function get(path:String):RawHealthIconData
    {
        return Json.parse(Assets.getText(Paths.json('assets/data/game/HealthIcon/${path}')));
    }
}

typedef RawHealthIconData =
{
    var png:String;

    var ?antialiasing:Bool;

    var ?scale:{?x:Float, ?y:Float};
}