package menus.options.pages;

import core.SaveManager;

import menus.options.items.EraseSaveItem;
import menus.options.items.FolderOpenItem;
import menus.options.OptionsMenu.OptionTools;

class SavesOptionsPage extends BaseOptionsPage
{
    public function new(optionTools:OptionTools):Void
    {
        super("Saves", optionTools);

        var option:EraseSaveItem = addEraseSaveItem("Erase Options", "Erases ALL option data.", SaveManager.options);

        option.setPosition(285.0, 175.0);

        option = addEraseSaveItem("Erase High Scores", "Erases ALL high score data.", SaveManager.highScores);

        option.setPosition(285.0, 250.0);

        var folderPath:String = "";

        #if sys
        folderPath += 'C:/Users/${Sys.getEnv("USERNAME")}/AppData/Roaming/Mamacitas';
        #end

        var option:FolderOpenItem = addFolderOpenItem("Open Saves Folder", "Be careful! Altering files here\ncould result in data loss.", folderPath);

        #if !sys
        option.selectable = false;
        #end

        option.setPosition(285.0, 335.0);
    }
}