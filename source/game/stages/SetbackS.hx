package game.stages;

import flixel.FlxSprite;

class SetbackS extends Stage
{
    public var room:FlxSprite;

    public var chair:FlxSprite;

    public function new():Void
    {
        super();

        room = getSprite("room", 2, 2);

        chair = getSprite("chairs", 2, 2);
    }
}