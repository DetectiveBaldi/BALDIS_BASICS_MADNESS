package ui;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.AssetCache;
import core.Paths;

import util.ClickSoundUtil;

class HeightenedButton extends FlxSpriteGroup
{
    public var base:FlxSprite;

    public var label:FlxText;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, text:String, size:ButtonSize):Void
    {
        super(x, y);

        base = new FlxSprite();

        base.loadGraphic(AssetCache.getGraphic("ui/HeightenedButton/base"), true, 128, 128);

        base.active = false;

        base.animation.add("up", [0], 0.0, false);

        base.animation.add("down", [1], 0.0, false);

        base.animation.play("up");

        base.scale.set(size == LARGE ? 2.0 : 1.75, size == LARGE ? 2.0 : 1.75);

        base.updateHitbox();

        add(base);

        label = new FlxText(0.0, 0.0, base.width, text);

        label.color = FlxColor.BLACK;

        label.font = Paths.font(Paths.ttf("Comic Sans MS"));

        label.size = size == LARGE ? 28 : 24;

        label.alignment = CENTER;

        label.textField.antiAliasType = ADVANCED;

        label.textField.sharpness = 400.0;

        label.setPosition(base.getMidpoint().x - label.width * 0.5, size == LARGE ? 45.0 : 35.0);

        add(label);

        onClick = new FlxSignal();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            if (FlxG.mouse.pressed)
                base.animation.play("down");
            else
                base.animation.play("up");

            if (FlxG.mouse.justReleased)
            {
                ClickSoundUtil.play(BUTTON);

                onClick.dispatch();
            }
        }
        else
            base.animation.play("up");
    }

    override function destroy():Void
    {
        super.destroy();

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}

enum ButtonSize
{
    LARGE;

    SMALL;
}