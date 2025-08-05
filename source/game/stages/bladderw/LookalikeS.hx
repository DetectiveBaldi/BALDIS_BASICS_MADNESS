package game.stages.bladderw;

import flixel.FlxSprite;

class LookalikeS extends Stage
{
    public var room3:FlxSprite;

    public var room3_Alt0:FlxSprite;
    
    public function new():Void
    {
        super();

        room3 = sprite("secret-room3");

        room3_Alt0 = sprite("secret-room3-alt0");
    }
}