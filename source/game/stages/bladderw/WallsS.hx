package game.stages.bladderw;

import flixel.FlxSprite;

class WallsS extends Stage
{
    public var room0:FlxSprite;

    public var room0_Alt0:FlxSprite;
    
    public var room0_Overlay0:FlxSprite;

    public var room1:FlxSprite;

    public var room1_Overlay0:FlxSprite;

    public function new():Void
    {
        super();

        room0 = getSprite("secret-room0");

        room0_Alt0 = getSprite("secret-room0-alt0");

        room0_Overlay0 = getSprite("secret-room0-overlay0");
    
        room1 = getSprite("secret-room1");
        
        room1_Overlay0 = getSprite("secret-room1-overlay0");
    }
}