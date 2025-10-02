package menus.options;

import flixel.FlxG;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.util.FlxSave;

import menus.options.items.BaseOptionItem;
import menus.options.items.BoolOptionItem;
import menus.options.items.ControlOptionItem;
import menus.options.items.NumericOptionItem;

class OptionsGroup extends FlxTypedGroup<BaseOptionItem>
{
    public var touch:BaseOptionItem;
    
    public function new():Void
    {
        super();
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
                    if (touch == option)
                        continue;

                    touch?.cancelTouch();

                    touch = option;

                    break;
                }
            }
        }
    }

    public function addBoolOption(title:String, tooltip:String, option:String):BoolOptionItem
    {
        var opt:BoolOptionItem = new BoolOptionItem(0.0, 0.0, title, tooltip, option);

        add(opt);

        return opt;
    }

    public function addControlOption(title:String, tooltip:String, option:String):ControlOptionItem
    {
        var opt:ControlOptionItem = new ControlOptionItem(0.0, 0.0, title, tooltip, option);

        add(opt);

        return opt;
    }

    public function addIntOption(title:String, tooltip:String, option:String, min:Int, max:Int, step:Int,
        cellsToGenerate:Int):IntOptionItem
    {
        var opt:IntOptionItem = new IntOptionItem(0.0, 0.0, title, tooltip, option, min, max, step, cellsToGenerate);

        add(opt);

        return opt;
    }

    public function addSaveEraseGroup(title:String, tooltip:String, save:FlxSave):SaveEraseGroup
    {
        var opt:SaveEraseGroup = new SaveEraseGroup(0.0, 0.0, title, tooltip, save);

        add(opt);

        return opt;
    }
}