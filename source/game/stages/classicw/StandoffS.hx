package game.stages.classicw;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class StandoffS extends Stage
{
    public var hall:FlxSprite;

    public var hall_Alt:FlxSprite;

    public var hall_Overlay0:FlxSprite;
    
    public var hall_Overlay1:FlxSprite;

    public function new():Void
    {
        super();

        hall = getSprite("hall");
       
        hall_Alt = getSprite("hall-alt");

        hall_Overlay0 = getSprite("hall-overlay0");
    
        hall_Overlay1 = getSprite("hall-overlay1");
    }
}