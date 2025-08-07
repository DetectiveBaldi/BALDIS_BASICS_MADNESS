package data;

import data.AxisData;
import haxe.Json;

import core.AssetCache;
import core.Paths;

class CharacterData
{
    public static function get(path:String):RawCharacterData
    {
        return Json.parse(AssetCache.getText(Paths.data(Paths.json('game/Character/${path}'))));
    }
}

typedef RawCharacterData =
{
    var name:String;
    
    var format:String;

    var image:String;

    var ?antialiasing:Bool;

    var ?scale:AxisData<Float>;

    var ?flipX:Bool;

    var ?flipY:Bool;

    var animations:Array<AnimationData>;

    var danceSteps:Array<String>;

    var ?danceInterval:Float;

    var ?singDuration:Float;

    var cameraPoint:AxisData<Float>;

    var healthIcon:String;

    var ?healthColor:String;
}