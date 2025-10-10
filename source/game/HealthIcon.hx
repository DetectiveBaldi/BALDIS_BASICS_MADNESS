package game;

import flixel.FlxSprite;

import flixel.system.FlxAssets.FlxGraphicAsset;

import core.AssetCache;
import core.Paths;

class HealthIcon extends FlxSprite
{
    public function new(graphic:FlxGraphicAsset):Void
    {
        super(0.0, 0.0, graphic);
    }

    override function loadGraphic(graphic:FlxGraphicAsset, animated:Bool = false, frameWidth:Float = 0.0, frameHeight:Float = 0.0,
        unique:Bool = false, ?key:String):HealthIcon
    {
        if (!(graphic is String))
            throw "This operation is not supported for `game.HealthIcon`.";

        super.loadGraphic(AssetCache.getGraphic('game/HealthIcon/${graphic}'), true, 150, 150);

        animation.add("icon", [0, 1], 0.0, false);

        animation.play("icon");

        return this;
    }
}