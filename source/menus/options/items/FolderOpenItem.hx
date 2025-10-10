package menus.options.items;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import menus.options.OptionsMenu.OptionTools;

import util.FileTools;

using util.MathUtil;

class FolderOpenItem extends BaseOptionItem
{
    public var selectable:Bool;

    public var strikethrough:FlxSprite;

    public var folderPath:String;

    public function new(x:Float = 0.0, y:Float = 0.0, title:String, tooltip:String, optionTools:OptionTools,
        folderPath:String):Void
    {
        super(x, y, title, tooltip, optionTools);

        selectable = true;

        strikethrough = new FlxSprite().makeGraphic(Math.floor(titleText.width), 3, FlxColor.WHITE);

        strikethrough.kill();

        strikethrough.centerTo(titleText);

        add(strikethrough);

        this.folderPath = folderPath;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(titleText, camera))
        {
            titleText.underline = true;

            if (!selectable)
                strikethrough.revive();

            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
                FileTools.openFolder(folderPath);
        }
        else
        {
            titleText.underline = false;

            strikethrough.kill();
        }
    }
}