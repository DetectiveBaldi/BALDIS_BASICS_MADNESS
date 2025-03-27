package game.stages;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

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

    public var hall5:FlxSprite;

    public var exit0:FlxSprite;

    public var office0:FlxSprite;

    public var office1:FlxSprite;

    public var office2:FlxSprite;

    public var office3:FlxSprite;

    public var office4:FlxSprite;

    public var office5:FlxSprite;

    public var office6:FlxSprite;

    public var office7:FlxSprite;

    public var office8:FlxSprite;

    public var office9:FlxSprite;

    public var officeHall0:FlxSprite;

    public var officeHall1:FlxSprite;

    public var officeHall2:FlxSprite;

    public var officeHall3:FlxSprite;

    public var cafeteriaHall0:FlxSprite;

    public var cafeteriaHall1:FlxSprite;

    public var cafeteriaHall2:FlxSprite;

    public var cafeteriaHall3:FlxSprite;

    public var cafeteria0:FlxSprite;

    public var cafeteria1:FlxSprite;

    public var cafeteria2:FlxSprite;

    public var cafeteria3:FlxSprite;

    public var cafeteria4:FlxSprite;

    public function new():Void
    {
        super();

        hall0 = buildSprite("hall0");

        hall0.visible = true;

        hall1 = buildSprite("hall1");

        hall2 = buildBackdrop("hall2");

        hall3 = buildSprite("hall3");

        hall4 = buildSprite("hall4", 0.75, 0.75);

        hall5 = buildAtlasSprite("hall5");

        hall5.animation.addByPrefix("0", "redLongHall run", 24.0);

        hall5.animation.play("0");
        
        exit0 = buildSprite("exit0", 2.35, 2.35);

        office0 = buildSprite("office0");

        office1 = buildSprite("office1");

        office2 = buildSprite("office2");

        office3 = buildSprite("office3");

        office4 = buildSprite("office4");

        office5 = buildSprite("office5");

        remove(office5, true);

        insert(members.indexOf(office4), office5);

        office6 = buildSprite("office6");

        office7 = buildSprite("office7");

        office8 = buildSprite("office8");

        office9 = buildSprite("office9");

        officeHall0 = buildSprite("office-hall0");

        officeHall1 = buildSprite("office-hall1");

        officeHall2 = buildSprite("office-hall2");

        officeHall3 = buildSprite("office-hall3");
    
        cafeteriaHall0 = buildSprite("cafeteria-hall0");

        cafeteriaHall1 = buildSprite("cafeteria-hall1");

        cafeteriaHall2 = buildSprite("cafeteria-hall2");

        cafeteriaHall3 = buildSprite("cafeteria-hall3");

        cafeteria0 = buildSprite("cafeteria0");

        cafeteria1 = buildSprite("cafeteria1");

        cafeteria2 = buildSprite("cafeteria2");

        cafeteria3 = buildSprite("cafeteria3");

        cafeteria4 = buildSprite("cafeteria4");
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

    public function buildAtlasSprite(path:String, scaleX:Float = 1.15, scaleY:Float = 1.15):FlxSprite
    {
        var sprite = new FlxSprite(0.0, 0.0);

        sprite.visible = false;

        sprite.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.image(Paths.png('game/stages/School/${path}'))),
            Paths.image(Paths.xml('game/stages/School/${path}')));

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