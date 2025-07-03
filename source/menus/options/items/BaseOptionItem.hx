package menus.options.items;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.Paths;

class BaseOptionItem extends FlxSpriteGroup
{
    public var title(default, set):String;

    @:noCompletion
    function set_title(_title:String):String
    {
        title = _title;

        titleText.text = title;

        return title;
    }

    public var description:String;

    public var titleText:FlxText;

    public function new(x:Float = 0.0, y:Float = 0.0, _title:String, _description:String):Void
    {
        super(x, y);

        @:bypassAccessor
        title = _title;

        description = _description;

        titleText = new FlxText(0.0, 0.0, 0.0, title, 42);

        titleText.color = FlxColor.WHITE;

        titleText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        titleText.textField.antiAliasType = ADVANCED;

        titleText.textField.sharpness = 400.0;

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