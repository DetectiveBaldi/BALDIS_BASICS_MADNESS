package game.stages.baldiw;

import flixel.FlxSprite;

class WarmWS extends Stage
{
    public var entranceA0:FlxSprite;

    public var entranceA1:FlxSprite;

    public var entranceA1_Overlay0:FlxSprite;

    public var entranceA1_Alt0:FlxSprite;

    public function new():Void
    {
        super();

        entranceA0 = getSprite("entrance-a0");

        entranceA1 = getSprite("entrance-a1");

        entranceA1_Alt0 = getSprite("entrance-a1-alt0");

        entranceA1_Overlay0 = getSprite("entrance-a1-overlay0");
    }
}