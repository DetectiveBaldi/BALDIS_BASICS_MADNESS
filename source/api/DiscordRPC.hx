package api;

#if cpp
import hxdiscord_rpc.Types;
class DiscordRPC
{
    public static final DISCORD_ID:String = "1220870416374038649";

	public static var workHelper:sys.thread.Thread;

	// Cached helper object so that we don't need to constantly recreate this type.
	public static var presence:hxdiscord_rpc.Types.DiscordRichPresence;

    public static function init():Void
    {
        final handlers:hxdiscord_rpc.Types.DiscordEventHandlers = new hxdiscord_rpc.Types.DiscordEventHandlers();

        hxdiscord_rpc.Discord.Initialize(DISCORD_ID, cpp.RawPointer.addressOf(handlers), false, null);

        workHelper = sys.thread.Thread.create(doWork);

		presence = new hxdiscord_rpc.Types.DiscordRichPresence();
    }

	public static function shutdown():Void
    {
        hxdiscord_rpc.Discord.Shutdown();
    }

	public static function doWork():Void
	{
		while (true)
		{
			#if DISCORD_DISABLE_IO_THREAD
			Discord.UpdateConnection();
			#end
			
			hxdiscord_rpc.Discord.RunCallbacks();

			// Sleep for 1 second to avoid large overload.
			Sys.sleep(1.0);
		}
	}

	public static function setState(state:cpp.ConstCharStar):Void
	{
		presence.state = state;

		updatePresence();
	}

	public static function setDetails(details:cpp.ConstCharStar):Void
	{
		presence.details = details;

		updatePresence();
	}

	public static function setTimestamps(startTimestamp:cpp.Int64, endTimestamp:cpp.Int64):Void
	{
		presence.startTimestamp = startTimestamp;

		presence.endTimestamp = endTimestamp;

		updatePresence();
	}

	public static function getLargeImageKey():cpp.ConstCharStar
	{
		return "large-image-key";
	}

	public static function setImageKeys(largeImageKey:cpp.ConstCharStar, smallImageKey:cpp.ConstCharStar):Void
	{
		if (largeImageKey == null)
			presence.largeImageKey = getLargeImageKey();

		presence.largeImageKey = largeImageKey;

		presence.smallImageKey = smallImageKey;

		updatePresence();
	}

	public static function setImageText(largeImageText:cpp.ConstCharStar, smallImageText:cpp.ConstCharStar):Void
	{
		presence.largeImageText = largeImageText;

		presence.smallImageText = smallImageText;

		updatePresence();
	}

	public static function updatePresence():Void
	{
		presence.type = DiscordActivityType_Playing;

		final button:DiscordButton = new DiscordButton();
		button.label = "Test 1";
		button.url = "https://example.com";
		presence.buttons[0] = button;

		final button:DiscordButton = new DiscordButton();
		button.label = "Test 2";
		button.url = "https://example.com";
		presence.buttons[1] = button;

		hxdiscord_rpc.Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));
	}
}
#else
// This module does not function on HashLink. We still create this simplified structure to avoid various compiler checks.
class DiscordRPC
{
    public static function init():Void {}

	public static function shutdown():Void {}

	public static function setState(state:String):Void {}

	public static function setDetails(details:String):Void {}

	// Maybe we should just be using the `Int` type here, but `haxe.Int64` also seems suitable.
	public static function setTimestamps(startTimestamp:haxe.Int64, endTimestamp:haxe.Int64):Void {}

	public static function setImageKeys(largeImageKey:String, smallImageKey:String):Void {}

	public static function setImageText(largeImageText:String, smallImageText:String):Void {}
}
#end