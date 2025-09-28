package menus.options.pages;

import flixel.group.FlxGroup;

import flixel.util.FlxSave;

import menus.options.items.BoolOptionItem;
import menus.options.items.ControlOptionItem;
import menus.options.items.NumericOptionItem;

class BaseOptionsPage extends FlxGroup
{
    public var name:String;

    public var optionsGroup:OptionsGroup;

    public function new(name:String):Void
    {
        super();

        this.name = name;

        optionsGroup = new OptionsGroup();

        add(optionsGroup);
    }

    public function addBoolOption(title:String, tooltip:String, option:String):BoolOptionItem
    {
        return optionsGroup.addBoolOption(title, tooltip, option);
    }

    public function addControlOption(title:String, tooltip:String, option:String):ControlOptionItem
    {
        return optionsGroup.addControlOption(title, tooltip, option);
    }

    public function addIntOption(title:String, tooltip:String, option:String, min:Int, max:Int, step:Int,
        cellsToGenerate:Int):IntOptionItem
    {
        return optionsGroup.addIntOption(title, tooltip, option, min, max, step, cellsToGenerate);
    }

    public function addSaveEraseGroup(title:String, tooltip:String, save:FlxSave):SaveEraseGroup
    {
        return optionsGroup.addSaveEraseGroup(title, tooltip, save);
    }

    public function cancelTouch():Void
    {
        optionsGroup.touch?.cancelTouch();
    }
}