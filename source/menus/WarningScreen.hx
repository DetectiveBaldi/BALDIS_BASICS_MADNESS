package menus;

import flixel.FlxG;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Paths;

import extendable.CustomState;

class WarningScreen extends CustomState
{
    public var text:FlxText;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        var textColorSwap:FlxTextFormat = new FlxTextFormat(FlxColor.RED);

        var rules:Array<FlxTextFormatMarkerPair> = [new FlxTextFormatMarkerPair(textColorSwap, "<color-swap>")];

        var textToShow:String = "";

        textToShow += "<color-swap>WARNING\n\n<color-swap>";

        textToShow += "This is a mod of Friday Night Funkin',\n";

        textToShow += "based off a<color-swap> horror game <color-swap>called Baldi's Basics.\n";

        textToShow += "This mod includes\n";

        textToShow += "flashing lights, loud noises, and\n";

        textToShow += "other elements that might make the player\n";

        textToShow += "uncomfortable.\n\n";

        textToShow += "If you wish to not experience any of this,\n";

        textToShow += "<color-swap>DO NOT PLAY.\n\n<color-swap>";

        textToShow += "PRESS ANY BUTTON TO CONTINUE.";

        text = new FlxText(0.0, 0.0, FlxG.width, textToShow);

        text.font = Paths.font(Paths.ttf("Comic Sans MS"));

        text.alignment = CENTER;

        text.size = 36;

        text.textField.antiAliasType = ADVANCED;

        text.textField.sharpness = 400.0;

        text.screenCenter();

        add(text);

        text.applyMarkup(textToShow, rules);

        tune = FlxG.sound.load(AssetCache.getMusic("menus/WarningScreen/tune"), 1.0, true);

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.ANY || FlxG.mouse.justReleased)
            FlxG.switchState(() -> new TitleScreen());
    }
}