package game.stages.classicw;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class EssentialES extends Stage
{
    public var exit0:FlxSprite;

    public var exit1:FlxSprite;

    public var hall:FlxSprite;

    public function new():Void
    {
        super();

        exit0 = getSprite("exit0", 2, 2);

        exit1 = getSprite("exit1", 2, 2);

        hall = getAtlasSprite("scrolling-hall0", true);

        hall.active = true;

        hall.animation.addByPrefix("0", "scroll", 36.0);
        
        hall.animation.play("0", false, true);
    }
}