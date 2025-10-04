package menus.options.items;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.Paths;

import group.BubbledSpriteGroup;

import menus.options.OptionsMenu.OptionTools;

import interfaces.IHasTooltip;

class BaseOptionItem extends BubbledSpriteGroup implements IHasTooltip
{
    public var title:String;

    public var tooltip:String;

    public var titleText:FlxText;

    public var optionTools:OptionTools;

    public function new(x:Float = 0.0, y:Float = 0.0, title:String, tooltip:String, optionTools:OptionTools):Void
    {
        super(x, y);

        this.title = title;

        this.tooltip = tooltip;

        titleText = new FlxText(0.0, 0.0, 0.0, title, 42);

        titleText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        titleText.alignment = CENTER;

        add(titleText);

        this.optionTools = optionTools;
    }

    /**
     * To be implemented by extending classes.
     */
    public function cancelTouch():Void
    {
        
    }
}