package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import core.AssetCache;

import extendable.CustomState;

using util.MathUtil;

class AboutScreen extends CustomState
{
    public var exitButton:FlxSprite;

    public var bg:FlxSprite;

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        bg = new FlxSprite();

        bg.loadGraphic(AssetCache.getGraphic("menus/AboutText"));

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

        exitButton.setPosition(165.0, 5.0);

        add(exitButton);

        MainMenuScreen.playTune();
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