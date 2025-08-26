package game.stages;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.addons.display.FlxBackdrop;

import core.Paths;

class RoughES extends Stage
{
    public var hall0:FlxSprite;

    public var hall1:FlxSprite;

    public var hall2:FlxBackdrop;

    public var hall3:FlxSprite;

    public var hall4:FlxSprite;

    public var hall5:FlxSprite;
        
    public var hall6:FlxSprite;

    public var hall7:FlxSprite;

    public var exit0:FlxSprite;
   
    public var exit1:FlxSprite;

    public var office0:FlxSprite;

    public var office1:FlxSprite;

    public var office2:FlxSprite;

    public var office3:FlxSprite;

    public var office4:FlxSprite;

    public var office5:FlxSprite;

    public var office6:FlxSprite;

    public var office7:FlxSprite;

    public var office8:FlxSprite;

    public var office9:FlxSprite;

    public var officeHall0:FlxSprite;

    public var officeHall1:FlxSprite;

    public var officeHall2:FlxSprite;

    public var officeHall3:FlxSprite;

    public var cafeteriaHall0:FlxSprite;

    public var cafeteriaHall1:FlxSprite;

    public var cafeteriaHall2:FlxSprite;

    public var cafeteriaHall3:FlxSprite;

    public var cafeteria0:FlxSprite;

    public var cafeteria1:FlxSprite;

    public var cafeteria2:FlxSprite;

    public var cafeteria3:FlxSprite;

    public var cafeteria4:FlxSprite;

    public var facultyStandard:FlxSprite;

    public var baldiOffice:FlxSprite;

    public function new():Void
    {
        super();

        hall0 = getSprite("hall0");

        hall1 = getSprite("hall1");

        hall2 = getBackdrop("game/stages/shared/scrolling-hall0", false);

        hall2.active = true;

        hall3 = getSprite("hall3");

        hall4 = getSprite("hall4", 0.75, 0.75);

        hall5 = getAtlasSprite("game/stages/shared/scrolling-hall2");

        hall5.active = true;

        hall5.animation.addByPrefix("0", "redLongHall run", 24.0);

        hall5.animation.play("0");
        
        hall6 = getSprite("hall6");
       
        hall7 = getSprite("hall7");

        exit0 = getSprite("exit0", 2.35, 2.35);

        exit0.active = true;
        
        exit1 = getSprite("exit1");

        exit1.active = true;

        office0 = getSprite("office0");

        office1 = getSprite("office1");

        office2 = getSprite("office2");

        office3 = getSprite("office3");

        office4 = getSprite("office4");

        office5 = getSprite("office5");

        remove(office5, true);

        insert(members.indexOf(office4), office5);

        office6 = getSprite("office6");

        office7 = getSprite("office7");

        office8 = getSprite("office8");

        office9 = getSprite("office9");

        officeHall0 = getSprite("office-hall0");

        officeHall1 = getSprite("office-hall1");

        officeHall2 = getSprite("office-hall2");

        officeHall3 = getSprite("office-hall3");
    
        cafeteriaHall0 = getSprite("cafeteria-hall0");

        cafeteriaHall1 = getSprite("cafeteria-hall1");

        cafeteriaHall2 = getSprite("cafeteria-hall2");

        cafeteriaHall3 = getSprite("cafeteria-hall3");

        cafeteria0 = getSprite("cafeteria0");

        cafeteria1 = getSprite("cafeteria1");

        cafeteria2 = getSprite("cafeteria2");

        cafeteria3 = getSprite("cafeteria3");

        cafeteria4 = getSprite("cafeteria4");
    
        facultyStandard = getSprite("facultyStandard", 2.35, 2.35);

        facultyStandard.active = true;
    
        baldiOffice = getSprite("office-baldi0");
    }
}