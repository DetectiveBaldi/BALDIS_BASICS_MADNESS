package menus.options.pages;

import menus.options.items.BoolOptionItem;
import menus.options.items.NumericOptionItem.IntOptionItem;

class GeneralOptionsPage extends BaseOptionsPage
{
    public function new():Void
    {
        super("General Options");

        var bool:BoolOptionItem = addBoolOption("Auto Pause", "If checked, the game will freeze when\nwindow focus is lost.", "autoPause");

        bool.onUpdate.add(InitState.setAutoPause);

        bool.setPosition(285.0, 175.0);

        var int:IntOptionItem = addIntOption("Frame Rate", "How often the game ticks each second.", "frameRate", 30, 240, 30, 8);

        int.onUpdate.add(InitState.setFrameRateCap);

        int.setPosition(285.0, 250.0);

        bool = addBoolOption("Flashing Lights", "If unchecked, limits the use\nof screen flashing effects.", "flashingLights");

        bool.setPosition(285.0, 375.0);

        bool = addBoolOption("Shaders", "If unchecked, shaders and screen\nfilters are disabled.", "shaders");

        bool.setPosition(285.0, 450.0);
    }
}