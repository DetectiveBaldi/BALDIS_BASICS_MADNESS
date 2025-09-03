package menus;

import core.Paths;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import core.AssetCache;

import extendable.CustomState;

import flixel.sound.FlxSound;

import ui.BackOutButton;

using util.MathUtil;

class UnlockScreen extends CustomState
{
    public var backOutButton:BackOutButton;

    public var bg:FlxSprite;

    public var border1:FlxSprite;

    public var border2:FlxSprite;

    public var baldi:FlxBackdrop;

    public var wow:FlxSound;

    public var uText:FlxText;

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        bg = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        bg.scale.set(960.0, 720.0);

        bg.updateHitbox();

        bg.screenCenter();

        add(bg);

        baldi = new FlxBackdrop(AssetCache.getGraphic("menus/BaldiHeads"));

        baldi.active = true;

        baldi.velocity.set(-100.0, -50.0);

        add(baldi);

        border1 = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);

        border1.scale.set(160.0, 720.0);

        border1.updateHitbox();

        add(border1);

        border2 = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);

        border2.scale.set(160.0, 720.0);

        border2.updateHitbox();

        border2.setPosition(1120.0, 0.0);

        add(border2);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(FlxG.switchState.bind(() -> new MainMenuScreen()));

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

        uText = new FlxText(0.0, 0.0, FlxG.width);

        uText.color = 0x00FF00;

        uText.text = "Wowee! You just unlocked\n???";

        uText.size = 60;

        uText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        uText.bold = true;

        uText.alignment = CENTER;

        uText.textField.antiAliasType = ADVANCED;

        uText.textField.sharpness = 400.0;

        uText.screenCenter();

        add(uText);

        wow = FlxG.sound.load(AssetCache.getSound("menus/BAL_Wow"), 1.0, false);

        wow.play();
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }
}