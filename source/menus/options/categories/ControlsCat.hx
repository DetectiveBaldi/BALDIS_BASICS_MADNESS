package menus.options.categories;

import menus.options.items.ControlOptionItem;

class ControlsCat extends BaseOptionsCat
{
    public function new():Void
    {
        super("Controls");

        var control:ControlOptionItem = addControlOption("Left Note", "Controls for the first note in the strumline.", "NOTE:LEFT");

        control.setPosition(285.0, 185.0);

        control = addControlOption("Down Note", "Controls for the second note in the strumline.", "NOTE:DOWN");

        control.setPosition(285.0, 260.0);

        control = addControlOption("Up Note", "Controls for the third note in the strumline.", "NOTE:UP");

        control.setPosition(285.0, 335.0);

        control = addControlOption("Right Note", "Controls for the fourth note in the strumline.", "NOTE:RIGHT");

        control.setPosition(285.0, 410.0);
    }
}