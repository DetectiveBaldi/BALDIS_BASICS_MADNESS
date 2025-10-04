package menus.options;

import flixel.FlxG;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.util.FlxSave;

import menus.options.items.BaseOptionItem;
import menus.options.items.BoolOptionItem;
import menus.options.items.ControlOptionItem;
import menus.options.items.EraseSaveItem;
import menus.options.items.FolderOpenItem;
import menus.options.items.NumericOptionItem;
import menus.options.OptionsMenu.OptionTools;

class OptionsGroup extends FlxTypedGroup<BaseOptionItem>
{
    public var optionTools:OptionTools;

    public var touch:BaseOptionItem;
    
    public function new(optionTools:OptionTools):Void
    {
        super();

        this.optionTools = optionTools;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
        {
            var foundOverlap:Bool = false;

            for (i in 0 ... members.length)
            {
                var option:BaseOptionItem = members[i];

                if (FlxG.mouse.overlaps(option))
                {
                    foundOverlap = true;
                    
                    if (touch == option)
                        continue;

                    updateTouch(option);
                }
            }

            if (!foundOverlap)
                updateTouch(null);
        }
    }

    public function addBoolOption(title:String, tooltip:String, option:String):BoolOptionItem
    {
        var opt:BoolOptionItem = new BoolOptionItem(0.0, 0.0, title, tooltip, option, optionTools);

        add(opt);

        return opt;
    }

    public function addControlOption(title:String, tooltip:String, option:String):ControlOptionItem
    {
        var opt:ControlOptionItem = new ControlOptionItem(0.0, 0.0, title, tooltip, option, optionTools);

        add(opt);

        return opt;
    }

    public function addFolderOpenItem(title:String, tooltip:String, folderPath:String):FolderOpenItem
    {
        var opt:FolderOpenItem = new FolderOpenItem(0.0, 0.0, title, tooltip, folderPath, optionTools);

        add(opt);

        return opt;
    }

    public function addIntOption(title:String, tooltip:String, option:String, min:Int, max:Int, step:Int,
        cellAmount:Int):IntOptionItem
    {
        var opt:IntOptionItem = new IntOptionItem(0.0, 0.0, title, tooltip, option, min, max, step, cellAmount, optionTools);

        add(opt);

        return opt;
    }

    public function addEraseSaveItem(title:String, tooltip:String, save:FlxSave):EraseSaveItem
    {
        var opt:EraseSaveItem = new EraseSaveItem(0.0, 0.0, title, tooltip, save, optionTools);

        add(opt);

        return opt;
    }

    public function updateTouch(v:BaseOptionItem):Void
    {
        touch?.cancelTouch();

        touch = v;
    }
}