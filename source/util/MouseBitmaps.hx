package util;

import openfl.display.BitmapData;

import flixel.FlxG;

import flixel.graphics.FlxGraphic;

import core.AssetCache;

class MouseBitmaps
{
    public static var handMouseBitmap:BitmapData;

    public static var launcherMouseBitmap:BitmapData;

    public static function init():Void
    {
        var handMouseGraphic:FlxGraphic = AssetCache.getGraphic("shared/cursor-hand");

        handMouseGraphic.incrementUseCount();

        handMouseBitmap = handMouseGraphic.bitmap;

        var launcherMouseGraphic:FlxGraphic = AssetCache.getGraphic("shared/cursor-launcher");

        launcherMouseGraphic.incrementUseCount();

        launcherMouseBitmap = launcherMouseGraphic.bitmap;
    }

    public static function getMouseBitmap(bitmap:BitmapData):CustomMouseBitmap
    {
        return bitmap == handMouseBitmap ? HAND : LAUNCHER;
    }

    public static function setMouseBitmap(newBitmap:CustomMouseBitmap):Void
    {
        var oldBitmap:CustomMouseBitmap = getMouseBitmap(FlxG.mouse.cursor.bitmapData);

        if (newBitmap == oldBitmap)
            return;
        
        FlxG.mouse.load(newBitmap == HAND ? handMouseBitmap : launcherMouseBitmap);
    }
}

enum CustomMouseBitmap
{
    HAND;

    LAUNCHER;
}