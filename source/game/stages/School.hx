package game.stages;

import flixel.FlxSprite;

import flixel.group.FlxGroup;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

class School extends FlxGroup
{
    public var hall0:FlxSprite;

    public var hall1:FlxSprite;

    public var hall2:FlxBackdrop;

    public var hall3:FlxSprite;

    public var hall4:FlxSprite;

    public function new():Void
    {
        super();

        hall0 = buildSprite("hall0");

        hall0.visible = true;

        hall1 = buildSprite("hall1");

        hall2 = buildBackdrop("hall2");

        hall3 = buildSprite("hall3");

        hall4 = buildSprite("hall4", 0.75, 0.75);
    }

    public function buildSprite(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        var sprite:FlxSprite = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png('game/stages/School/${path}'))));

        sprite.visible = false;

        sprite.scale.set(scaleX, scaleY);

        sprite.updateHitbox();

        sprite.screenCenter();

        add(sprite);

        return sprite;
    }

    public function buildBackdrop(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxBackdrop
    {
        var backdrop:FlxBackdrop = new FlxBackdrop(Assets.getGraphic(Paths.image(Paths.png('game/stages/School/${path}'))), X);

        backdrop.visible = false;

        backdrop.scale.set(scaleX, scaleY);

        backdrop.updateHitbox();

        backdrop.screenCenter();

        add(backdrop);

        return backdrop;
    }
}