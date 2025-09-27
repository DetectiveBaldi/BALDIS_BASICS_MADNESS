package game;

import openfl.display.Bitmap;

import openfl.geom.Rectangle;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.Difficulty;
import data.LevelData;
import data.WeekData;

import extendable.TransitionSubState;

import interfaces.ISequenceHandler;

import game.PlayState;

import menus.FreeplayScreen;
import menus.MysteryScreen;
import menus.StoryMenuScreen;
import menus.options.OptionsMenu;

import plugins.MouseRectPlugin;

import ui.BaldiHeads;

import util.ClickSoundUtil;

using util.ArrayUtil;
using util.MathUtil;

class PauseScreen extends TransitionSubState implements ISequenceHandler
{
    public var game:PlayState;

    public var lastMouseVisible:Bool;

    public var lastMouseCursor:Bitmap;

    public var lastMouseRect:FlxRect;

    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;

    public var pauseIcons:FlxTypedGroup<PauseScreenIcon>;

    public var resumeIcon:PauseScreenIcon;

    public var restartIcon:PauseScreenIcon;

    public var optionsIcon:PauseScreenIcon;

    public var quitIcon:PauseScreenIcon;

    public var selectedIcon:PauseScreenIcon;

    public var tune:FlxSound;

    public function new(_game:PlayState):Void
    {
        super(FlxColor.WHITE);

        game = _game;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.last();

        lastMouseVisible = FlxG.mouse.visible;

        lastMouseCursor = FlxG.mouse.cursor;

        var mouseRectPlugin:MouseRectPlugin = InitState.mouseRectPlugin;

        lastMouseRect = FlxRect.get(mouseRectPlugin.left, mouseRectPlugin.top, mouseRectPlugin.right, mouseRectPlugin.bottom);

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        FlxG.mouse.visible = true;

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        tweens = new FlxTweenManager();

        add(tweens);

        timers = new FlxTimerManager();

        add(timers);

        var baldi:BaldiHeads = new BaldiHeads();

        baldi.screenCenter();

        add(baldi);

        var chalkboard:FlxSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/chalkboard-arrows"));

        chalkboard.active = false;

        chalkboard.scale.set(2.5, 2.5);

        chalkboard.updateHitbox();

        chalkboard.screenCenter();
        
        add(chalkboard);

        var pausedText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "PAUSE");

        pausedText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        pausedText.size = 48;

        pausedText.alignment = CENTER;

        pausedText.textField.antiAliasType = ADVANCED;

        pausedText.textField.sharpness = 400.0;

        pausedText.setPosition(pausedText.getCenterX(), pausedText.getCenterY() - 265.0);

        add(pausedText);

