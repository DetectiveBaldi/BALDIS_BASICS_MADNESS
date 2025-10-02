package menus.options.items;

import flixel.FlxG;

import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.Options;
import core.Paths;

import util.ClickSoundUtil;

class ControlOptionItem extends VariableOptionItem<Array<Int>>
{
    override function get_value():Array<Int>
    {
        return Options.controls[option];
    }

    override function set_value(_value:Array<Int>):Array<Int>
    {
        Options.controls[option] = _value;

        Options.controls = Options.controls;

        return value;
    }

    public var controlsText:FlxText;

    public var controlIndex:Int;

    public var input:FlxKeyboard;

    public var selected:Bool;

    public function new(_x:Float = 0.0, _y:Float = 0.0, _title:String, _tooltip:String, _option:String):Void
    {
        super(_x, _y, _title, _tooltip, _option);

        controlsText = new FlxText(0.0, 0.0, 0.0, title, 42);

        controlsText.color = FlxColor.WHITE;

        controlsText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        controlsText.alignment = CENTER;

        add(controlsText);

        controlIndex = 0;

        updateControlsText();

        input = new FlxKeyboard();

        input.enabled = false;

        FlxG.inputs.addInput(input);

        selected = false;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (selected)
        {
            titleText.color = FlxColor.LIME;
            
            titleText.underline = false;

            if (FlxG.keys.enabled)
            {
                if (FlxG.keys.justPressed.ESCAPE)
                    cancelTouch();

                if (FlxG.keys.justPressed.LEFT)
                    controlIndex = FlxMath.wrap(controlIndex - 1, 0, 1);

                if (FlxG.keys.justPressed.RIGHT)
                    controlIndex = FlxMath.wrap(controlIndex + 1, 0, 1);

                if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
                    updateControlsText();

                if (FlxG.keys.justPressed.ENTER)
                {
                    FlxG.keys.enabled = false;

                    controlsText.text = "...";

                    controlsText.x = titleText.x + titleText.width + 10.0;

                    input.enabled = true;

                    input.reset();
                }
            }
            else
            {
                var firstJustPressed:Int = input.firstJustPressed();

                if (firstJustPressed != -1.0)
                {
                    value[controlIndex] = firstJustPressed;

                    cancelTouch();
                }
            }
        }
        else
        {
            titleText.color = FlxColor.WHITE;

            if (FlxG.mouse.overlaps(titleText, camera))
            {
                titleText.underline = true;

                if (FlxG.mouse.justReleased)
                {
                    ClickSoundUtil.play();

                    selected = true;
                }
            }
            else
                titleText.underline = false;
        }
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.keys.enabled = true;

        FlxG.keys.reset();

        FlxG.inputs.remove(input);

        input.enabled = false;

        input.destroy();
    }

    override function cancelTouch():Void
    {
        super.cancelTouch();

        FlxG.keys.enabled = true;

        FlxG.keys.reset();

        controlIndex = 0;

        updateControlsText();

        input.enabled = false;

        selected = false;
    }

    public function updateControlsText():Void
    {
        if (controlIndex == 0)
            controlsText.text = ': (${FlxKey.toStringMap[value[0]]}) ${FlxKey.toStringMap[value[1]]}';
        else
            controlsText.text = ': ${FlxKey.toStringMap[value[0]]} (${FlxKey.toStringMap[value[1]]})';

        controlsText.x = titleText.x + titleText.width;
    }
}