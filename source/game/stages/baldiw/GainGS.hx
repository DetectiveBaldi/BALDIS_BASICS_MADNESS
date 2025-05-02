package game.stages.baldiw;

import flixel.FlxSprite;

import flixel.addons.display.FlxBackdrop;

class GainGS extends Stage
{
    public var entranceA4:FlxSprite;

    public var entranceA4_Alt0:FlxSprite;

    public var entranceA4_Overlay0:FlxSprite;

    public var entranceA4_Overlay1:FlxSprite;

    public var entranceA4_Overlay2:FlxSprite;

    public var entranceA5:FlxSprite;

    public var ggfaculty0:FlxSprite;

    public var ggfaculty0_Alt0:FlxSprite;

    public var ggfaculty0_Overlay0:FlxSprite;

    public var principalOffice0:FlxSprite;

    public var principalOffice0_Overlay0:FlxSprite;

    public var scrollingHall0:FlxBackdrop;

    public var phoneHall0:FlxSprite;

    public function new():Void
    {
        super();

        entranceA4 = sprite("entrance-a4");

        entranceA4_Alt0 = sprite("entrance-a4-alt0");

        entranceA4_Overlay0 = sprite("entrance-a4-overlay0");

        entranceA4_Overlay1 = sprite("entrance-a4-overlay1");

        entranceA4_Overlay2 = sprite("entrance-a4-overlay2");

        entranceA5 = sprite("entrance-a5");
        
        ggfaculty0 = sprite("faculty0");

        ggfaculty0_Alt0 = sprite("faculty0-alt0");

        ggfaculty0_Overlay0 = sprite("faculty0-overlay0");

        principalOffice0 = sprite("principal-office0");

        principalOffice0_Overlay0 = sprite("principal-office0-overlay0");

        scrollingHall0 = backdrop("game/stages/shared/scrolling-hall0");

        phoneHall0 = sprite("phone-hall0");
    }
}