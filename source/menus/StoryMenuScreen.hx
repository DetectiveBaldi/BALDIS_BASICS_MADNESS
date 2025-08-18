package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;

import flixel.addons.display.FlxBackdrop;

import core.AssetCache;
import core.Paths;

import data.WeekData;

import extendable.CustomState;

import game.HighScore;
import game.PlayState;

import ui.OrientedButton;

using util.MathUtil;
using util.StringUtil;

class StoryMenuScreen extends CustomState
{
    public var weeks:Array<WeekData>;

    public var background:FlxSprite;

    public var clipboard:FlxSprite;

    public var songsLabel:FlxText;

    public var songListText:FlxText;

    public var weekInfoBoard:FlxSprite;

    public var weekNameText:FlxText;

    public var weekDescText:FlxText;

    public var chalkboard:FlxSprite;

    public var weekPortrait:FlxSprite;

    public var exitButton:FlxSprite;

    public var startButton:FlxSprite;

    public var weekScore:Int;

    public var scoreTween:FlxTween;

    public var scoreText:FlxText;

    public static var curSelected:Int = 0;

    override function create():Void
    {
        super.create();

        weeks = new Array<WeekData>();

        for (i in 0 ... WeekData.list.length)
        {
            var week:WeekData = WeekData.list[i];

            if (!week.showInStoryMenu)
                continue;

            weeks.push(week);
        }

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        background = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.scale.set(960.0, FlxG.height);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        clipboard = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/clipboard"));

        clipboard.scale.set(1.5, 1.5);

        clipboard.updateHitbox();

        clipboard.setPosition(195.0, FlxG.height - clipboard.height * 0.75 - 40.0);

        add(clipboard);

        songsLabel = new FlxText(0.0, 0.0, clipboard.width, "SONGS:");

        songsLabel.color = FlxColor.BLACK;

        songsLabel.size = 32;

        songsLabel.font = Paths.font(Paths.ttf("Comic Sans MS"));

        songsLabel.underline = true;

        songsLabel.alignment = CENTER;

        songsLabel.textField.antiAliasType = ADVANCED;

        songsLabel.textField.sharpness = 400.0;

        songsLabel.setPosition(clipboard.getMidpoint().x - songsLabel.width * 0.5, clipboard.y + 35.0);

        add(songsLabel);

        songListText = new FlxText(0.0, 0.0, clipboard.width, "");

        songListText.color = FlxColor.BLACK;

        songListText.size = 24;

        songListText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        songListText.alignment = CENTER;

        songListText.textField.antiAliasType = ADVANCED;

        songListText.textField.sharpness = 400.0;

        songListText.setPosition(clipboard.getMidpoint().x - songsLabel.width * 0.5, songsLabel.y + 50.0);

        add(songListText);

        weekInfoBoard = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/StoryMenuScreen/week-info-board"));

        weekInfoBoard.scale.set(1.15, 1.15);

        weekInfoBoard.updateHitbox();

        weekInfoBoard.setPosition(195.0, 45.0);
        
        add(weekInfoBoard);

        weekNameText = new FlxText(0.0, 0.0, weekInfoBoard.width, "");

        weekNameText.color = FlxColor.BLACK;

        weekNameText.size = 36;

        weekNameText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        weekNameText.underline = true;

        weekNameText.alignment = CENTER;

        weekNameText.textField.antiAliasType = ADVANCED;

        weekNameText.textField.sharpness = 400.0;

        weekNameText.setPosition(weekInfoBoard.getMidpoint().x - weekNameText.width * 0.5, weekInfoBoard.y + 25.0);

        add(weekNameText);

        weekDescText = new FlxText(0.0, 0.0, weekInfoBoard.width - 27.5, "");

        weekDescText.color = FlxColor.BLACK;

        weekDescText.size = 22;

        weekDescText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        weekDescText.alignment = CENTER;

        weekDescText.textField.antiAliasType = ADVANCED;

        weekDescText.textField.sharpness = 400.0;

        weekDescText.setPosition(weekInfoBoard.getMidpoint().x - weekDescText.width * 0.5, weekNameText.y + 65.0);

        add(weekDescText);

        chalkboard = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/chalkboard"));

        chalkboard.scale.set(1.25, 1.25);

        chalkboard.updateHitbox();

        chalkboard.setPosition(FlxG.width - chalkboard.width - 180.0, weekInfoBoard.getMidpoint().y - chalkboard.height * 0.5);

        add(chalkboard);

        weekPortrait = new FlxSprite();

        add(weekPortrait);

        exitButton = new FlxSprite();

        exitButton.loadGraphic(AssetCache.getGraphic("menus/MainMenuScreen/exitButton"), true, 32, 32);

        exitButton.animation.add("deselect", [0], 0.0, false);

        exitButton.animation.add("select", [1], 0.0, false);

        exitButton.scale.set(2.0, 2.0);

        exitButton.updateHitbox();

        exitButton.setPosition(FlxG.width - exitButton.width - 165.0, 5.0);

        add(exitButton);

        startButton = new FlxSprite();

        startButton.loadGraphic(AssetCache.getGraphic("menus/StoryMenuScreen/start-button"), true, 256, 128);

        startButton.animation.add("deselect", [0], 0.0, false);

        startButton.animation.add("select", [1], 0.0, false);

        startButton.scale.set(1.25, 1.25);

        startButton.updateHitbox();

        startButton.setPosition(chalkboard.getMidpoint().x - startButton.width * 0.5, startButton.getCenterY() + 150.0);

        add(startButton);

        weekScore = 0;

        scoreText = new FlxText(0.0, 0.0, FlxG.width, "");

        scoreText.color = FlxColor.BLACK;

        scoreText.size = 24;

        scoreText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        scoreText.alignment = RIGHT;

        scoreText.textField.antiAliasType = ADVANCED;

        scoreText.textField.sharpness = 400.0;

        scoreText.setPosition(FlxG.width - scoreText.width - 160.0, FlxG.height - scoreText.height);

        add(scoreText);

        changeSelection(curSelected);

        var leftButton:OrientedButton = addOrientedButton(LEFT, clickLeftButton);

        leftButton.setPosition(chalkboard.x - leftButton.width + 85.0, chalkboard.getMidpoint().y - leftButton.height * 0.5);

        var rightButton:OrientedButton = addOrientedButton(RIGHT, clickRightButton);

        rightButton.setPosition(chalkboard.x + chalkboard.width - 85.0, chalkboard.getMidpoint().y - rightButton.height * 0.5);

        MainMenuScreen.playTune();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("select");

            if (FlxG.mouse.justReleased)
                FlxG.switchState(() -> new ModeSelectScreen());
        }
        else
            exitButton.animation.play("deselect");

