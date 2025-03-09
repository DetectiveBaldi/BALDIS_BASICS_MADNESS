package data;

import haxe.Json;

import core.Assets;
import core.Paths;

class CharacterData
{
    public static function get(path:String):RawCharacterData
    {
        return Json.parse(Assets.getText(Paths.json('assets/data/game/Character/${path}')));
    }
}

typedef RawCharacterData =
{
    var name:String;
    
    var format:String;

    var png:String;

    var xml:String;

    var ?antialiasing:Bool;

    var ?scale:{?x:Float, ?y:Float};

    var ?flipX:Bool;

    var ?flipY:Bool;

    var animations:Array<AnimationData>;

    var danceSteps:Array<String>;

    var ?danceInterval:Float;

    var ?singDuration:Float;

    var healthIcon:String;

    var ?healthColor:String;
}