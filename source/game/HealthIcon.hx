package game;

import flixel.FlxSprite;

import core.AssetCache;
import core.Paths;

class HealthIcon extends FlxSprite
{
    public function new(file:String):Void
    {
        super(0.0, 0.0);

        active = false;

        loadFromFile(file);
    }

    public function loadFromFile(file:String):Void
    {
        loadGraphic(AssetCache.getGraphic('game/HealthIcon/${file}'), true, 150, 150);

        animation.add("icon", [0, 1], 0.0, false);

        animation.play("icon");
    }
}