        var nameText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "");

        nameText.alpha = 0.5;

        nameText.text = game.chart.name;

        nameText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        nameText.size = 42;

        nameText.alignment = CENTER;

        nameText.textField.antiAliasType = ADVANCED;

        nameText.textField.sharpness = 400.0;

        nameText.setPosition(nameText.getCenterX(), nameText.getCenterY() + 265.0);

        add(nameText);

        pauseIcons = new FlxTypedGroup<PauseScreenIcon>();

        add(pauseIcons);

        resumeIcon = createIcon("resumeIcon");

        resumeIcon.setPosition(380.0, 120.0);

        restartIcon = createIcon("restartIcon");

        restartIcon.setPosition(FlxG.width - restartIcon.width - 380.0, 120.0);

        optionsIcon = createIcon("optionsIcon");

        optionsIcon.setPosition(380.0, FlxG.height - optionsIcon.height - 120.0);

        quitIcon = createIcon("quitIcon");

        quitIcon.setPosition(FlxG.width - quitIcon.width - 380.0, FlxG.height - quitIcon.height - 120.0);

        var foreground:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

        foreground.active = false;

        var rectToFill:Rectangle = new Rectangle(0.0, 0.0, 160.0, FlxG.height);

        foreground.pixels.fillRect(rectToFill, 0xFF000000);

        rectToFill.setTo(FlxG.width - 160.0, 0.0, 160.0, FlxG.height);

        foreground.pixels.fillRect(rectToFill, 0xFF000000);

        foreground.centerTo();

        add(foreground);

        tune = FlxG.sound.load(AssetCache.getMusic("game/PauseScreen/tune"), 1.0, true);

        tune.volume = 0.0;

        tune.fadeIn(1.0, 0.0, 0.5);

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(pauseIcons, camera))
        {
            for (icon in pauseIcons)
            {
                if (FlxG.mouse.justReleased && FlxG.mouse.overlaps(icon, camera))
                {
                    selectedIcon = icon;

                    ClickSoundUtil.play();

                    close();
                }
            }
        }

        if (FlxG.keys.anyJustPressed(Options.controls["UI:PAUSE"]))
        {
            selectedIcon = resumeIcon;
            
            close();
        }
    }

    override function close():Void
    {
        TransitionSubState.cancelFadeOut = true;

        super.close();

        FlxG.mouse.visible = lastMouseVisible;

        FlxG.mouse.load(lastMouseCursor.bitmapData);

        InitState.setMouseRect(lastMouseRect.left, lastMouseRect.right, lastMouseRect.top, lastMouseRect.bottom);

        if (selectedIcon == resumeIcon)
        {
            game.resume();

            tune.stop();
        }
        else
        {
            if (selectedIcon == restartIcon)
                FlxG.resetState();

            if (selectedIcon == optionsIcon)
                FlxG.switchState(() -> new OptionsMenu(() -> PlayState.getClassFromLevel()));

            if (selectedIcon == quitIcon)
            {
                var nextState:NextState = game.params?.nextState;

                if (PlayState.isWeek)
                {
                    var weeks:Array<WeekData> = WeekData.list;

                    var weekToSearch:WeekData = weeks.first((w:WeekData) -> w.name == PlayState.week.name);

                    StoryMenuScreen.selectedDifficulty = Difficulty.list.indexOf(PlayState.level.difficulty);

                    StoryMenuScreen.selectedWeek = weeks.indexOf(weekToSearch);
                }
                else
                {
                    var level:LevelData = PlayState.level;

                    if (level.obscurity == NONE)
                        nextState ??= () -> new FreeplayScreen();
                    else
                    {
                        nextState ??= () -> new MysteryScreen();

                        var filtered:Array<LevelData> = LevelData.list.filter((lv:LevelData) -> lv.obscurity != NONE);

                        MysteryScreen.curSelected = filtered.indexOf(level);
                    }
                }

                FlxG.switchState(nextState);
            }

            tune.fadeOut(0.5, 0.0, (_tween:FlxTween) -> tune.stop());
        }
    }

    public function createIcon(file:String):PauseScreenIcon
    {
        var icon:PauseScreenIcon = new PauseScreenIcon(file);

        icon.camera = camera;

        pauseIcons.add(icon);

        return icon;
    }
}

class PauseScreenIcon extends FlxSprite
{
    public function new(x:Float = 0.0, y:Float = 0.0, file:String):Void
    {
        super(x, y, AssetCache.getGraphic('game/PauseScreen/${file}'));

        scale.set(1.25, 1.25);

        updateHitbox();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            scale.x = FlxMath.lerp(scale.x, 1.5, FlxMath.getElapsedLerp(0.15, elapsed));

            scale.y = FlxMath.lerp(scale.y, 1.5, FlxMath.getElapsedLerp(0.15, elapsed));
        }
        else
        {
            scale.x = FlxMath.lerp(scale.x, 1.25, FlxMath.getElapsedLerp(0.15, elapsed));

            scale.y = FlxMath.lerp(scale.y, 1.25, FlxMath.getElapsedLerp(0.15, elapsed));
        }
    }
}