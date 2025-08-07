package game.stages.bladderw;

import flixel.FlxSprite;

class LookalikeS extends Stage
{
    public var room3:FlxSprite;

    public var room3_Alt0:FlxSprite;
    
    public var bladderSchool0:FlxSprite;

    public var bladderSchool1:FlxSprite;

    public function new():Void
    {
        super();

        room3 = getSprite("secret-room3");
        room3.scale.set(2, 2);

        room3_Alt0 = getSprite("secret-room3-alt0");
        room3_Alt0.scale.set(2, 2);
    
        bladderSchool0 = getSprite("bladder-school0");
        bladderSchool0.scale.set(2, 2);
    
        bladderSchool1 = getAtlasSprite("bladder-school1");
        bladderSchool1.scale.set(2, 2);
        bladderSchool1.active = true;
        bladderSchool1.animation.addByPrefix("0", "bg", 24.0);
    }
}