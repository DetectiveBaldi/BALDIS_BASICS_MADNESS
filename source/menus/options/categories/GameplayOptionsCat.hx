package menus.options.categories;

import menus.options.items.BoolOptionItem;

class GameplayOptionsCat extends BaseOptionsCat
{
    public function new():Void
    {
        super("Gameplay Options");

        var bool:BoolOptionItem = addBoolOption("Downscroll", "If checked, flips the\nstrumlines' vertical position.", "downscroll");

        bool.setPosition(285.0, 185.0);

        bool = addBoolOption("Ghost Tapping", "If unchecked, pressing an input with\nno notes on screen will cause damage.", "ghostTapping");

        bool.setPosition(285.0, 260.0);

        bool = addBoolOption("Botplay", "If checked, inputs will be\nprocessed automatically.", "botplay");

        bool.setPosition(285.0, 335.0);
    }
}