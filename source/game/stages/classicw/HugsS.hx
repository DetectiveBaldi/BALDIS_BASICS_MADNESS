package game.stages.classicw;

import flixel.FlxSprite;

import flixel.addons.display.FlxBackdrop;

import core.Paths;

class HugsS extends Stage
{
    public var hall:FlxSprite;

    public var hallcorner1:FlxSprite;

    public var hallcorner2:FlxSprite;

    public var hallcorner4:FlxSprite;

    public var hallend:FlxSprite;

    public var doorStandard:FlxSprite;

    public var doorStandardOpen:FlxSprite;

    public function new():Void
    {
        super();

        hall = getBackdrop("scrolling-hall0", true);

        hall.active = true;

        hallcorner1 = getSprite("hallcorner-1");

        hallcorner2 = getSprite("hallcorner-2");

        hallcorner4 = getSprite("hallcorner-4");

        hallend = getSprite("hall-end");

        doorStandard = getSprite("doorStandard", 2.35, 2.35);

        doorStandardOpen = getSprite("doorStandard-open", 2.35, 2.35);
    }
}