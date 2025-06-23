package game.stages;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
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

        hall0 = sprite("hall0");

        hall0.visible = true;

        hall1 = sprite("hall1");

        hall2 = backdrop("game/stages/shared/scrolling-hall0");

        hall2.active = true;

        hall3 = sprite("hall3");

        hall4 = sprite("hall4", 0.75, 0.75);

        hall5 = atlasSprite("hall5");

        hall5.active = true;

        hall5.animation.addByPrefix("0", "redLongHall run", 24.0);

        hall5.animation.play("0");
        
        hall6 = sprite("hall6");
       
        hall7 = sprite("hall7");

        exit0 = sprite("exit0", 2.35, 2.35);

        exit0.active = true;
        
        exit1 = sprite("exit1");

        exit1.active = true;

        office0 = sprite("office0");

        office1 = sprite("office1");

        office2 = sprite("office2");

        office3 = sprite("office3");

        office4 = sprite("office4");

        office5 = sprite("office5");

        remove(office5, true);

        insert(members.indexOf(office4), office5);

        office6 = sprite("office6");

        office7 = sprite("office7");

        office8 = sprite("office8");

        office9 = sprite("office9");

        officeHall0 = sprite("office-hall0");

        officeHall1 = sprite("office-hall1");

        officeHall2 = sprite("office-hall2");

        officeHall3 = sprite("office-hall3");
    
        cafeteriaHall0 = sprite("cafeteria-hall0");

        cafeteriaHall1 = sprite("cafeteria-hall1");

        cafeteriaHall2 = sprite("cafeteria-hall2");

        cafeteriaHall3 = sprite("cafeteria-hall3");

        cafeteria0 = sprite("cafeteria0");

        cafeteria1 = sprite("cafeteria1");

        cafeteria2 = sprite("cafeteria2");

        cafeteria3 = sprite("cafeteria3");

        cafeteria4 = sprite("cafeteria4");
    
        facultyStandard = sprite("facultyStandard", 2.35, 2.35);

        facultyStandard.active = true;
    
        baldiOffice = sprite("office-baldi0");
    }
}