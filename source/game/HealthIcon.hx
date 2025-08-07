package game;

import flixel.FlxSprite;

import core.AssetCache;
import core.Paths;

class HealthIcon extends FlxSprite
{
    public function new(x:Float = 0.0, y:Float = 0.0, character:String):Void
    {
        super(x, y);

        active = false;

        load(character);
    }

    public function load(character:String):Void
    {
        loadGraphic(AssetCache.getGraphic('game/HealthIcon/${character}'), true, 150, 150);

        animation.add("icon", [0, 1], 0.0, false);

        animation.play("icon");
    }
}