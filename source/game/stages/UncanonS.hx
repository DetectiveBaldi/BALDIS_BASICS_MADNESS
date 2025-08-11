package game.stages;

import flixel.FlxSprite;

class UncanonS extends Stage
{
    public var connorRoom0:FlxSprite;
    
    public var connorRoom1:FlxSprite;

    public function new():Void
    {
        super();
    
        connorRoom0 = getSprite("connor-room0", 2, 2);

        connorRoom1 = getSprite("connor-room1", 2, 2);
    }
}