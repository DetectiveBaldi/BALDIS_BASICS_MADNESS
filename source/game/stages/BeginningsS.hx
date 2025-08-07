package game.stages;

import flixel.FlxSprite;

class BeginningsS extends Stage
{
    public var testRoom:FlxSprite;

    public function new():Void
    {
        super();

        testRoom = getSprite("test-room");
    }
}