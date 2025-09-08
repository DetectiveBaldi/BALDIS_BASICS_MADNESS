package game.stages.classicw;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class EssentialES extends Stage
{
    public var exit0:FlxSprite;

    public var exit1:FlxSprite;

    public var hall:FlxSprite;

    public var hall0:FlxSprite;

    public var exit:FlxSprite;

    public var exitClosed:FlxSprite;

    public var exitClosed2:FlxSprite;

    public var cafeExit0:FlxSprite;

    public var cafeExit1:FlxSprite;

    public var cafeExit2:FlxSprite;

    public var cafeExit3:FlxSprite;

    public function new():Void
    {
        super();

        exit0 = getSprite("exit0", 2, 2);

        exit1 = getSprite("exit1", 2, 2);

        hall = getAtlasSprite("scrolling-hall0", true);

        hall.active = true;

        hall.animation.addByPrefix("0", "scroll", 54.0);
        
        hall.animation.play("0", false, true);

        hall0 = getSprite("hall0", true);

        exit = getSprite("exit");

        exit.active = true;

        exitClosed = getSprite("exitClosed");

        exitClosed.active = true;

        exitClosed2 = getSprite("exitClosed");

        exitClosed2.active = true;

        cafeExit0 = getSprite("cafeExit0", 2, 2);

        cafeExit1 = getSprite("cafeExit1", 2, 2);

        cafeExit2 = getSprite("cafeExit2", 2, 2);

        cafeExit3 = getSprite("cafeExit3", 2, 2);
    }
}