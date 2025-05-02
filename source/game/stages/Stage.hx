package game.stages;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxGroup;

import flixel.util.FlxAxes;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

using StringTools;

class Stage extends FlxGroup
{
    public function new():Void
    {
        super();
    }

    public function sprite(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        if (!path.startsWith("game"))
            path = '${Type.getClassName(Type.getClass(this)).replace(".", "/")}/${path}';

        var spr:FlxSprite = new FlxSprite(0.0, 0.0, Assets.getGraphic(path));

        spr.active = false;

        spr.visible = false;

        spr.scale.set(scaleX, scaleY);

        spr.updateHitbox();

        spr.screenCenter();

        add(spr);

        return spr;
    }

    public function atlasSprite(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        if (!path.startsWith("game"))
            path = '${Type.getClassName(Type.getClass(this)).replace(".", "/")}/${path}';

        var spr = new FlxSprite();

        spr.active = false;

        spr.visible = false;

        spr.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(path), Paths.image(Paths.xml(path)));

        spr.scale.set(scaleX, scaleY);

        spr.updateHitbox();

        spr.screenCenter();

        add(spr);

        return spr;
    }

    public function backdrop(path:String, axes:FlxAxes = XY, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxBackdrop
    {
        var back:FlxBackdrop = new FlxBackdrop(Assets.getGraphic(path), axes);

        back.active = false;

        back.visible = false;

        back.scale.set(scaleX, scaleY);

        back.updateHitbox();

        back.screenCenter();

        add(back);

        return back;
    }
}