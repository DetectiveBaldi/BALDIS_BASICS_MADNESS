package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import api.DiscordHandler;

import core.AssetCache;

import extendable.TransitionState;

import ui.BackOutButton;

using util.MathUtil;

class AboutScreen extends TransitionState
{
    public var backOutButton:BackOutButton;

    public var bg:FlxSprite;

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        DiscordHandler.setState(null);

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        bg = new FlxSprite();

        bg.loadGraphic(AssetCache.getGraphic("menus/AboutText"));

        bg.active = false;

        bg.scale.set(2.0, 2.0);

        bg.updateHitbox();

        bg.setPosition(bg.getCenterX(), 0.0);

        add(bg);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(FlxG.switchState.bind(() -> new MainMenuScreen()));

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

        MainMenuScreen.playTune();
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }
}