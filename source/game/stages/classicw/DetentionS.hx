package game.stages.classicw;

import flixel.FlxSprite;

import flixel.addons.display.FlxBackdrop;

import core.Paths;

class DetentionS extends Stage
{
    public var hall:FlxSprite;

    public var schoolRules:FlxSprite;

    public var facultyStandard:FlxSprite;

    public var facultyStandardOpen:FlxSprite;

    public var faculty0:FlxSprite;

    public var faculty1:FlxSprite;

    public var faculty2:FlxSprite;

    public var office0:FlxSprite;

    public var office1:FlxSprite;

    public var office2:FlxSprite;

    public function new():Void
    {
        super();

        hall = getBackdrop("scrolling-hall0", true);

        hall.active = true;

        schoolRules = getSprite("schoolRules", 2.35, 2.35);

        schoolRules.active = true;

        facultyStandard = getSprite("facultyStandard", 2.35, 2.35);

        facultyStandard.active = true;

        facultyStandardOpen = getSprite("facultyStandard-open", 2.35, 2.35);

        faculty0 = getSprite("faculty", 2, 2);

        faculty2 = getSprite("faculty-caught1", 2, 2);

        faculty1 = getSprite("faculty-caught0", 2, 2);

        office2 = getSprite("office-bg", 2, 2);

        office0 = getSprite("office-closed", 2, 2);

        office1 = getSprite("office-open", 2, 2);
    }
}