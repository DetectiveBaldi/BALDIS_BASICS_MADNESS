package menus.options.categories;

import flixel.group.FlxGroup;

import menus.options.items.BaseOptionItem;

class BaseOptionsCat extends FlxTypedGroup<BaseOptionItem>
{
    public var name:String;

    public function new(name:String):Void
    {
        super();

        this.name = name;
    }
}