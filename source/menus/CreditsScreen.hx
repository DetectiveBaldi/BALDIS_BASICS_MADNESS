package menus;

import ui.OrientedButton;
import flixel.util.FlxDestroyUtil;
import util.ClickSoundUtil;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxSignal;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import core.AssetCache;

import extendable.CustomState;

import flixel.sound.FlxSound;

import ui.BackOutButton;

using util.MathUtil;

class CreditsScreen extends CustomState
{
    public var backOutButton:BackOutButton;

    public var rightButton:OrientedButton;

    public var leftButton:OrientedButton;

    public var pageButton:FlxSprite;

    public var bg:FlxSprite;

    public var bg2:FlxSprite;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        bg = new FlxSprite();

        bg.loadGraphic(AssetCache.getGraphic("menus/CreditsScreen/Text1"));

        bg.active = false;

        bg.scale.set(2.0, 2.0);

        bg.updateHitbox();

        bg.setPosition(bg.getCenterX(), 0.0);

        add(bg);

        bg2 = new FlxSprite();

        bg2.loadGraphic(AssetCache.getGraphic("menus/CreditsScreen/Text2"));

        bg2.active = false;

        bg2.scale.set(2.0, 2.0);

        bg2.updateHitbox();

        bg2.setPosition(bg.getCenterX(), 0.0);

        add(bg2);

        bg2.visible = false;

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(FlxG.switchState.bind(() -> new MainMenuScreen()));

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

        rightButton = addOrientedButton(RIGHT, clickRight);

        rightButton.setPosition(FlxG.width - rightButton.width - 170.0, FlxG.height - rightButton.height - 5.0);

        leftButton = addOrientedButton(LEFT, clickLeft);

        leftButton.setPosition(165.0, FlxG.height - leftButton.height - 5.0);

        leftButton.active = false;

        leftButton.visible = false;

        tune = FlxG.sound.load(AssetCache.getMusic("menus/CreditsScreen/Credits"), 1.0, true);

        tune.play();
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.scale.set(2.0, 2.0);

        button.updateHitbox();

        button.onClick.add(onClick);

        add(button);

        return button;
    }

    public function clickRight():Void
    {
        bg.visible = false;

        bg2.visible = true;

        rightButton.active = false;

        rightButton.visible = false;

        leftButton.active = true;

        leftButton.visible = true;
    }

    public function clickLeft():Void
    {
        bg.visible = true;

        bg2.visible = false;

        rightButton.active = true;

        rightButton.visible = true;

        leftButton.active = false;

        leftButton.visible = false;
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }
}