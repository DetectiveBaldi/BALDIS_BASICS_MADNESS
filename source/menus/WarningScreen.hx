package menus;

import flixel.FlxG;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.Assets;
import core.Paths;

import extendable.ResourceState;

class WarningScreen extends ResourceState
{
    public var text:FlxText;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic("shared/cursor-default").bitmap);

        var _text:String = "";

        _text += "WARNING\n\n";

        _text += "This is a mod of Friday Night Funkin',\n";

        _text += "based off a horror game called Baldi's Basics.\n";

        _text += "This mod includes\n";

        _text += "flashing lights, loud noises, and\n";

        _text += "other elements that might make the player\n";

        _text += "uncomfortable.\n\n";

        _text += "If you wish to not experience any of this,\n";

        _text += "DO NOT PLAY.\n\n";

        _text += "PRESS ANY BUTTON TO CONTINUE.";

        text = new FlxText(0.0, 0.0, FlxG.width, _text);

        text.font = Paths.font(Paths.ttf("Comic Sans MS"));

        text.alignment = CENTER;

        text.size = 36;

        text.textField.antiAliasType = ADVANCED;

        text.textField.sharpness = 400.0;

        text.screenCenter();

        add(text);

        var colorSwap:FlxTextFormat = new FlxTextFormat(FlxColor.RED);

        text.addFormat(colorSwap, 0, 7);

        text.addFormat(colorSwap, 60, 71);

        text.addFormat(colorSwap, 248, 260);

        tune = FlxG.sound.load(Assets.getMusic("menus/WarningScreen/tune"), 1.0, true);

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed)
            FlxG.switchState(() -> new TitleScreen());
    }
}