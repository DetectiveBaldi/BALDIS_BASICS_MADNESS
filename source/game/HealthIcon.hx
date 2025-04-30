package game;

import flixel.FlxSprite;

import core.Assets;
import core.Paths;

import data.HealthIconData.RawHealthIconData;

class HealthIcon extends FlxSprite
{
    public var config(default, set):RawHealthIconData;

    @:noCompletion
    function set_config(_config:RawHealthIconData):RawHealthIconData
    {
        config = _config;

        antialiasing = config.antialiasing ?? true;

        loadGraphic(Assets.getGraphic('game/HealthIcon/${config.image}'), true, 150, 150);

        animation.add("icon", [0, 1], 0.0, false);

        animation.play("icon");

        return config;
    }

    public function new(x:Float = 0.0, y:Float = 0.0, _config:RawHealthIconData):Void
    {
        super(x, y);

        active = false;

        config = _config;
    }
}