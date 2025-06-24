package game;

import flixel.FlxSprite;

import core.Assets;
import core.Paths;

class HealthIcon extends FlxSprite
{
    public var character(default, set):String;

    @:noCompletion
    function set_character(_character:String):String
    {
        character = _character;

        loadGraphic(Assets.getGraphic('game/HealthIcon/${character}'), true, 150, 150);

        animation.add("icon", [0, 1], 0.0, false);

        animation.play("icon");

        return character;
    }

    public function new(x:Float = 0.0, y:Float = 0.0, _character:String):Void
    {
        super(x, y);

        active = false;

        character = _character;
    }
}