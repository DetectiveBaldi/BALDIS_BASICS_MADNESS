package menus.options.pages;

import flixel.group.FlxGroup;

import flixel.util.FlxSave;

import menus.options.items.BoolOptionItem;
import menus.options.items.ControlOptionItem;
import menus.options.items.EraseSaveItem;
import menus.options.items.FolderOpenItem;
import menus.options.items.NumericOptionItem;
import menus.options.OptionsMenu.OptionTools;

class BaseOptionsPage extends FlxGroup
{
    public var name:String;

    public var optionsGroup:OptionsGroup;

    public function new(name:String, optionTools:OptionTools):Void
    {
        super();

        this.name = name;

        optionsGroup = new OptionsGroup(optionTools);

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

    public function addFolderOpenItem(title:String, tooltip:String, folderPath:String):FolderOpenItem
    {
        return optionsGroup.addFolderOpenItem(title, tooltip, folderPath);
    }

    public function addIntOption(title:String, tooltip:String, option:String, min:Int, max:Int, step:Int,
        cellAmount:Int):IntOptionItem
    {
        return optionsGroup.addIntOption(title, tooltip, option, min, max, step, cellAmount);
    }

    public function addEraseSaveItem(title:String, tooltip:String, save:FlxSave):EraseSaveItem
    {
        return optionsGroup.addEraseSaveItem(title, tooltip, save);
    }

    public function cancelTouch():Void
    {
        optionsGroup.touch?.cancelTouch();
    }
}