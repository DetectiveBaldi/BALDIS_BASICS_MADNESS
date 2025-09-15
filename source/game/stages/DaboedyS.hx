package game.stages;

import flixel.FlxSprite;

class DaboedyS extends Stage
{
    public var boedy:FlxSprite;
    
    public function new():Void
    {
        super();
    
        boedy = getSprite("boedy");
    }
}