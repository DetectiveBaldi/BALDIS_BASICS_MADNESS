package menus.options;

import flixel.FlxG;

import flixel.util.FlxSave;

import core.SaveManager;

import menus.options.items.BaseOptionItem;

import util.ClickSoundUtil;

class SaveEraseGroup extends BaseOptionItem
{
    public var save:FlxSave;

    public var panel:ConfirmationPanel;

    public function new(x:Float = 0.0, y:Float = 0.0, title:String, description:String, save:FlxSave):Void
    {
        super(x, y, title, description);

        this.save = save;

        panel = new ConfirmationPanel();

        panel.x = titleText.x + 420.0;

        panel.kill();

        panel.onClick.add(eraseSave);

        add(panel);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(titleText, camera))
        {
            titleText.underline = true;

            if (FlxG.mouse.justReleased)
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
        save == SaveManager.options ? SaveManager.eraseOptions() : SaveManager.eraseHighScores();
    }
}