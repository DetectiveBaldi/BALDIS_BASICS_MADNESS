package menus.options.pages;

import menus.options.items.BoolOptionItem;
import menus.options.OptionsMenu.OptionTools;

class GameplayOptionsPage extends BaseOptionsPage
{
    public function new(optionTools:OptionTools):Void
    {
        super("Gameplay Options", optionTools);

        var bool:BoolOptionItem = addBoolOption("Downscroll", "If checked, flips the\nstrumlines' vertical position.", "downscroll");

        bool.setPosition(285.0, 170.0);

        bool = addBoolOption("Ghost Tapping", "If unchecked, pressing an input with\nno notes on screen will cause damage.", "ghostTapping");

        bool.setPosition(285.0, 255.0);

        bool = addBoolOption("Botplay", "If checked, inputs will be\nprocessed automatically.", "botplay");

        bool.setPosition(285.0, 340.0);
    }
}