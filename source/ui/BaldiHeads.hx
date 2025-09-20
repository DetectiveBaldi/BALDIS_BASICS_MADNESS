package ui;

import flixel.FlxG;

import flixel.math.FlxPoint;

import flixel.addons.display.FlxBackdrop;

import core.AssetCache;

using util.MathUtil;

class BaldiHeads extends FlxBackdrop
{
    public var time:Float;

    public function new():Void
    {
        super(AssetCache.getGraphic("menus/BaldiHeads"));

        time = 0.0;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        time += elapsed * 0.35;

        var anchor:FlxPoint = FlxPoint.get(this.getCenterX(), this.getCenterY());

        var width:Float = FlxG.width * 0.35;

        var height:Float = FlxG.height * 0.35;

        x = anchor.x + width * Math.sin(time);

        y = anchor.y + height * Math.sin(time) * Math.cos(time);

        anchor.put();
    }
}