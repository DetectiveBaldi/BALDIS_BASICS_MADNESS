package game.stages.nullw;

import flixel.FlxSprite;

class BrokenDS extends Stage
{
    public var room:FlxSprite;

    public var desk:FlxSprite;

    public function new():Void
    {
        super();

        room = getSprite("bg0", 2, 2);

        desk = getSprite("desk", 2, 2);
    }
}