package game.stages;

import flixel.FlxSprite;

class MishapS extends Stage
{
    public var breadySchool:FlxSprite;
    
    public function new():Void
    {
        super();
    
        breadySchool = getSprite("bready-school");
    }
}