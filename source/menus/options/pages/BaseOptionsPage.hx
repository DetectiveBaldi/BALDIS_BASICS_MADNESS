package menus.options.pages;

import flixel.FlxG;

import flixel.group.FlxGroup;

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

    public function addBoolOption(title:String, description:String, option:String):BoolOptionItem
    {
        return optionsGroup.addBoolOption(title, description, option);
    }

    public function addControlOption(title:String, description:String, option:String):ControlOptionItem
    {
        return optionsGroup.addControlOption(title, description, option);
    }

    public function addIntOption(title:String, description:String, option:String, min:Int, max:Int, step:Int,
        cellsToGenerate:Int):IntOptionItem
    {
        return optionsGroup.addIntOption(title, description, option, min, max, step, cellsToGenerate);
    }

    public function cancelTouch():Void
    {
        optionsGroup.touch?.cancelTouch();
    }
}