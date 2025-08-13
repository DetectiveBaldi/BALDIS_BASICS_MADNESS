package menus.options.pages;

import flixel.FlxG;

import flixel.group.FlxGroup;

import menus.options.items.BaseOptionItem;
import menus.options.items.BoolOptionItem;
import menus.options.items.ControlOptionItem;
import menus.options.items.NumericOptionItem;

class BaseOptionsPage extends FlxTypedGroup<BaseOptionItem>
{
    public var name:String;

    public var lastTouch:BaseOptionItem;

    public function new(name:String):Void
    {
        super();

        this.name = name;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        for (i in 0 ... members.length)
        {
            var option:BaseOptionItem = members[i];

            if (FlxG.mouse.overlaps(option))
            {
                if (FlxG.mouse.justReleased)
                {
                    if (lastTouch == option)
                        continue;

                    lastTouch?.cancelTouch();

                    lastTouch = option;
                }
            }
        }
    }

    public function addBoolOption(title:String, description:String, option:String):BoolOptionItem
    {
        var opt:BoolOptionItem = new BoolOptionItem(0.0, 0.0, title, description, option);

        add(opt);

        return opt;
    }

    public function addControlOption(title:String, description:String, option:String):ControlOptionItem
    {
        var opt:ControlOptionItem = new ControlOptionItem(0.0, 0.0, title, description, option);

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