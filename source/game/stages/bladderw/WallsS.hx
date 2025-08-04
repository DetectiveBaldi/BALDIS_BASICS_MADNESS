package game.stages.bladderw;

import flixel.FlxSprite;

class WallsS extends Stage
{
    public var room0:FlxSprite;

    public var room0_Alt0:FlxSprite;
    
    public var room0_Overlay0:FlxSprite;

    public function new():Void
    {
        super();

        room0 = sprite("secret-room0");

        room0_Alt0 = sprite("secret-room0-alt0");

        room0_Overlay0 = sprite("secret-room0-overlay0");
    }
}