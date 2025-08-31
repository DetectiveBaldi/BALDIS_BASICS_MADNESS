package game.stages;

import flixel.FlxSprite;

import flixel.util.FlxColor;

class TwoS extends Stage
{
    public var space:FlxSprite;

    public var plus:FlxSprite;

    public var noise:FlxSprite;

    public function new():Void
    {
        super();

        space = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        space.active = false;

        space.scale.set(960.0, 720.0);

        space.updateHitbox();

        space.screenCenter();

        add(space);

        plus = getAtlasSprite("two-plus-bg");

        plus.animation.addByPrefix("0", "bg", 24.0);

        plus.scale.set(3.0, 3.0);

        plus.active = true;

        plus.updateHitbox();

        plus.screenCenter();

        noise = getAtlasSprite("two-noise");

        noise.animation.addByPrefix("1", "noise", 24.0);

        noise.scale.set(3.0, 3.0);

        noise.active = true;

        noise.updateHitbox();

        noise.screenCenter();
    }
}