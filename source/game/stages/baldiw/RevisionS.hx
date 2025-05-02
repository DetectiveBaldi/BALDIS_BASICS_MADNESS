package game.stages.baldiw;

import flixel.FlxSprite;

class RevisionS extends Stage
{
    public var entranceA2:FlxSprite;
    
    public var entranceA3:FlxSprite;

    public function new():Void
    {
        super();

        entranceA2 = sprite("entrance-a2");

        entranceA3 = sprite("entrance-a3");
    }   
}