package menus;

import flixel.FlxG;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import api.DiscordHandler;

import core.AssetCache;
import core.Paths;

import extendable.TransitionState;

class WarningScreen extends TransitionState
{
    public var text:FlxText;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        DiscordHandler.setState(null);

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        DiscordHandler.setImageTexts(null, null);

        var textColorSwap:FlxTextFormat = new FlxTextFormat(FlxColor.RED);

        var rules:Array<FlxTextFormatMarkerPair> = [new FlxTextFormatMarkerPair(textColorSwap, "<color-swap>")];

        var textToShow:String = "";

        textToShow += "<color-swap>WARNING\n\n<color-swap>";

        textToShow += "This is a mod for Friday Night Funkin'\n";

        textToShow += "based off of the<color-swap> indie horror game <color-swap>named\n Baldi's Basics.";

        textToShow += " As such, this mod includes\n";

        textToShow += "flashing lights, loud noises, and\n";

        textToShow += "other elements that might make\nsome players uncomfortable.\n\n";

        textToShow += "If you don't wish to experience any of this,\n";

        textToShow += "<color-swap>DO NOT PLAY.\n\n<color-swap>";

        textToShow += "PRESS ANY BUTTON TO CONTINUE.";

        text = new FlxText(0.0, 0.0, FlxG.width, textToShow);

        text.font = Paths.font(Paths.ttf("Comic Sans MS"));

        text.alignment = CENTER;

        text.size = 36;

        text.screenCenter();

        add(text);

        text.applyMarkup(textToShow, rules);

        tune = FlxG.sound.load(AssetCache.getMusic("menus/WarningScreen/tune"), 1.0, true);

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.ANY || (FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
            FlxG.switchState(() -> new TitleScreen());
    }

    override function destroy():Void
    {
        super.destroy();
        
        FlxG.mouse.visible = false;
    }
}