        if (FlxG.mouse.overlaps(startButton, camera))
        {
            startButton.animation.play("select");

            if (FlxG.mouse.justReleased)
            {
                var weekToLoad:WeekData = weeks[curSelected];

                if (HighScore.getWeekScore(weekToLoad.name, "normal").score == 0.0 && #if debug false #else
                    weekToLoad.requiresScoreToPlay #end)
                        return;

                MainMenuScreen.fadeTune();

                PlayState.loadWeek(weekToLoad);
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

    public function changeSelection(change:Int):Void
    {
        curSelected = FlxMath.wrap(change, 0, weeks.length - 1);

        var week:WeekData = weeks[curSelected];

        var text:String = "";

        for (i in 0 ... week.levels.length)
            text += '${week.levels[i].name}\n';

        songListText.text = text;

        text = week.name;
        
        text += week.nameSuffix;

        weekNameText.text = text;

        text = week.description;

        weekDescText.text = text;

        scoreTween?.cancel();

        scoreTween = tween.num(weekScore, HighScore.getWeekScore(week.name, "normal").score, 0.35, null, (v:Float) -> {
            weekScore = Math.floor(v); scoreText.text = 'High Score: ${weekScore}';});

        updateWeekPortrait(week);
    }

    public function updateWeekPortrait(week:WeekData):Void
    {
        weekPortrait.loadGraphic(AssetCache.getGraphic('shared/week-portrait-${week.name.setCase(" ", KEBAB)}'));

        weekPortrait.scale.set(1.25, 1.25);

        weekPortrait.updateHitbox();

        weekPortrait.centerTo(chalkboard);
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
        changeSelection(curSelected - 1);
    }

    public function clickRightButton():Void
    {
        changeSelection(curSelected + 1);
    }
}