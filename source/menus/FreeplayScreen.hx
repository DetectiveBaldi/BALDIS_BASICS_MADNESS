package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

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

import ui.HeightenedButton;
import ui.OrientedButton;

using util.MathUtil;
using util.StringUtil;

class FreeplayScreen extends CustomState
{
    public var levels:Array<LevelData>;

    public var background:FlxSprite;

    public var scrollBg:FlxSprite;

    public var tv:FlxSprite;

    public var tvPortrait:FlxSprite;

    public var tvStatic:FlxSprite;

    public var poster:FlxSprite;

    public var clipboard:FlxSprite;

    public static var curSelected:Int = 0;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        levels = new Array<LevelData>();

        for (i in 0 ... WeekData.list.length)
        {
            var week:WeekData = WeekData.list[i];

            if (!week.showInFreeplayMenu)
                continue;

            levels = levels.concat(WeekData.list[i].levels);
        }
    
        for (i in 0 ... LevelData.list.length)
        {
            var level:LevelData = LevelData.list[i];

            if (!level.showInFreeplayMenu || level.showInMysteryMenu)
                continue;

            levels.push(level);
        }

        background = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/FreeplayScreen/background"));

        background.setGraphicSize(FlxG.width, FlxG.height);

        background.updateHitbox();

        background.clipRect = FlxRect.get(160.0, 0.0, 960.0, 720.0);

        background.screenCenter();

        add(background);

        scrollBg = new FlxSprite();

        scrollBg.visible = false;

        scrollBg.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("menus/FreeplayScreen/scroll-bg"), 
            Paths.image(Paths.xml("menus/FreeplayScreen/scroll-bg")));

        scrollBg.animation.addByPrefix("move", "move", 12.0, false);

        scrollBg.animation.onFinish.add((name:String) -> { scrollBg.visible = false; poster.visible = true; });

        scrollBg.setGraphicSize(FlxG.width, FlxG.height);

        scrollBg.updateHitbox();

        scrollBg.clipRect = FlxRect.get(160.0, 0.0, 960.0, 720.0);

        scrollBg.screenCenter();

        add(scrollBg);

        tv = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/FreeplayScreen/tv"));

        tv.active = false;

        tv.scale.set(2.25, 2.25);

        tv.updateHitbox();

        tv.x = FlxG.width - tv.width - 160.0;

        add(tv);

        tvPortrait = new FlxSprite(0.0, 0.0);

        tvPortrait.active = false;

        add(tvPortrait);

        tvStatic = new FlxSprite(0.0, 0.0);

        tvStatic.loadGraphic(AssetCache.getGraphic("menus/FreeplayScreen/tv-static"), true, 128, 128);

        tvStatic.animation.add("static", [0, 1], 18.0);

        tvStatic.animation.play("static");

        tvStatic.scale.set(2.25, 2.25);

        tvStatic.updateHitbox();

        tvStatic.centerTo(tv);

        add(tvStatic);

        poster = new FlxSprite();

        poster.active = false;

        add(poster);

        var leftButton:OrientedButton = addOrientedButton(LEFT, clickLeftButton);

        leftButton.setPosition(leftButton.getCenterX() - 225.0, leftButton.getCenterY());

        var rightButton:OrientedButton = addOrientedButton(RIGHT, clickRightButton);

        rightButton.setPosition(rightButton.getCenterX() + 225.0, rightButton.getCenterY());

        var playButton:HeightenedButton = addHeightenedButton("Play!", LARGE, clickPlayButton);

        playButton.setPosition(playButton.getCenterX(), FlxG.height - playButton.height + 35.0);

        var exitButton:HeightenedButton = addHeightenedButton("Exit", SMALL, clickExitButton);

        exitButton.onClick.remove(MainMenuScreen.fadeTune);

        exitButton.setPosition(playButton.x - exitButton.width - 30.0, FlxG.height - exitButton.height + 35.0);

        var infoButton:HeightenedButton = addHeightenedButton("Info", SMALL, clickInfoButton);

        infoButton.setPosition(playButton.x + playButton.width + 30.0, FlxG.height - infoButton.height + 35.0);

        changeSelection(0);

        MainMenuScreen.playTune();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        scrollBg.animation.timeScale = FlxG.keys.pressed.SHIFT ? 2.0 : 1.5;
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function changeSelection(change:Int):Void
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, levels.length - 1);

        var level:LevelData = levels[curSelected];

        if (change != 0.0)
        {
            scrollBg.visible = true;

            scrollBg.animation.play("move", false, change < 0.0);

            poster.visible = false;
        }

        updateTvPortrait(level);

        updatePoster(level);

        tween.cancelTweensOf(tvStatic, ["alpha"]);

        tvStatic.alpha = 1.0;

        var week:WeekData = level.week;

        if (week != null && (HighScore.getWeekScore(week.name, "normal").score != 0.0 || #if debug true #else
            !week.requiresScoreToPlay #end &&
                week.hasTvPortrait))
                    tween.tween(tvStatic, {alpha: 0.0}, 0.5);
    }

    public function updateTvPortrait(level:LevelData):Void
    {
        var portraitStr:String = "unknown";

        var week:WeekData = level.week;

        if (week != null)
        {
            if (HighScore.getWeekScore(week.name, "normal").score != 0.0 || #if debug true #else !week.requiresScoreToPlay
                #end && week.hasTvPortrait)
                    portraitStr = week.name.toLowerCase();
        }

        if (portraitStr == "unknown")
            tvPortrait.makeGraphic(1, 1, FlxColor.TRANSPARENT);
        else
            tvPortrait.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/portraits/${portraitStr}'));

        tvPortrait.scale.set(2.25, 2.25);

        tvPortrait.updateHitbox();

        tvPortrait.centerTo(tv);
    }

    public function updatePoster(level:LevelData):Void
    {
        var week:WeekData = level.week;

        var path:String = '${level.name.setCase(" ", KEBAB)}';

        if (week == null)
        {
            if (HighScore.getLevelScore(level.name, "normal").score == 0.0 #if debug && false #end)
                path = "level-score-needed";
        }
        else
        {
            if (HighScore.getWeekScore(week.name, "normal").score == 0.0 &&
                #if debug false #else week.requiresScoreToPlay #end)
                    path = "week-score-needed";
        }

        poster.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/posters/${path}'));

        poster.setGraphicSize(350.0, 350.0);

        poster.updateHitbox();

        poster.screenCenter();
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }

    public function clickLeftButton():Void
    {
        if (!scrollBg.animation.finished)
            return;

        changeSelection(-1);
    }

    public function clickRightButton():Void
    {
        if (!scrollBg.animation.finished)
            return;

        changeSelection(1);
    }

    public function addHeightenedButton(text:String, size:ButtonSize, onClick:()->Void):HeightenedButton
    {
        var button:HeightenedButton = new HeightenedButton(0.0, 0.0, text, size);

        button.onClick.add(onClick);

        add(button);

        return button;
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

    public function clickExitButton():Void
    {
        FlxG.switchState(() -> new ModeSelectScreen());
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

        openSubState(new LevelInfoScreen(levels[curSelected]));
    }
}