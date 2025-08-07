package game.stages;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxGroup;

import flixel.util.FlxAxes;

import flixel.addons.display.FlxBackdrop;

import core.AssetCache;
import core.Paths;

using StringTools;

class Stage extends FlxGroup
{
    public var filesPath:String;

    public function new():Void
    {
        super();

        filesPath = getFilesPath();
    }

    public function getFilesPath():String
    {
        return '${Type.getClassName(Type.getClass(this)).replace(".", "/")}/';
    }

    public function getSprite(file:String, prependFilesPath:Bool = true, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        if (prependFilesPath)
            file = filesPath + file;

        var newSprite:FlxSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic(file));

        newSprite.active = false;

        newSprite.visible = false;

        newSprite.scale.set(scaleX, scaleY);

        newSprite.updateHitbox();

        newSprite.screenCenter();

        add(newSprite);

        return newSprite;
    }

    public function getAtlasSprite(file:String, prependFilesPath:Bool = true,
        scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        if (prependFilesPath)
            file = filesPath + file;

        var newSprite = new FlxSprite();

        newSprite.active = false;

        newSprite.visible = false;

        newSprite.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic(file), Paths.image(Paths.xml(file)));

        newSprite.scale.set(scaleX, scaleY);

        newSprite.updateHitbox();

        newSprite.screenCenter();

        add(newSprite);

        return newSprite;
    }

    public function getBackdrop(file:String, prependFilesPath:Bool = true, axes:FlxAxes = XY,
        scaleX:Float = 1.15, scaleY:Float = 1.15):FlxBackdrop
    {
        if (prependFilesPath)
            file = filesPath + file;

        var getBackdrop:FlxBackdrop = new FlxBackdrop(AssetCache.getGraphic(file), axes);

        getBackdrop.active = false;

        getBackdrop.visible = false;

        getBackdrop.scale.set(scaleX, scaleY);

        getBackdrop.updateHitbox();

        getBackdrop.screenCenter();

        add(getBackdrop);

        return getBackdrop;
    }
}