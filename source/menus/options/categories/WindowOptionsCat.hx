package menus.options.categories;

import flixel.FlxG;

import menus.options.items.BoolOptionItem;

class WindowOptionsCat extends BaseOptionsCat
{
    public function new():Void
    {
        super("Window\nOptions");

        var bool:BoolOptionItem = new BoolOptionItem("Auto Pause", "If checked, the game will freeze when\nwindow focus is lost.", "autoPause");

        bool.onUpdate.add((value:Bool) -> 
        {
            FlxG.autoPause = value;

            FlxG.console.autoPause = value;
        });

        bool.screenCenter();

        add(bool);
    }
}