package game.stages.classicw.diff_hard;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class HyperactiveS extends Stage
{
    public var hall:FlxSprite;

    public var hall2:FlxSprite;

    public var room:FlxSprite;

    public var roomback:FlxSprite;

    public function new():Void
    {
        super();

        hall = getAtlasSprite("scrolling-hall3", true);

        hall.active = true;

        hall.animation.addByPrefix("0", "scroll", 30.0);

        hall2 = getAtlasSprite("scrolling-hall3", true);

        hall2.active = true;

        hall2.animation.addByPrefix("0", "scroll", 64.0);

        roomback = getSprite("room-back", 2, 2);

        room = getSprite("room", 2, 2);
    }
}