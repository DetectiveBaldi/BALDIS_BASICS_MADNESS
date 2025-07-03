package menus.options.categories;

import flixel.group.FlxGroup;

import menus.options.items.BaseOptionItem;
import menus.options.items.BoolOptionItem;
import menus.options.items.NumericOptionItem;

class BaseOptionsCat extends FlxTypedGroup<BaseOptionItem>
{
    public var name:String;

    public function new(name:String):Void
    {
        super();

        this.name = name;
    }

    public function addBoolOption(title:String, description:String, option:String):BoolOptionItem
    {
        var opt:BoolOptionItem = new BoolOptionItem(0.0, 0.0, title, description, option);

        add(opt);

        return opt;
    }

    public function addIntOption(title:String, description:String, option:String, min:Int, max:Int, step:Int,
        cellsToGenerate:Int):IntOptionItem
    {
        var opt:IntOptionItem = new IntOptionItem(0.0, 0.0, title, description, option, min, max, step, cellsToGenerate);

        add(opt);

        return opt;
    }
}