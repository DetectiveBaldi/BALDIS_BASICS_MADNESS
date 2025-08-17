package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxGroup.FlxTypedGroup;

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

using flixel.util.FlxColorTransformUtil;

using util.MathUtil;
using util.StringUtil;

class MysteryScreen extends CustomState
{
    public var level:LevelData;

    public var levels:Array<LevelData>;

    public var questionMarks:FlxTypedGroup<FlxSprite>;

    public var exitButton:FlxSprite;

    public var startButton:FlxSprite;

    public var songText:FlxText;

    public var infoText:FlxText;

    public var door:FlxSprite;

    public var tune:FlxSound;

    public var mark:FlxSprite;

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

        questionMarks = new FlxTypedGroup<FlxSprite>();

        add(questionMarks);

        for (i in 0 ... 16)
            spawnQuestionMark();

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

        door.scale.set(1.75, 1.75);

        door.updateHitbox();

        door.screenCenter();

        add(door);

        songText = new FlxText(0.0, 0.0, door.width);

        songText.color = FlxColor.BLACK;

        songText.size = 28;

        songText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        songText.alignment = CENTER;

        songText.textField.antiAliasType = ADVANCED;

        songText.textField.sharpness = 400.0;

        songText.setPosition(door.getCenterX(), 255.0);

        add(songText);

        startButton = new FlxSprite();

        startButton.loadGraphic(AssetCache.getGraphic("menus/StoryMenuScreen/start-button"), true, 256, 128);

        startButton.animation.add("deselect", [0], 0.0, false);

        startButton.animation.add("select", [1], 0.0, false);

        startButton.scale.set(1.25, 1.25);

        startButton.updateHitbox();

        startButton.setPosition(door.getMidpoint().x - startButton.width * 0.5, startButton.getCenterY() + 275.0);

        add(startButton);

        infoText = new FlxText(0.0, 0.0, 0.0, "Info");

        infoText.color = FlxColor.WHITE;

        infoText.size = 32;

        infoText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        infoText.alignment = CENTER;

        infoText.textField.antiAliasType = ADVANCED;

        infoText.textField.sharpness = 400.0;

        infoText.setPosition(FlxG.width - infoText.width - 165.0, infoText.getCenterY(exitButton) - 15.0);

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

        for (i in 0 ... questionMarks.members.length)
        {
            var mark:FlxSprite = questionMarks.members[i];

            var left:Float = InitState.mouseRectPlugin.left;

            var right:Float = InitState.mouseRectPlugin.right;

            var top:Float = InitState.mouseRectPlugin.top;

            var bottom:Float = InitState.mouseRectPlugin.bottom;

            if (mark.x <= left || mark.x + mark.width >= right)
            {
                mark.velocity.x *= -1;

                var direction:Int = 1;

                if (FlxG.random.bool())
                    direction *= -1;

                mark.velocity.x += FlxG.random.int(0, 5) * direction;

                // Hopefully fixes issue where question marks get stuck on an edge?
                if (mark.x <= left)
                    mark.x = left + 1;
                else
                    mark.x = right - mark.width - 1.0;
            }

            if (mark.y <= top || mark.y + mark.height >= bottom)
            {
                mark.velocity.y *= -1;

                var direction:Int = 1;

                if (FlxG.random.bool())
                    direction *= -1;

                mark.velocity.y += FlxG.random.int(0, 5) * direction;

                // Hopefully fixes issue where question marks get stuck on an edge?
                if (mark.y <= top)
                    mark.y = top + 1;
                else
                    mark.y = bottom - mark.height - 1.0;
            }
        }

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("1");

            if (FlxG.mouse.justReleased)
                FlxG.switchState(() -> new ModeSelectScreen());
        }
        else
            exitButton.animation.play("0");

        if (FlxG.mouse.overlaps(startButton, camera))
        {
            startButton.animation.play("select");

            if (FlxG.mouse.justReleased)
                clickStartButton();
        }
        else
            startButton.animation.play("deselect");
        
        if (FlxG.mouse.overlaps(infoText, camera))
        {
            infoText.color = 0xFF00FF00;
            
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

    public function spawnQuestionMark():Void
    {
        mark = new FlxSprite();

        mark.loadGraphic(AssetCache.getGraphic('menus/MysteryScreen/questionMarks/qMark${FlxG.random.int(0, 7)}'), true, 32, 32);

        mark.scale.set(2.0, 2.0);

        mark.updateHitbox();

        var direction:Int = 1;

        if (FlxG.random.bool())
            direction = -1;

        mark.velocity.set(FlxG.random.float(50.0, 75.0) * direction, FlxG.random.float(25.0, 50.0) * direction);

        var left:Float = InitState.mouseRectPlugin.left;

        var right:Float = InitState.mouseRectPlugin.right;

        var top:Float = InitState.mouseRectPlugin.top;

        var bottom:Float = InitState.mouseRectPlugin.bottom;

        mark.setPosition(FlxG.random.float(left, right - mark.width),
            FlxG.random.float(top, bottom - mark.height));

        while (mark.overlaps(questionMarks))
            mark.setPosition(FlxG.random.float(left, right - mark.width),
                FlxG.random.float(top, bottom - mark.height));

        mark.color = mark.color.getDarkened(FlxG.random.float(0.4, 0.8));

        questionMarks.add(mark);
    }

    public function clickStartButton():Void
    {
        var level:LevelData = levels[curSelected];

        #if !debug
        if (HighScore.getLevelScore(level.name, "normal").score == 0.0)
            return;
        #end

        PlayState.loadLevel(levels[curSelected], () -> new MysteryScreen());
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

        if (#if debug false && #end HighScore.getLevelScore(level.name, "normal").score == 0.0)
            return;

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
        var name:String = level.name;

        #if !debug
        if (HighScore.getLevelScore(name, "normal").score == 0.0)
        {
            songText.text = "";

            return;
        }
        #end

        songText.text = '${name}';
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }
}