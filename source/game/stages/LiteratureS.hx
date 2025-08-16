package game.stages;

import flixel.FlxSprite;

import flixel.addons.display.FlxBackdrop;

class LiteratureS extends Stage
{
    public var hall0:FlxSprite;
    
    public var hall1:FlxSprite;

    public var classroom:FlxSprite;

    public var sky:FlxSprite;

    public var clouds:FlxBackdrop;

    public function new():Void
    {
        super();
    
        hall0 = getSprite("baldina-hall0");

        hall1 = getSprite("baldina-hall1");

        classroom = getSprite("baldina-classroom");

        sky = getSprite("baldina-sky");

        clouds = getBackdrop("baldina-clouds");
    }
}