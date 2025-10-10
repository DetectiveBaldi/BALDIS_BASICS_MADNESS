package menus.options.items;

import flixel.FlxG;

import flixel.util.FlxSave;

import core.SaveManager;

import menus.options.items.BaseOptionItem;
import menus.options.OptionsMenu.OptionTools;

import util.ClickSoundUtil;

using util.MathUtil;

class EraseSaveItem extends BaseOptionItem
{
    public var panel:OptionsPanel;

    public var save:FlxSave;

    public function new(x:Float = 0.0, y:Float = 0.0, title:String, tooltip:String, optionTools:OptionTools, save:FlxSave):Void
    {
        super(x, y, title, tooltip, optionTools);

        panel = new OptionsPanel();

        panel.x = titleText.x + 420.0;

        panel.kill();

        panel.onClick.add(eraseSave);

        add(panel);

        this.save = save;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(titleText, camera))
        {
            titleText.underline = true;

            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
            {
                panel.revive();

                ClickSoundUtil.play();
            }
        }
        else
            titleText.underline = false;
    }

    override function cancelTouch():Void
    {
        super.cancelTouch();

        panel.kill();
    }

    public function eraseSave():Void
    {
        if (save == SaveManager.options)
        {
            SaveManager.eraseOptions();

            optionTools.dispatch("erase-options");
        }
        else
            SaveManager.eraseHighScores();
    }
}