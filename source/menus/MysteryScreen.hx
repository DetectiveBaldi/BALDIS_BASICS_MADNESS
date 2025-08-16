package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.AssetCache;
import core.Paths;

import data.LevelData;
import data.PlayStats;
import data.WeekData;

import extendable.CustomState;

import game.HighScore;
import game.PlayState;
import menus.FreeplayScreen.InfoButtonSubState;

import ui.HeightenedButton;
import ui.OrientedButton;

using util.MathUtil;
using util.StringUtil;

class MysteryScreen extends CustomState
{
    public var level:LevelData;

    public var levels:Array<LevelData>;

    public var exitButton:FlxSprite;

    public var startButton:FlxSprite;

    public var songText:FlxText;

    public var infoText:FlxText;

    public var door:FlxSprite;

    public var tune:FlxSound;

    public static var curSelected:Int = 0;

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        levels = new Array<LevelData>();

        for (i in 0 ... WeekData.list.length)
        {
            var week:WeekData = WeekData.list[i];

            if (week.showInFreeplayMenu)
                continue;

            levels = levels.concat(WeekData.list[i].levels);
        }
    
        for (i in 0 ... LevelData.list.length)
        {
            var level:LevelData = LevelData.list[i];

            if (level.showInFreeplayMenu)
                continue;

            levels.push(level);
        }

        exitButton = new FlxSprite();

        exitButton.loadGraphic(AssetCache.getGraphic("menus/MainMenuScreen/exitButton"), true, 32, 32);

        exitButton.animation.add("0", [0], 0.0, false);

        exitButton.animation.add("1", [1], 0.0, false);

        exitButton.animation.play("0");

        exitButton.scale.set(2.0, 2.0);

        exitButton.updateHitbox();

        exitButton.setPosition(165.0, 5.0);

        add(exitButton);

        door = new FlxSprite();

        door.loadGraphic(AssetCache.getGraphic("menus/MysteryScreen/door-idle"), true, 256, 225);

        door.scale.set(1.5, 1.5);

        door.updateHitbox();

        door.screenCenter();

        add(door);

        songText = new FlxText(0.0, 0.0, FlxG.width);

        songText.color = FlxColor.BLACK;

        songText.size = 28;

        songText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        songText.alignment = CENTER;

        songText.setPosition(0.0, 270.0);

        songText.textField.antiAliasType = ADVANCED;

        songText.textField.sharpness = 400.0;

        add(songText);

        startButton = new FlxSprite();

        startButton.loadGraphic(AssetCache.getGraphic("menus/StoryMenuScreen/start-button"), true, 256, 128);

        startButton.animation.add("deselect", [0], 0.0, false);

        startButton.animation.add("select", [1], 0.0, false);

        startButton.scale.set(1.25, 1.25);

        startButton.updateHitbox();

        startButton.setPosition(door.getMidpoint().x - startButton.width * 0.5, startButton.getCenterY() + 300.0);

        add(startButton);

        infoText = new FlxText(0.0, 0.0, FlxG.width);

        infoText.color = FlxColor.WHITE;

        infoText.size = 60;

        infoText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        infoText.alignment = RIGHT;

        infoText.setPosition(100.0, 270.0);

        infoText.textField.antiAliasType = ADVANCED;

        infoText.textField.sharpness = 400.0;

        infoText.visible = true;

        add(infoText);

        var leftButton:OrientedButton = addOrientedButton(LEFT, clickLeftButton);

        leftButton.setPosition(leftButton.getCenterX() - 150.0, leftButton.getCenterY());

        var rightButton:OrientedButton = addOrientedButton(RIGHT, clickRightButton);

        rightButton.setPosition(rightButton.getCenterX() + 150.0, rightButton.getCenterY());

        changeSelection(0);

        tune = FlxG.sound.load(AssetCache.getMusic("menus/MysteryScreen/mystery"), 1.0, true);

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("1");

            if (FlxG.mouse.justReleased)
                FlxG.switchState(() -> new MainMenuScreen());
        }
        else
            exitButton.animation.play("0");

        if (FlxG.mouse.overlaps(startButton, camera))
        {
            startButton.animation.play("select");

            if (FlxG.mouse.justReleased)
            {
                var level:LevelData = levels[curSelected];

                var week:WeekData = level.week;
        
                if (week != null)
                {
                    if (HighScore.getWeekScore(week.name, "normal").score == 0.0 &&
                        #if debug false #else week.requiresScoreToPlay #end)
                            return;
                }

                MainMenuScreen.fadeTune();

                PlayState.loadLevel(levels[curSelected]);
            }
        }
        else
            startButton.animation.play("deselect");
        
        if (FlxG.mouse.overlaps(infoText, camera))
        {
            infoText.color = 0xFF00DC00;
            
            infoText.underline = true;

            if (FlxG.mouse.justReleased)
                clickInfoButton();
        }
        else
        {
            infoText.color = FlxColor.WHITE;

            infoText.underline = false;
        }
    }


    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function clickPlayButton():Void
    {
        var level:LevelData = levels[curSelected];

        var week:WeekData = level.week;
        
        if (week != null)
        {
            if (HighScore.getWeekScore(week.name, "normal").score == 0.0 &&
                #if debug false #else week.requiresScoreToPlay #end)
                    return;
        }

        MainMenuScreen.fadeTune();

        PlayState.loadLevel(levels[curSelected]);
    }

    public function clickLeftButton():Void
    {
        changeSelection(-1);
    }

    public function clickRightButton():Void
    {
        changeSelection(1);
    }

    public function clickInfoButton():Void
    {
        var level:LevelData = levels[curSelected];

        var week:WeekData = level.week;

        if (week == null)
        {
            if (#if debug false && #end HighScore.getLevelScore(level.name, "normal").score == 0.0)
                return;
        }
        else
        {
            if (HighScore.getWeekScore(week.name, "normal").score == 0.0 &&
                #if debug false #else week.requiresScoreToPlay #end)
                    return;
        }

        openSubState(new InfoButtonSubState(levels[curSelected]));
    }

    public function changeSelection(change:Int):Void
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, levels.length - 1);

        var level:LevelData = levels[curSelected];

        updateText(level);

        var week:WeekData = level.week;
    }

    public function updateText(level:LevelData):Void
    {
        var week:WeekData = level.week;

        var path:String = '${level.name.setCase(" ", KEBAB)}';

        songText.text = '${level.name}';
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }
}