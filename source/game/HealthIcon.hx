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

        loadGraphic(Assets.getGraphic(Paths.image(Paths.png('game/HealthIcon/${config.image}'))));

        antialiasing = config.antialiasing ?? true;

        scale.set(0.8, 0.8);

        updateHitbox();

        return config;
    }

    public function new(x:Float = 0.0, y:Float = 0.0, _config:RawHealthIconData):Void
    {
        super(x, y);

        active = false;

        config = _config;
    }
}