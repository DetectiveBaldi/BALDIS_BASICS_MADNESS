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

import extendable.ResourceState;

import game.PlayState;

using util.StringUtil;

class FreeplayScreen extends ResourceState
{
    public var levels:Array<LevelData>;

    public var background:FlxSprite;

    public var scrollBg:FlxSprite;

    public var poster:FlxSprite;

    public static var curSelected:Int = 0;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic("globals/defaultCursor").bitmap);

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

        scrollBg.animation.onFinish.add((name:String) -> { scrollBg.visible = false; poster.visible = true; updatePoster(); });

        scrollBg.scale.set(1.2, 1.2);

        scrollBg.updateHitbox();

        scrollBg.screenCenter();

        add(scrollBg);

        poster = new FlxSprite();

        add(poster);

        updatePoster();

        var leftButton:OrientedButton = addOrientedButton(LEFT, clickLeftButton);

        leftButton.setPosition((FlxG.width - leftButton.width) * 0.5 - 225.0, (FlxG.height - leftButton.height) * 0.5);

        var rightButton:OrientedButton = addOrientedButton(RIGHT, clickRightButton);

        rightButton.setPosition((FlxG.width - rightButton.width) * 0.5 + 225.0, (FlxG.height - rightButton.height) * 0.5);

        var playButton:HeightenedButton = addHeightenedButton("Play!", LARGE, clickPlayButton);

        playButton.setPosition((FlxG.width - playButton.height) * 0.5, FlxG.height - playButton.height + 35.0);

        var exitButton:HeightenedButton = addHeightenedButton("Exit", SMALL, clickExitButton);

        exitButton.onClick.remove(MainMenuScreen.fadeMusic);

        exitButton.setPosition(playButton.x - exitButton.width - 30.0, FlxG.height - exitButton.height + 35.0);

        var infoButton:HeightenedButton = addHeightenedButton("Info", SMALL, clickInfoButton);

        infoButton.setPosition(playButton.x + playButton.width + 30.0, FlxG.height - infoButton.height + 35.0);

        MainMenuScreen.playMusic();
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
        scrollBg.visible = true;
        
        scrollBg.animation.play("move", false, curSelected > change);

        poster.visible = false;

        curSelected = FlxMath.wrap(change, 0, levels.length - 1);
    }

    public function updatePoster():Void
    {
        var level:LevelData = levels[curSelected];

        poster.loadGraphic(Assets.getGraphic('menus/FreeplayScreen/posters/${level.name.setCase(KEBAB)}'));

        poster.scale.set(1.6, 1.6);

        poster.updateHitbox();

        poster.setPosition((FlxG.width - poster.width) * 0.5, 154.5);
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

        changeSelection(curSelected - 1);
    }

    public function clickRightButton():Void
    {
        if (!scrollBg.animation.finished)
            return;

        changeSelection(curSelected + 1);
    }

    public function addHeightenedButton(text:String, size:ButtonSize, onClick:()->Void):HeightenedButton
    {
        var button:HeightenedButton = new HeightenedButton(0.0, 0.0, text, size);

        button.onClick.add(MainMenuScreen.fadeMusic);

        button.onClick.add(onClick);

        add(button);

        return button;
    }

    public function clickPlayButton():Void
    {
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