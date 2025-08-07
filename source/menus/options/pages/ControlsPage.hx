package menus.options.pages;

import menus.options.items.ControlOptionItem;

class ControlsPage extends BaseOptionsPage
{
    public function new():Void
    {
        super("Controls");

        var control:ControlOptionItem = addControlOption("Left Note", "Controls for the first note in the strumline.", "NOTE:LEFT");

        control.setPosition(285.0, 170.0);

        control = addControlOption("Down Note", "Controls for the second note in the strumline.", "NOTE:DOWN");

        control.setPosition(285.0, 245.0);

        control = addControlOption("Up Note", "Controls for the third note in the strumline.", "NOTE:UP");

        control.setPosition(285.0, 320.0);

        control = addControlOption("Right Note", "Controls for the fourth note in the strumline.", "NOTE:RIGHT");

        control.setPosition(285.0, 395.0);

        control = addControlOption("Pause", "Controls for entering the pause menu.", "UI:PAUSE");

        control.setPosition(285.0, 500.0);
    }
}