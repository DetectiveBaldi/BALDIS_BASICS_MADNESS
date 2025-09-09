package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.effects.FlxFlicker;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

import core.AssetCache;
import core.Paths;

import data.LevelData;
import data.PlayStats;
import data.WeekData;

import extendable.CustomState;
import extendable.CustomSubState;

import game.HighScore;
import game.PlayState;

import ui.BackOutButton;
import ui.HeightenedButton;
import ui.OrientedButton;
import ui.MenuText;

import util.ClickSoundUtil;

using flixel.util.FlxColorTransformUtil;

using util.MathUtil;
using util.StringUtil;

// TODO: Maybe adjust naming and general code clean-up.
class MysteryScreen extends CustomState
{
    public var levels:Array<LevelData>;

    public var hasScore:Bool;

    public var questionMarks:FlxTypedGroup<FlxSprite>;

    public var door:FlxSprite;

    public var lock:FlxSprite;

    public var nameText:FlxText;

    public var needHintText:MenuText;

    public var hintTimer:Float;

    public var startButton:FlxSprite;    

    public var infoText:MenuText;

    public var leftButton:OrientedButton;

    public var rightButton:OrientedButton;

    public var backOutButton:BackOutButton;

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
    
        for (i in 0 ... LevelData.list.length)
        {
            var level:LevelData = LevelData.list[i];

            if (!level.showInMysteryMenu)
                continue;

            levels.push(level);
        }

        questionMarks = new FlxTypedGroup<FlxSprite>();

        add(questionMarks);

        for (i in 0 ... 16)
            spawnQuestionMark();

        door = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/MysteryScreen/door-idle"));

        door.active = false;

        door.scale.set(1.75, 1.75);

        door.updateHitbox();

        door.screenCenter();

        add(door);

        lock = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/swinging-door-lock"));

        lock.active = false;

        lock.visible = false;

        lock.scale.set(3.5, 3.5);

        lock.updateHitbox();

        lock.setPosition(lock.getCenterX(), lock.getCenterY() - 35.0);

        add(lock);

        nameText = new FlxText(0.0, 0.0, door.width);

        nameText.color = FlxColor.BLACK;

        nameText.size = 28;

        nameText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        nameText.alignment = CENTER;

        nameText.textField.antiAliasType = ADVANCED;

        nameText.textField.sharpness = 400.0;

        nameText.setPosition(door.getCenterX(), 258.5);

        add(nameText);

        needHintText = new MenuText(0.0, 0.0, "Need a hint?");

        needHintText.size = 36;

        needHintText.onClick.add(clickNeedHintButton);

        needHintText.setPosition(needHintText.getCenterX(), door.y - 50.0);

        needHintText.kill();

        add(needHintText);

        hintTimer = -1.0;

        startButton = new FlxSprite();

        startButton.loadGraphic(AssetCache.getGraphic("menus/StoryMenuScreen/start-button"), true, 256, 128);

        startButton.animation.add("deselect", [0], 0.0, false);

        startButton.animation.add("select", [1], 0.0, false);

        startButton.scale.set(1.25, 1.25);

        startButton.updateHitbox();

        startButton.setPosition(door.getMidpoint().x - startButton.width * 0.5, startButton.getCenterY() + 275.0);

        add(startButton);

        infoText = new MenuText(0.0, 0.0, "Info");

        infoText.size = 32;

        infoText.onClick.add(clickInfoButton);

        infoText.setPosition(FlxG.width - infoText.width - 165.0, 5.0);

        add(infoText);

        leftButton = addOrientedButton(LEFT, clickLeftButton);

        leftButton.setPosition(leftButton.getCenterX() - 150.0, leftButton.getCenterY());

        rightButton = addOrientedButton(RIGHT, clickRightButton);

        rightButton.setPosition(rightButton.getCenterX() + 150.0, rightButton.getCenterY());

        changeSelection(0);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(FlxG.switchState.bind(() -> new ModeSelectScreen()));

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

        tune = FlxG.sound.load(AssetCache.getMusic("menus/MysteryScreen/tune"), 1.0, true);

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

                mark.velocity.x += FlxG.random.int(2, 10) * direction;

                // Hopefully fixes an issue where question marks get stuck on an edge?
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

                mark.velocity.y += FlxG.random.int(2, 10) * direction;

