package;

import haxe.ui.Toolkit;

import haxe.ui.focus.FocusManager;

import haxe.ui.themes.Theme;

import flixel.FlxG;
import flixel.FlxState;

import flixel.util.typeLimit.NextState;

import core.Assets;
import core.Options;

import data.WeekData;

import ui.PerfStats;

class InitState extends FlxState
{
    public var nextState:NextState;

    public static var perfStats:PerfStats;

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

        FlxG.updateFramerate = Options.frameRate;

        FlxG.drawFramerate = Options.frameRate;

        FlxG.mouse.visible = false;

        FlxG.console.registerClass(InitState);
        
        FlxG.console.registerClass(Options);

        FlxG.plugins.drawOnTop = true;

        Assets.init();

        FlxG.autoPause = Options.autoPause;

        FlxG.console.autoPause = Options.autoPause;

        WeekData.reloadWeeksList();

        perfStats = new PerfStats(10.0, 5.0);
        
        FlxG.game.addChildAt(perfStats, FlxG.game.getChildIndex(@:privateAccess FlxG.game._inputContainer) + 1);

        FlxG.switchState(nextState);
    }
}