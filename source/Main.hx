package;

import openfl.display.Sprite;

import flixel.FlxGame;

import flixel.util.typeLimit.NextState;

import menus.LauncherScreen;

// TODO: A lot of code sucks ass. I need to find out why and how to fix it.
class Main extends Sprite
{
	public function new():Void
	{
		super();

		addChild(new FlxGame(0, 0, () -> new InitState(getNextState()), 60, 60, true, false));
	}
	
	public function getNextState():NextState
	{
		var nextState:NextState = () -> new LauncherScreen();

		return nextState;
	}
}