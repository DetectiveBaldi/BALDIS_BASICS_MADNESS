package game.stages;

import flixel.FlxSprite;

import flixel.addons.display.FlxBackdrop;

class LiteratureS extends Stage
{
    public var hall0:FlxSprite;
    
    public var hall1:FlxSprite;

    public var classroom:FlxSprite;

    public var chairs:FlxSprite;

    public var sky:FlxSprite;

    public var clouds:FlxBackdrop;

    public function new():Void
    {
        super();
    
        hall0 = getSprite("baldina-hall0", 2, 2);

        sky = getSprite("baldina-sky");

        clouds = getBackdrop("baldina-clouds", false, false, X);

        clouds.active = true;

        hall1 = getSprite("baldina-hall1", 2, 2);

        classroom = getSprite("baldina-classroom", 2, 2);

        chairs = getSprite("baldina-classroom-chair", 2, 2);
    }
}