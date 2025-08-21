package util;

import flixel.FlxG;

import flixel.sound.FlxSound;

import core.AssetCache;

class ClickSoundUtil
{
    public static var itemClick:FlxSound;

    public static var buttonClick:FlxSound;

    public static function resolveSound(type:ClickSoundType = ITEM):FlxSound
    {
        var res:FlxSound = null;

        switch (type:ClickSoundType)
        {
            case ITEM:
                res = (itemClick ??= FlxG.sound.load(AssetCache.getSound("shared/item-click")));

            case BUTTON:
                res = (buttonClick ??= FlxG.sound.load(AssetCache.getSound("shared/button-click")));
        }

        res.persist = true;

        return res;
    }

    public static function playSound(type:ClickSoundType = ITEM, volume:Float = 1.0):Void
    {
        var clickSound:FlxSound = resolveSound(type);

        clickSound.volume = volume;

        clickSound.play(true);
    }
}

enum ClickSoundType
{
    ITEM;

    BUTTON;
}