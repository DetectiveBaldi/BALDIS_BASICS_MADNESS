package api;

#if cpp
class DiscordRPC
{
    public static final DISCORD_ID:String = "0";

	public static var userData:DiscordUserData;

    public static function init():Void
    {
        final handlers:hxdiscord_rpc.Types.DiscordEventHandlers = new hxdiscord_rpc.Types.DiscordEventHandlers();

		handlers.ready = cpp.Function.fromStaticFunction(onReady);

		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnect);

		handlers.errored = cpp.Function.fromStaticFunction(onError);

        hxdiscord_rpc.Discord.Initialize(DISCORD_ID, cpp.RawPointer.addressOf(handlers), false, null);

        sys.thread.Thread.create(() ->
		{
			while (true)
			{
				#if DISCORD_DISABLE_IO_THREAD
				hxdiscord_rpc.Discord.UpdateConnection();
				#end

				hxdiscord_rpc.Discord.RunCallbacks();

				Sys.sleep(2.0);
			}
		});
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

    public static function shutdown():Void
    {
        hxdiscord_rpc.Discord.Shutdown();
    }
}

typedef DiscordUserData =
{
	public var id:cpp.ConstCharStar;

	public var username:cpp.ConstCharStar;

	public var avatar:cpp.ConstCharStar;
}
#else
class DiscordRPC
{
	public static final DISCORD_ID:String = "0";

	public static var userData:DiscordUserData;
	
    public static function init():Void {}

    public static function shutdown():Void {}
}

typedef DiscordUserData =
{
	public var id:String;

	public var username:String;

	public var avatar:String;
}
#end