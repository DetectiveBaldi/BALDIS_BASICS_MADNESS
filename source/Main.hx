package;

import openfl.display.Sprite;

import flixel.FlxGame;

import menus.LauncherScreen;

class Main extends Sprite
{
	public function new():Void
	{
		super();

		addChild(new FlxGame(0, 0, () -> new InitState(() -> new LauncherScreen()), 60, 60, true, false));
	}
}