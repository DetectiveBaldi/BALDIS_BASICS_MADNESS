package api;

#if cpp
class DiscordRPC
{
    public static final DISCORD_ID:String = "0";

	public static var userData:DiscordUserData;

	public static var presence:hxdiscord_rpc.Types.DiscordRichPresence;

    public static function init():Void
    {
        final handlers:hxdiscord_rpc.Types.DiscordEventHandlers = new hxdiscord_rpc.Types.DiscordEventHandlers();

		handlers.ready = cpp.Function.fromStaticFunction(onReady);

		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnect);

		handlers.errored = cpp.Function.fromStaticFunction(onError);

        hxdiscord_rpc.Discord.Initialize(DISCORD_ID, cpp.RawPointer.addressOf(handlers), false, null);

        sys.thread.Thread.create(processConnection);

		presence = new hxdiscord_rpc.Types.DiscordRichPresence();
    }

	public static function shutdown():Void
    {
        hxdiscord_rpc.Discord.Shutdown();
    }

    public static function onReady(request:cpp.RawConstPointer<hxdiscord_rpc.Types.DiscordUser>):Void
	{
		var user:hxdiscord_rpc.Types.DiscordUser = request[0];

		userData = {id: user.userId, username: user.username, avatar: user.avatar}
	}

	public static function onDisconnect(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		userData = null;
	}

	public static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		userData = null;
	}

	// The define `DISCORD_DISABLE_IO_THREAD` causes unexplainable failures, so we can't use it here.
	public static function processConnection():Void
	{
		while (true)
		{
			hxdiscord_rpc.Discord.RunCallbacks();

			Sys.sleep(2.0);
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

	public static function setImageKeys(largeImageKey:cpp.ConstCharStar, smallImageKey:cpp.ConstCharStar):Void
	{
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
		hxdiscord_rpc.Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));
	}
}

typedef DiscordUserData =
{
	public var id:cpp.ConstCharStar;

	public var username:cpp.ConstCharStar;

	public var avatar:cpp.ConstCharStar;
}
#else
// This module does not function on HashLink. We still create a helpful little structures to avoid various compiler checks.
class DiscordRPC
{
	public static final DISCORD_ID:String = "0";

	public static var userData:DiscordUserData;
	
    public static function init():Void {}

    public static function shutdown():Void {}

	public static function processConnection():Void {}

	public static function setState(state:String):Void {}

	public static function setDetails(details:String):Void {}

	// Maybe we should just be using the `Int` type here, but `haxe.Int64` also seems suitable.
	public static function setTimestamps(startTimestamp:haxe.Int64, endTimestamp:haxe.Int64):Void {}

	public static function setImageKeys(largeImageKey:String, smallImageKey:String):Void {}

	public static function setImageText(largeImageText:String, smallImageText:String):Void {}

	public static function updatePresence():Void {}
}

typedef DiscordUserData =
{
	public var id:String;

	public var username:String;

	public var avatar:String;
}
#end