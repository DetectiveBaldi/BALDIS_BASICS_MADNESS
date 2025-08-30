package game.stages;

import flixel.FlxSprite;

import flixel.util.FlxColor;

import flixel.addons.display.FlxBackdrop;

class OverseerS extends Stage
{
    public var black:FlxSprite;

    public var redstatic:FlxSprite;

    public var ninenine:FlxBackdrop;
    
    public function new():Void
    {
        super();
    
        black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);

        black.scale.set(960.0, 720.0);

        black.updateHitbox();

        black.screenCenter();

        add(black);

        redstatic = getAtlasSprite("overseer-redstatic");

        redstatic.scale.set(3.0, 3.0);

        redstatic.active = true;

        redstatic.animation.addByPrefix("0", "static", 24.0);

        redstatic.updateHitbox();

        redstatic.screenCenter();

        ninenine = getBackdrop("99-ref");

        ninenine.active = true;

        insert(members.indexOf(redstatic), ninenine);
    }
}