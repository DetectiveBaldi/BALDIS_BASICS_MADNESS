package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;
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

    public var curSelected:Int;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic(Paths.image(Paths.png("globals/defaultCursor"))).bitmap);

        levels = new Array<LevelData>();

        for (i in 0 ... WeekData.list.length)
            levels = levels.concat(WeekData.list[i].levels);

        background = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("menus/FreeplayScreen/background"))));

        background.scale.set(1.2, 1.2);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        scrollBg = new FlxSprite();

        scrollBg.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.image(Paths.png("menus/FreeplayScreen/scroll-bg"))), 
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

        curSelected = 0;

        updatePoster();

        var playButton:ElevatorButton = addButton("Play!", clickPlayButton);

        playButton.onClick.remove(MainMenuScreen.fadeMusic);

        playButton.setPosition((FlxG.width - playButton.height) * 0.5, FlxG.height - playButton.height + 35.0);

        var exitButton:ElevatorButton = addButton("Exit", clickExitButton);

        exitButton.onClick.remove(MainMenuScreen.fadeMusic);

        exitButton.setPosition(playButton.x - exitButton.width - 15.0, FlxG.height - exitButton.height + 35.0);

        var infoButton:ElevatorButton = addButton("Info", clickInfoButton);

        infoButton.setPosition(playButton.x + exitButton.width + 15.0, FlxG.height - infoButton.height + 35.0);

        MainMenuScreen.playMusic();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        scrollBg.animation.timeScale = FlxG.keys.pressed.SHIFT ? 2.0 : 1.0;

        if (scrollBg.animation.finished)
        {
            if (FlxG.keys.justPressed.LEFT)
                changeSelection(curSelected - 1);

            if (FlxG.keys.justPressed.RIGHT)
                changeSelection(curSelected + 1);

            if (FlxG.keys.justPressed.HOME)
                changeSelection(0);

            if (FlxG.keys.justPressed.END)
                changeSelection(levels.length - 1);
        }
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function changeSelection(change:Int):Void
    {
        if (curSelected != change)
        {
            scrollBg.visible = true;
            
            scrollBg.animation.play("move", false, curSelected > change);

            poster.visible = false;

            curSelected = FlxMath.wrap(change, 0, levels.length - 1);
        }
    }

    public function updatePoster():Void
    {
        var level:LevelData = levels[curSelected];

        poster.loadGraphic(Assets.getGraphic(Paths.image(Paths.png('menus/FreeplayScreen/posters/${level.name.setCase(KEBAB)}'))));

        poster.scale.set(1.6, 1.6);

        poster.updateHitbox();

        poster.setPosition((FlxG.width - poster.width) * 0.5, 154.5);
    }

    public function addButton(text:String, onClick:()->Void):ElevatorButton
    {
        var button:ElevatorButton = new ElevatorButton(0.0, 0.0, text);

        button.onClick.add(MainMenuScreen.fadeMusic);

        button.onClick.add(onClick);

        add(button);

        return button;
    }

    public function clickPlayButton():Void
    {
        if (!scrollBg.animation.finished)
            return;

        var level:LevelData = levels[curSelected];

        var week:WeekData = level.week;

        PlayState.loadWeek(week, week.getLevelIndex(level), false);
    }

    public function clickExitButton():Void
    {
        if (!scrollBg.animation.finished)
            return;

        FlxG.switchState(() -> new ModeSelectScreen());
    }

    public function clickInfoButton():Void
    {
        if (!scrollBg.animation.finished)
            return;
    }
}

class ElevatorButton extends FlxSpriteGroup
{
    public var base:FlxSprite;

    public var label:FlxText;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, text:String):Void
    {
        super(x, y);

        onClick = new FlxSignal();

        base = new FlxSprite();

        base.loadGraphic(Assets.getGraphic(Paths.image(Paths.png("menus/FreeplayScreen/ElevatorButton/base"))), true, 128, 128);

        base.animation.add("up", [0], 0.0, false);

        base.animation.add("down", [1], 0.0, false);

        base.animation.play("up");

        base.scale.set(2.0, 2.0);

        base.updateHitbox();

        add(base);

        label = new FlxText(0.0, 0.0, base.width, text);

        label.color = FlxColor.BLACK;

        label.font = Paths.font(Paths.ttf("Comic Sans MS"));

        label.size = 28;

        label.alignment = CENTER;

        label.textField.antiAliasType = ADVANCED;

        label.textField.sharpness = 400.0;

        label.setPosition(base.getMidpoint().x - label.width * 0.5, 40.0);

        add(label);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            if (FlxG.mouse.justReleased)
                onClick.dispatch();

            if (FlxG.mouse.pressed)
                base.animation.play("down");
            else
                base.animation.play("up");
        }
        else
            base.animation.play("up");
    }
}