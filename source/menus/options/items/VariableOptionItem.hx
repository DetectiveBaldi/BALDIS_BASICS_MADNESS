package menus.options.items;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal.FlxTypedSignal;

import core.Options;

import menus.options.OptionsMenu.OptionTools;

class VariableOptionItem<T> extends BaseOptionItem
{
    public var option:String;

    public var value:T;

    public var onUpdate:FlxTypedSignal<(value:T)->Void>;

    public function new(x:Float = 0.0, y:Float = 0.0, title:String, tooltip:String, optionTools:OptionTools, option:String):Void
    {
        super(x, y, title, tooltip, optionTools);

        this.option = option;

        value = getValue();

        onUpdate = new FlxTypedSignal<(value:T)->Void>();
    }

    override function destroy():Void
    {
        super.destroy();

        onUpdate = cast FlxDestroyUtil.destroy(onUpdate);
    }

    public function getValue():T
    {
        return Reflect.getProperty(Options, option);
    }

    public function setValue(val:T):Void
    {
        value = val;

        Reflect.setProperty(Options, option, value);

        onUpdate.dispatch(value);
    }
}