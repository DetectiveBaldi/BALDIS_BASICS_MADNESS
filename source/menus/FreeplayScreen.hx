package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.Assets;
import core.Paths;

import data.LevelData;
import data.WeekData;

import extendable.CustomState;

import game.HighScore;
import game.PlayState;

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

    public static var curSelected:Int = 0;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic("shared/cursor-default").bitmap);

        levels = new Array<LevelData>();

        for (i in 0 ... WeekData.list.length)
            levels = levels.concat(WeekData.list[i].levels);
    
        for (i in 0 ... LevelData.list.length)
            levels.push(LevelData.list[i]);

        background = new FlxSprite(0.0, 0.0, Assets.getGraphic("menus/FreeplayScreen/background"));

        background.scale.set(1.2, 1.2);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        scrollBg = new FlxSprite();

        scrollBg.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic("menus/FreeplayScreen/scroll-bg"), 
            Paths.image(Paths.xml("menus/FreeplayScreen/scroll-bg")));

        scrollBg.visible = false;

        scrollBg.animation.addByPrefix("move", "move", 12.0, false);

        scrollBg.animation.onFinish.add((name:String) -> { scrollBg.visible = false; poster.visible = true; });

        scrollBg.scale.set(1.2, 1.2);

        scrollBg.updateHitbox();

        scrollBg.screenCenter();

        add(scrollBg);

        tv = new FlxSprite(0.0, 0.0, Assets.getGraphic("menus/FreeplayScreen/tv"));

        tv.active = false;

        tv.scale.set(2.25, 2.25);

        tv.updateHitbox();

        tv.x = FlxG.width - tv.width;

        add(tv);

        tvPortrait = new FlxSprite(0.0, 0.0);

        tvPortrait.active = false;

        add(tvPortrait);

        tvStatic = new FlxSprite(0.0, 0.0);

        tvStatic.loadGraphic(Assets.getGraphic("menus/FreeplayScreen/tv-static"), true, 128, 128);

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

        if (week != null && HighScore.getWeekScore(week.name, "normal") != 0.0)
            tween.tween(tvStatic, {alpha: 0.0}, 0.5);
    }

    public function updateTvPortrait(level:LevelData):Void
    {
        var path:String = "unknown";

        var week:WeekData = level.week;

        if (week != null)
        {
            if (HighScore.getWeekScore(week.name, "normal") != 0.0)
                path = week.name.toLowerCase();
        }

        tvPortrait.loadGraphic(Assets.getGraphic('menus/FreeplayScreen/portraits/${path}'));

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
            if (HighScore.getLevelScore(level.name, "normal") == 0.0)
                path = "level-score-needed";
        }
        else
        {
            if (HighScore.getWeekScore(week.name, "normal") == 0.0)
                path = "week-score-needed";
        }

        poster.loadGraphic(Assets.getGraphic('menus/FreeplayScreen/posters/${path}'));

        poster.scale.set(1.6, 1.6);

        poster.updateHitbox();

        poster.setPosition(poster.getCenterX(), 154.5);
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

        if (week == null)
        {
            if (HighScore.getLevelScore(level.name, "normal") == 0.0)
                return;
        }
        else
        {
            if (HighScore.getWeekScore(week.name, "normal") == 0.0)
                return;
        }

        MainMenuScreen.fadeTune();

        PlayState.loadSingle(levels[curSelected]);
    }

    public function clickExitButton():Void
    {
        FlxG.switchState(() -> new ModeSelectScreen());
    }

    public function clickInfoButton():Void
    {

    }
}

class OrientedButton extends FlxSprite
{
    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, orientation:ButtonOrientation):Void
    {
        super(x, y);

        loadGraphic(Assets.getGraphic("menus/FreeplayScreen/OrientedButton/sheet"), true, 32, 32);

        animation.add("deselect", orientation ? [0] : [1], 0.0, false);

        animation.add("select", orientation ? [2] : [3], 0.0, false);

        animation.play("deselect");

        scale.set(3.0, 3.0);

        updateHitbox();

        onClick = new FlxSignal();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            animation.play("select");

            if (FlxG.mouse.justReleased)
                onClick.dispatch();
        }
        else
            animation.play("deselect");
    }

    override function destroy():Void
    {
        super.destroy();

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}

class HeightenedButton extends FlxSpriteGroup
{
    public var base:FlxSprite;

    public var label:FlxText;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, text:String, size:ButtonSize):Void
    {
        super(x, y);

        base = new FlxSprite();

        base.loadGraphic(Assets.getGraphic("menus/FreeplayScreen/HeightenedButton/base"), true, 128, 128);

        base.active = false;

        base.animation.add("up", [0], 0.0, false);

        base.animation.add("down", [1], 0.0, false);

        base.animation.play("up");

        base.scale.set(size ? 2.0 : 1.75, size ? 2.0 : 1.75);

        base.updateHitbox();

        add(base);

        label = new FlxText(0.0, 0.0, base.width, text);

        label.color = FlxColor.BLACK;

        label.font = Paths.font(Paths.ttf("Comic Sans MS"));

        label.size = size ? 28 : 24;

        label.alignment = CENTER;

        label.textField.antiAliasType = ADVANCED;

        label.textField.sharpness = 400.0;

        label.setPosition(base.getMidpoint().x - label.width * 0.5, size == LARGE ? 45.0 : 35.0);

        add(label);

        onClick = new FlxSignal();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            if (FlxG.mouse.pressed)
                base.animation.play("down");
            else
                base.animation.play("up");

            if (FlxG.mouse.justReleased)
                onClick.dispatch();
        }
        else
            base.animation.play("up");
    }

    override function destroy():Void
    {
        super.destroy();

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}

enum abstract ButtonOrientation(Bool) from Bool to Bool
{
    var LEFT:Bool = true;

    var RIGHT:Bool = false;
}

enum abstract ButtonSize(Bool) from Bool to Bool
{
    var LARGE:Bool = true;

    var SMALL:Bool = false;
}