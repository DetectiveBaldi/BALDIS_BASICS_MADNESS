package;

import haxe.ui.Toolkit;

import haxe.ui.focus.FocusManager;

import haxe.ui.themes.Theme;

import flixel.FlxG;
import flixel.FlxState;

import flixel.util.typeLimit.NextState;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.Playlist;

import game.HighScore;

import plugins.MouseRectPlugin;

import util.ClickSoundUtil;

class InitState extends FlxState
{
    public var nextState:NextState;

    public static var mouseRectPlugin:MouseRectPlugin;

    public function new(_nextState:NextState):Void
    {
        super();

        nextState = _nextState;
    }

    override function create():Void
    {
        super.create();

        Toolkit.init();

        Toolkit.theme = Theme.DARK;

        FocusManager.instance.autoFocus = false;

        FlxG.fixedTimestep = false;

        Options.init();

        Options.purgeInvalid();

        setAutoPause(Options.autoPause);

        setFrameRateCap(Options.frameRate);

        FlxG.mouse.visible = false;

        FlxG.console.registerClass(InitState);
        
        FlxG.console.registerClass(Options);

        FlxG.console.registerClass(HighScore);

        FlxG.plugins.drawOnTop = true;

        AssetCache.init();

        Paths.init();

        Playlist.init();

        HighScore.init();

        HighScore.purgeInvalid();

        mouseRectPlugin = new MouseRectPlugin();

        FlxG.plugins.addPlugin(mouseRectPlugin);

        ClickSoundUtil.init();

        FlxG.switchState(nextState);
    }

    public static function setAutoPause(autoPause:Bool):Void
    {
        FlxG.autoPause = autoPause;

        FlxG.console.autoPause = autoPause;
    }

    public static function setFrameRateCap(frameRate:Int):Void
    {
        if (frameRate > FlxG.updateFramerate)
        {
            FlxG.updateFramerate = frameRate;

            FlxG.drawFramerate = frameRate;
        }
        else
        {
            FlxG.drawFramerate = frameRate;

            FlxG.updateFramerate = frameRate;
        }
    }

    public static function setMouseRect(left:Float = 0.0, right:Float = 0.0, top:Float = 0.0, bottom:Float = 0.0):Void
    {
        mouseRectPlugin.setMouseRect(left, right, top, bottom);
    }
}