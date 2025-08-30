package game.stages.classicw;

import flixel.FlxSprite;

import flixel.addons.display.FlxBackdrop;

class AdrenalineS extends Stage
{
    public var closet:FlxSprite;

    public var closet_Alt:FlxSprite;

    public var closet_Overlay:FlxSprite;

    public var closetInside:FlxSprite;
    
    public var closetInside_Alt:FlxSprite;

    public var closetInside_Overlay:FlxSprite;

    public var hall:FlxBackdrop;

    public var hall2:FlxSprite;

    public var hall3:FlxSprite;

    public var hall3_Alt:FlxSprite;

    public var hall3_Overlay:FlxSprite;

    public function new():Void
    {
        super();

        closet = getSprite("closet", 2, 2);

        closet_Alt = getSprite("closet-alt", 2, 2);

        closet_Overlay = getSprite("closet-overlay", 2, 2);
    
        closetInside = getSprite("closet-inside", 2, 2);
    
        closetInside_Alt = getSprite("closet-inside-alt", 2, 2);

        closetInside_Overlay = getSprite("closet-inside-overlay", 2, 2);

        hall = getBackdrop("scrolling-hall0", true);
    
        hall.active = true;
    
        hall2 = getAtlasSprite("scrolling-hall1", true);

        hall2.active = true;

        hall2.animation.addByPrefix("0", "bg", 48.0);
        
        hall2.animation.play("0", false, true);
        
        hall3 = getSprite("game/stages/classicw/StandoffS/hall", false, true);

        hall3_Alt = getSprite("game/stages/classicw/StandoffS/hall-alt", false, true);

        hall3_Overlay = getSprite("game/stages/classicw/StandoffS/hall-overlay1", false, true);
    }
}