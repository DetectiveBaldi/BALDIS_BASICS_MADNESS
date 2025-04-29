package game.stages;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxGroup;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

class Mystery extends FlxGroup
{
    public var testRoom:FlxSprite;

    public function new():Void
    {
        super();

        testRoom = buildSprite("test-room");
    }

    public function buildSprite(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        var sprite:FlxSprite = new FlxSprite(0.0, 0.0, Assets.getGraphic('game/stages/mystery/${path}'));

        sprite.active = false;

        sprite.visible = false;

        sprite.scale.set(scaleX, scaleY);

        sprite.updateHitbox();

        sprite.screenCenter();

        add(sprite);

        return sprite;
    }

    public function buildAtlasSprite(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        var sprite = new FlxSprite();

        sprite.active = false;

        sprite.visible = false;

        sprite.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic('game/stages/mystery/${path}'),
            Paths.image(Paths.xml('game/stages/mystery/${path}')));

        sprite.scale.set(scaleX, scaleY);

        sprite.updateHitbox();

        sprite.screenCenter();

        add(sprite);

        return sprite;
    }

    public function buildBackdrop(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxBackdrop
    {
        var backdrop:FlxBackdrop = new FlxBackdrop(Assets.getGraphic('game/stages/mystery/${path}'), X);

        backdrop.active = false;

        backdrop.visible = false;

        backdrop.scale.set(scaleX, scaleY);

        backdrop.updateHitbox();

        backdrop.screenCenter();

        add(backdrop);

        return backdrop;
    }
}