package menus.options.pages;

import api.DiscordHandler;

import menus.options.items.BoolOptionItem;
import menus.options.OptionsMenu.OptionTools;

class TestingOptionsPage extends BaseOptionsPage
{
    public function new(optionTools:OptionTools):Void
    {
        super("Testing Options", optionTools);

        var bool:BoolOptionItem = addBoolOption("Discord RPC", "If checked, the game will appear with\na unique status on your Discord account.", "discordRPC");

        bool.onUpdate.add((v:Bool) ->
        {
            if (v)
            {
                DiscordHandler.init();

                DiscordHandler.updatePresence();
            }
            else
                DiscordHandler.shutdown();
        });

        bool.selectable = #if FEATURE_DISCORD_HANDLER true #else false #end ;

        bool.setPosition(285.0, 175.0);

        bool = addBoolOption("GPU Caching", "If checked, bitmap pixel data is disposed\nfrom RAM where possible.", "gpuCaching");

        bool.selectable = #if FEATURE_GPU_CACHING true #else false #end ;

        bool.setPosition(285.0, 260.0);

        bool = addBoolOption("Sound Streaming", "If checked, audio is loaded progressively\nwhere suitable.", "soundStreaming");

        bool.selectable = #if FEATURE_SOUND_STREAMING true #else false #end ;

        bool.setPosition(285.0, 335.0);
    }
}