package game;

import data.CreditsData;

import flixel.group.FlxSpriteGroup;

class CreditsPopup extends FlxSpriteGroup
{
    public var data:CreditsData;

    public function new(x:Float = 0.0, y:Float = 0.0, data:CreditsData):Void
    {
        super(x, y);

        this.data = data;
    }

    public function popUp():Void
    {
        
    }
}