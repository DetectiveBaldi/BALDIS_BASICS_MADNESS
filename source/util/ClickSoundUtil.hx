package util;

import flixel.FlxG;

import flixel.sound.FlxSound;

import core.AssetCache;

class ClickSoundUtil
{
    public static var itemClick:FlxSound;

    public static var buttonClick:FlxSound;

    public static function loadSound(type:ClickSoundType = ITEM):FlxSound
    {
        var res:FlxSound = null;

        switch (type:ClickSoundType)
        {
            case ITEM:
                res = FlxG.sound.load(AssetCache.getSound("shared/item-click"));

            case BUTTON:
                res = FlxG.sound.load(AssetCache.getSound("shared/button-click"));

        }

        res.persist = true;

        return res;
    }

    public static function playSound(type:ClickSoundType = ITEM, volume:Float = 1.0):Void
    {
        switch (type:ClickSoundType)
        {
            case ITEM:
            {
                if (itemClick == null)
                    itemClick = loadSound(ITEM);

                itemClick.volume = volume;

                itemClick.play(true);
            }

            case BUTTON:
            {
                if (buttonClick == null)
                    buttonClick = loadSound(BUTTON);

                buttonClick.volume = volume;

                buttonClick.play(true);
            }
        }
    }
}

enum ClickSoundType
{
    ITEM;

    BUTTON;
}