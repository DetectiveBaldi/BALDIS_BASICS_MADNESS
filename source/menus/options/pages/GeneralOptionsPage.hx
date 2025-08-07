package menus.options.pages;

import flixel.FlxG;

import menus.options.items.BoolOptionItem;
import menus.options.items.NumericOptionItem.IntOptionItem;

class GeneralOptionsPage extends BaseOptionsPage
{
    public function new():Void
    {
        super("General Options");

        var bool:BoolOptionItem = addBoolOption("Auto Pause", "If checked, the game will freeze when\nwindow focus is lost.", "autoPause");

        bool.onUpdate.add(InitState.setAutoPause);

        bool.setPosition(285.0, 275.0);

        var int:IntOptionItem = addIntOption("Frame Rate", "How often the game ticks each second.", "frameRate", 30, 240, 30, 8);

        int.onUpdate.add(InitState.setFrameRateCap);

        int.setPosition(285.0, 350.0);

        bool = addBoolOption("GPU Caching", "If checked, bitmap pixel data is disposed\nfrom RAM where applicable.", "gpuCaching");

        bool.setPosition(285.0, 450.0);

        bool = addBoolOption("Sound Streaming", "If checked, audio is loaded\nprogressively where applicable.", "soundStreaming");

        bool.setPosition(285.0, 525.0);

        bool = addBoolOption("Flashing Lights", "If unchecked, limits the use\nof screen flashing effects.", "flashingLights");

        bool.setPosition(625.0, 170.0);

        bool = addBoolOption("Shaders", "If unchecked, shaders and screen\nfilters are disabled.", "shaders");

        bool.setPosition(625.0, 245.0);
    }
}