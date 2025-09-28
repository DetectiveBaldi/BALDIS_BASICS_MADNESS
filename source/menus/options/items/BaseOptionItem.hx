package menus.options.items;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.Paths;

import interfaces.IHasTooltip;

class BaseOptionItem extends FlxSpriteGroup implements IHasTooltip
{
    public var title(default, set):String;

    @:noCompletion
    function set_title(_title:String):String
    {
        title = _title;

        titleText.text = title;

        return title;
    }

    public var tooltip:String;

    public var titleText:FlxText;

    public function new(x:Float = 0.0, y:Float = 0.0, _title:String, _tooltip:String):Void
    {
        super(x, y);

        @:bypassAccessor
        title = _title;

        tooltip = _tooltip;

        titleText = new FlxText(0.0, 0.0, 0.0, title, 42);

        titleText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        titleText.alignment = CENTER;

        add(titleText);
    }

    /**
     * To be implemented by extending classes.
     */
    public function cancelTouch():Void
    {
        
    }
}