package game.stages.classicw;

import flixel.FlxSprite;

import flixel.addons.display.FlxBackdrop;

class AdrenalineS extends Stage
{
    public var closet:FlxSprite;

    public var closet_Alt:FlxSprite;

    public var closet_Overlay:FlxSprite;

    public var hall:FlxBackdrop;

    public var hall2:FlxSprite;
    
    public var faculty0:FlxSprite;

    public var faculty0_Overlay0:FlxSprite;
    
    public var faculty0_Overlay1:FlxSprite;

    public function new():Void
    {
        super();

        closet = getSprite("closet", 2, 2);

        closet_Alt = getSprite("closet-alt", 2, 2);

        closet_Overlay = getSprite("closet-overlay", 2, 2);
    
        hall = getBackdrop("game/stages/shared/scrolling-hall0", false);
    
        hall.active = true;
    
        hall2 = getAtlasSprite("game/stages/shared/scrolling-hall2", false);

        hall2.active = true;

        hall2.animation.addByPrefix("0", "redLongHall run", 48.0);

        hall2.animation.play("0");

        faculty0 = getSprite("faculty0");

        faculty0_Overlay0 = getSprite("faculty0-overlay0");

        faculty0_Overlay1 = getSprite("faculty0-overlay1");
    }
}