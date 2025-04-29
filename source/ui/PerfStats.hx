package ui;

import haxe.Timer;

import openfl.text.TextField;
import openfl.text.TextFormat;

import flixel.FlxG;

import core.Paths;

import util.MathUtil;

class PerfStats extends TextField
{
    public var timestamps:Array<Float>;

    public function new(_x:Float = 0.0, _y:Float = 0.0):Void
    {
        super();

        width = 250;

        height = 100;

        x = _x;

        y = _y;

        antiAliasType = ADVANCED;

        defaultTextFormat = new TextFormat(FlxG.assets.getFontUnsafe(Paths.font(Paths.ttf("Comic Sans MS"))).fontName, 
            16, 0xFFFFFFFF, true);

        embedFonts = true;

        selectable = false;

        sharpness = 400.0;

        text = "FPS: 0";

        timestamps = new Array<Float>();
    }

    @:noCompletion
    override function __enterFrame(deltaTime:Int):Void
    {
        super.__enterFrame(deltaTime);

        var now:Float = Timer.stamp();

        timestamps.push(now);

        while (timestamps[0] < now - 1.0)
            timestamps.shift();

        var tx:String = 'FPS: ${MathUtil.minInt(FlxG.drawFramerate, timestamps.length)}';

        #if debug
        tx += '\nRAM: ${flixel.util.FlxStringUtil.formatBytes(openfl.system.System.totalMemoryNumber)}';

        tx += '\nVRAM: ${flixel.util.FlxStringUtil.formatBytes(FlxG.stage.context3D.totalGPUMemory)}';

        tx += '\nMax Texture Size: ${FlxG.bitmap.maxTextureSize}^2px';
        #end

        if (text != tx)
            text = tx;
    }
}