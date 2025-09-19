package util;

import flixel.FlxG;

import flixel.sound.FlxSound;

import core.AssetCache;

class ClickSoundUtil
{
    public static var itemClick:FlxSound;

    public static var buttonClick:FlxSound;

    public static function init():Void
    {
        buttonClick = FlxG.sound.load(AssetCache.getSound("shared/button-click"));

        buttonClick.persist = true;

        itemClick = FlxG.sound.load(AssetCache.getSound("shared/item-click"));

        itemClick.persist = true;
    }

    public static function resolve(type:ClickSoundType = ITEM):FlxSound
    {
        return type == BUTTON ? buttonClick : itemClick;
    }

    public static function play(type:ClickSoundType = ITEM, volume:Float = 1.0):Void
    {
        var clickSound:FlxSound = resolve(type);

        clickSound.volume = volume;

        clickSound.play(true);
    }
}

enum ClickSoundType
{
    BUTTON;

    ITEM;
}