package game.stages.classicw.diff_hard;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class FundamentalsS extends Stage
{
    public var hall0:FlxSprite;

    public var office:FlxSprite;

    public var office2:FlxSprite;

    public var hall1:FlxSprite;

    public var hall1open:FlxSprite;

    public var hall1front:FlxSprite;

    public function new():Void
    {
        super();

        hall0 = getSprite("hall0", 2, 2);

        office = getSprite("office", 2, 2);

        office2 = getSprite("office2", 2, 2);

        hall1 = getSprite("hall1", 2, 2);

        hall1open = getSprite("hall1-open", 2, 2);

        hall1front = getSprite("hall1-front", 2, 2);
    }
}