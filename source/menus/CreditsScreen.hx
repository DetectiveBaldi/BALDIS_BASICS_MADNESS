package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import core.AssetCache;

import extendable.CustomState;

import flixel.sound.FlxSound;

using util.MathUtil;

class CreditsScreen extends CustomState
{
    public var exitButton:FlxSprite;

    public var bg:FlxSprite;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        bg = new FlxSprite();

        bg.loadGraphic(AssetCache.getGraphic("menus/CreditsText"));

        bg.active = false;

        bg.scale.set(2.0, 2.0);

        bg.updateHitbox();

        bg.setPosition(bg.getCenterX(), 0.0);

        add(bg);

        exitButton = new FlxSprite();

        exitButton.loadGraphic(AssetCache.getGraphic("menus/MainMenuScreen/exitButton"), true, 32, 32);

        exitButton.animation.add("0", [0], 0.0, false);

        exitButton.animation.add("1", [1], 0.0, false);

        exitButton.animation.play("0");

        exitButton.scale.set(2.0, 2.0);

        exitButton.updateHitbox();

        exitButton.setPosition(10.0, 10.0);

        add(exitButton);

        tune = FlxG.sound.load(AssetCache.getMusic("menus/CreditsScreen/Credits"), 1.0, true);
        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("1");

            if (FlxG.mouse.justPressed)
                FlxG.switchState(() -> new MainMenuScreen());
        }
        else
            exitButton.animation.play("0");
    }


    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }
}