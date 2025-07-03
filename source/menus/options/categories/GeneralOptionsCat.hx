package menus.options.categories;

import flixel.FlxG;

import menus.options.items.BoolOptionItem;
import menus.options.items.NumericOptionItem.IntOptionItem;

class GeneralOptionsCat extends BaseOptionsCat
{
    public function new():Void
    {
        super("General Options");

        var bool:BoolOptionItem = addBoolOption("Auto Pause", "If checked, the game will freeze when\nwindow focus is lost.", "autoPause");

        bool.onUpdate.add((value:Bool) -> 
        {
            FlxG.autoPause = value;

            FlxG.console.autoPause = value;
        });

        bool.setPosition(285.0, 250.0);

        bool = addBoolOption("GPU Caching", "If checked, bitmap pixel data is disposed\nfrom RAM where applicable", "gpuCaching");

        bool.setPosition(285.0, 450.0);

        bool = addBoolOption("Sound Streaming", "If checked, audio is loaded\nprogressively where applicable.", "soundStreaming");

        bool.setPosition(285.0, 525.0);

        bool = addBoolOption("Flashing", "If unchecked, screen effects\nsuch as flashing are limited.", "flashing");

        bool.setPosition(685.0, 150.0);

        bool = addBoolOption("Shaders", "If unchecked, screen effects\nsuch as shaders are limited.", "shaders");

        bool.setPosition(685.0, 225.0);

        var int:IntOptionItem = addIntOption("Frame Rate", "How often the game ticks each second.", "frameRate", 30, 240, 30, 8);

        int.onUpdate.add((value:Int) ->
        {
            InitState.setFrameRateCap(value);
        });

        int.setPosition(285.0, 350.0);
    }
}