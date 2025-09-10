package game.stages.classicw;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class JealousyS extends Stage
{
    public var hall:FlxSprite;
    
    public var hall0:FlxSprite;

    public function new():Void
    {
        super();

        hall = getAtlasSprite("scrolling-hall0", true);

        hall.active = true;

        hall.animation.addByPrefix("0", "scroll", 22.0);

        hall0 = getSprite("hall-pov0", 2, 2);
    }
}