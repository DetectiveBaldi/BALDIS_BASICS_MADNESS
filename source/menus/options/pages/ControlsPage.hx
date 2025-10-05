package menus.options.pages;

import menus.options.items.ControlOptionItem;
import menus.options.OptionsMenu.OptionTools;

class ControlsPage extends BaseOptionsPage
{
    public function new(optionTools:OptionTools):Void
    {
        super("Controls", optionTools);

        var control:ControlOptionItem = addControlOption("Left Note", "Controls for the first note in the strumline.", "NOTE:LEFT");

        control.setPosition(285.0, 175.0);

        control = addControlOption("Down Note", "Controls for the second note in the strumline.", "NOTE:DOWN");

        control.setPosition(285.0, 250.0);

        control = addControlOption("Up Note", "Controls for the third note in the strumline.", "NOTE:UP");

        control.setPosition(285.0, 325.0);

        control = addControlOption("Right Note", "Controls for the fourth note in the strumline.", "NOTE:RIGHT");

        control.setPosition(285.0, 400.0);

        control = addControlOption("Pause", "Controls for toggling the pause menu.", "UI:PAUSE");

        control.setPosition(285.0, 475.0);
    }
}