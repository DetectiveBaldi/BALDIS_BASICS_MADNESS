package game.stages;

import flixel.FlxSprite;

class BloxyCS extends Stage
{
    public var oldSchool:FlxSprite;
    
    public function new():Void
    {
        super();
    
        oldSchool = getSprite("old-school");
    }
}