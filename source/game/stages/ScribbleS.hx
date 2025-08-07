package game.stages;

import flixel.FlxSprite;

class ScribbleS extends Stage
{
    public var classicHall0:FlxSprite;

    public function new():Void
    {
        super();

        classicHall0 = getSprite("classic-hall0");
    }
}