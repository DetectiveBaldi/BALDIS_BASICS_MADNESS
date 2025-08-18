package game.stages.classicw;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class PlaymateS extends Stage
{
    public var cafe:FlxSprite;

    public var hall:FlxSprite;

    public function new():Void
    {
        super();

        cafe = getSprite("cafe", 2, 2);

        hall = getSprite("hall", 2, 2);
    }
}