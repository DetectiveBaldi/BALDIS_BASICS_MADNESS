package menus.options.pages;

import core.SaveManager;

class SavesOptionsPage extends BaseOptionsPage
{
    public function new():Void
    {
        super("Saves");

        var saveEraseGroup:SaveEraseGroup = addSaveEraseGroup("Erase Options", "Erases ALL option data.", SaveManager.options);

        saveEraseGroup.setPosition(285.0, 170.0);

        saveEraseGroup = addSaveEraseGroup("Erase High Scores", "Erases ALL high score data.", SaveManager.highScores);

        saveEraseGroup.setPosition(285.0, 245.0);
    }
}