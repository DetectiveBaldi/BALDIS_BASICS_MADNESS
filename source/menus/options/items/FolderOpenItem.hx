package menus.options.items;

import flixel.FlxG;

import menus.options.OptionsMenu.OptionTools;

import util.FileTools;

class FolderOpenItem extends BaseOptionItem
{
    public var folderPath:String;

    public function new(x:Float = 0.0, y:Float = 0.0, title:String, tooltip:String, folderPath:String,
        optionTools:OptionTools):Void
    {
        super(x, y, title, tooltip, optionTools);

        this.folderPath = folderPath;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(titleText, camera))
        {
            titleText.underline = true;

            if (FlxG.mouse.justReleased)
                FileTools.openFolder(folderPath);
        }
        else
            titleText.underline = false;
    }
}