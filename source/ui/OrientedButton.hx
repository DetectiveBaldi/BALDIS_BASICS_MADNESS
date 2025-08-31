package ui;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.AssetCache;

import util.ClickSoundUtil;

class OrientedButton extends FlxSprite
{
    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, orientation:ButtonOrientation):Void
    {
        super(x, y);

        loadGraphic(AssetCache.getGraphic("ui/OrientedButton/sheet"), true, 32, 32);

        animation.add("deselected", orientation == LEFT ? [0] : [1], 0.0, false);

        animation.add("select", orientation == LEFT ? [2] : [3], 0.0, false);

        animation.play("deselected");

        scale.set(3.0, 3.0);

        updateHitbox();

        onClick = new FlxSignal();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            animation.play("select");

            if (FlxG.mouse.justReleased)
            {
                ClickSoundUtil.play();
                
                onClick.dispatch();
            }
        }
        else
            animation.play("deselected");
    }

    override function destroy():Void
    {
        super.destroy();

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}

enum ButtonOrientation
{
    LEFT;

    RIGHT;
}