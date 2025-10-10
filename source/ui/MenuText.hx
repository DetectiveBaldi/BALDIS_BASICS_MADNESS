package ui;

import flixel.FlxG;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.Paths;

import util.ClickSoundUtil;

class MenuText extends FlxText
{
    public var unlitColor:FlxColor;

    public var litColor:FlxColor;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, text:String = ""):Void
    {
        super(x, y, 0.0, text);

        font = Paths.font(Paths.ttf("Comic Sans MS"));

        size = 42;

        alignment = CENTER;

        unlitColor = FlxColor.WHITE;

        litColor = FlxColor.LIME;

        onClick = new FlxSignal();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            color = litColor;

            underline = true;

            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
            {
                ClickSoundUtil.play();

                onClick.dispatch();
            }
        }
        else
        {
            color = unlitColor;

            underline = false;
        }
    }

    override function destroy():Void
    {
        super.destroy();

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}