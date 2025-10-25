package game.stages;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class SuperSS extends Stage
{
    public var bg:FlxSprite;

    public var light:FlxSprite;

    public function new():Void
    {
        super();

        bg = getSprite("bg", 2, 2);

        add(bg);

        light = getSprite("lightning", 2, 2);

        add(bg);
    }
}