package game.stages;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class TwoS extends Stage
{
    public var space:FlxSprite;

    public function new():Void
    {
        super();

        space = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        space.scale.set(960.0, 720.0);

        space.updateHitbox();

        space.screenCenter();

        add(space);
    }
}