                // Hopefully fixes an issue where question marks get stuck on an edge?
                if (mark.y <= top)
                    mark.y = top + 1;
                else
                    mark.y = bottom - mark.height - 1.0;
            }
        }

        if (#if debug true #else !hasScore #end && hintTimer != -1.0)
        {
            hintTimer += elapsed;

            if (hintTimer >= 5.0)
            {
                needHintText.revive();

                hintTimer = -1.0;

                FlxG.sound.play(AssetCache.getSound("shared/notebook-respawn"), 0.75);
            }
        }

        if (FlxG.mouse.overlaps(startButton, camera))
        {
            startButton.animation.play("select");

            if (FlxG.mouse.justReleased)
            {
                ClickSoundUtil.play();

                clickStartButton();
            }
        }
        else
            startButton.animation.play("deselect");
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function spawnQuestionMark():Void
    {
        var mark:FlxSprite = new FlxSprite();

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

    public function fadeOutUI():Void
    {
        tween.tween(startButton, {alpha: 0.0}, 0.35);

        tween.tween(infoText, {alpha: 0.0}, 0.35);

        tween.tween(leftButton, {alpha: 0.0}, 0.35);

        tween.tween(rightButton, {alpha: 0.0}, 0.35);

        tween.tween(backOutButton, {alpha: 0.0}, 0.35);
    }

    public function clickNeedHintButton():Void
    {
        needHintText.kill();

        openSubState(new HintScreen(levels[curSelected].name));
    }

    public function clickInfoButton():Void
    {
        var level:LevelData = levels[curSelected];

        if (#if debug false && #end !hasScore)
            return;

        openSubState(new LevelInfoScreen(levels[curSelected]));
    }

    public function clickStartButton():Void
    {
        var level:LevelData = levels[curSelected];

        #if !debug
        if (!hasScore)
            return;
        #end

        FlxG.mouse.enabled = false;

        FlxG.mouse.visible = false;

        fadeOutUI();

        needHintText.kill();

        hintTimer = -1.0;

        new FlxTimer(timer).start(1.5, (_:FlxTimer) ->
        {
            var doorOpen:FlxSprite = new FlxSprite();

            doorOpen.loadGraphic(AssetCache.getGraphic("menus/MysteryScreen/door-open"), true, 256, 256);

            doorOpen.animation.add("noise", [0, 1], 24.0);

            doorOpen.animation.play("noise");

            doorOpen.scale.set(1.75, 1.75);

            doorOpen.updateHitbox();

            doorOpen.screenCenter();

            add(doorOpen);

            FlxG.sound.play(AssetCache.getSound("shared/door-open"));

            var noiseSnd:FlxSound = FlxG.sound.play(AssetCache.getSound("shared/static-noise"), 0.15, true);

            new FlxTimer(timer).start(1.0, (_:FlxTimer) ->
            {
                tween.num(0.15, 0.35, 1.0, {ease: FlxEase.expoIn}, (num:Float) -> {noiseSnd.volume = num;});

                tween.tween(camera, {zoom: 1.65}, 1.0, {ease: FlxEase.expoIn, onComplete: (_:FlxTween) ->
                {
                    FlxG.camera.visible = false;

                    FlxG.mouse.enabled = true;

                    tune.stop();

                    noiseSnd.stop();

                    PlayState.loadLevel(levels[curSelected], {nextState: () -> new MysteryScreen()});
                }});
            });
        });
    }

    public function clickLeftButton():Void
    {
        changeSelection(-1);
    }

    public function clickRightButton():Void
    {
        changeSelection(1);
    }

    public function changeSelection(change:Int):Void
    {
        curSelected = FlxMath.wrap(curSelected + change, 0, levels.length - 1);

        var level:LevelData = levels[curSelected];

        var score:Int = HighScore.getLevelScore(level.name, "Normal").score;

        hasScore = score != 0.0;

        nameText.text = level.name;

        var playSound:Bool = true;

        if (change != 0.0)
        {
            if (lock.visible && score == 0.0 || !lock.visible && score != 0.0)
                playSound = false;
        }

        #if !debug
        lock.visible = score == 0.0;

        nameText.visible = score != 0.0; 
        #end

        needHintText.kill();

        if (score == 0.0)
        {
            #if !debug
            hintTimer = 0.0;

            if (playSound)
                FlxG.sound.play(AssetCache.getSound("shared/swinging-lock"));
            #end
        }
        else
        {
            if (playSound)
                FlxG.sound.play(AssetCache.getSound("shared/door-unlock"));
        }
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }
}

class HintScreen extends CustomSubState
{
    public static var hintTable:Map<String, String> =
    [
        "Beginnings" => "\"31718\"",

        "Uncanon" => "He resides near a soda machine, and he\ndefinitely isn't canon.",

        "Overseer" => "\"Game over!\"",

        "Two" => "\"Welcome 2 Baldi's...\""
    ];

    public var name:String;

    public var thumbsUp:FlxSprite;

    public var hintText:FlxText;

    public var backOutButton:BackOutButton;

    public function new(name:String):Void
    {
        super();

        this.name = name;
    }

    override function create():Void
    {
        super.create();

        thumbsUp = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/baldi-thumbs-up"));

        thumbsUp.scale.set(2.0, 2.0);

        thumbsUp.updateHitbox();

        thumbsUp.setPosition(thumbsUp.getCenterX(), FlxG.height);

        tween.tween(thumbsUp, {y: 0.0}, 0.5);

        add(thumbsUp);

        hintText = new FlxText(0.0, 0.0, thumbsUp.width, hintTable[name]);

        hintText.visible = false;

        hintText.color = FlxColor.BLACK;

        hintText.size = 44;

        hintText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        hintText.alignment = CENTER;

        hintText.textField.antiAliasType = ADVANCED;

        hintText.textField.sharpness = 400.0;

        hintText.setPosition(hintText.getCenterX(), 25.0);

        add(hintText);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(clickBackOutButton);

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

        new FlxTimer(timer).start(0.5, (_:FlxTimer) ->
        {
            setUIVisible(true);

            tween.flicker(hintText, 1.5, 0.2);

            FlxG.sound.play(AssetCache.getSound("shared/correct-activ"), 0.75);
        });
    }

    public function setUIVisible(visible:Bool):Void
    {
        hintText.visible = visible;
    }

    public function clickBackOutButton():Void
    {
        @:privateAccess
        if (!tween.containsTweensOf(thumbsUp))
        {
            tween.tween(thumbsUp, {y: FlxG.height}, 0.5, {onComplete: (_:FlxTween) ->
            {
                close();
            }});

            tween.cancelTweensOf(hintText);

            setUIVisible(false);
        }
    }
}