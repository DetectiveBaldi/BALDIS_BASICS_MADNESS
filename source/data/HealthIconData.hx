package data;

import haxe.Json;

import core.Assets;
import core.Paths;

class HealthIconData
{
    public static function get(path:String):RawHealthIconData
    {
        return Json.parse(Assets.getText(Paths.data(Paths.json('game/HealthIcon/${path}'))));
    }
}

typedef RawHealthIconData =
{
    var image:String;

    var ?antialiasing:Bool;

    var ?scale:{?x:Float, ?y:Float};
}