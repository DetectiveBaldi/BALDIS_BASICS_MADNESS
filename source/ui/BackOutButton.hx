package ui;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxSignal;
import flixel.util.typeLimit.NextState;

import core.AssetCache;

import util.ClickSoundUtil;

class BackOutButton extends FlxSprite
{
    public var onClick:FlxSignal;

    public function new():Void
    {
        super();

        loadGraphic(AssetCache.getGraphic("ui/BackOutButton/base"), true, 32, 32);

        animation.add("0", [0], 0.0, false);

        animation.add("1", [1], 0.0, false);

        animation.play("0");

        scale.set(2.0, 2.0);

        updateHitbox();

        onClick = new FlxSignal();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            animation.play("1");

            if (FlxG.mouse.justReleased)
            {
                ClickSoundUtil.play();

                onClick.dispatch();
            }
        }
        else
            animation.play("0");
    }
}