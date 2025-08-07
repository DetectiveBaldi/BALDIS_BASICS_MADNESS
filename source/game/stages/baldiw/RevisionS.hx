package game.stages.baldiw;

import flixel.FlxSprite;

class RevisionS extends Stage
{
    public var entranceA2:FlxSprite;
    
    public var entranceA3:FlxSprite;

    public function new():Void
    {
        super();

        entranceA2 = getSprite("entrance-a2");

        entranceA3 = getSprite("entrance-a3");
    }   
}