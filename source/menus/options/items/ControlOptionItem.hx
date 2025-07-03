package menus.options.items;

import core.Options;

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
}