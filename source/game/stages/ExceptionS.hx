package game.stages;

import flixel.FlxSprite;

class ExceptionS extends Stage
{
    public var bg:FlxSprite;

    public function new():Void
    {
        super();

        bg = getAtlasSprite("exceptionbg");

        bg.animation.addByPrefix("off", "off", 24.0, false);

        bg.animation.addByPrefix("on", "on", 24.0, false);

        bg.animation.addByPrefix("room", "room", 24.0, false);

        bg.animation.addByPrefix("g0", "g0", 24.0, false);

        bg.animation.addByPrefix("gep", "gep", 24.0, false);

        bg.animation.addByPrefix("g1", "g1", 12.0, false);

        bg.animation.addByPrefix("g2", "g2", 12.0, false);

        bg.animation.addByPrefix("gf", "gf", 20.0, false);

        bg.animation.addByPrefix("gn", "gn", 6.0, false);

        bg.animation.addByPrefix("nl", "nl", 24.0);

        bg.animation.addByPrefix("ne", "ne", 24.0, false);

        bg.animation.addByPrefix("ni", "ni", 24.0, false);

        bg.animation.addByPrefix("pc", "pc", 24.0, false);

        bg.scale.set(2.0, 2.0);

        bg.active = true;

        bg.updateHitbox();

        bg.screenCenter();

        add(bg);
    }
}