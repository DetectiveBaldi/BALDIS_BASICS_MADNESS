package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import flixel.addons.display.FlxBackdrop;

import api.DiscordHandler;

import core.AssetCache;
import core.Paths;

import data.Difficulty;
import data.LevelData;
import data.WeekData;

import extendable.TransitionState;

import game.HighScore;
import game.PlayState;

import interfaces.ISequenceHandler;

import ui.BackOutButton;
import ui.OrientedButton;

import util.ClickSoundUtil;
import util.MouseBitmaps;

using util.MathUtil;
using util.StringUtil;

class StoryMenuScreen extends TransitionState implements ISequenceHandler
{
    public static var selectedDifficulty:Int = 0;

    public static var lastSelectedWeek:Map<Int, Int> = new Map<Int, Int>();

    public static var selectedWeek:Int;

    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;

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

    public var difficultyText:FlxText;

    public var weekScore:Int;

    public var scoreText:FlxText;

    public var scoreTween:FlxTween;

    public var startButton:FlxSprite;

    public var backOutButton:BackOutButton;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        MouseBitmaps.setMouseBitmap(HAND);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        DiscordHandler.setState("Looking for a week to play.");

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        DiscordHandler.setImageTexts(null, null);

        tweens = new FlxTweenManager();

        add(tweens);

        timers = new FlxTimerManager();

        add(timers);

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

        songsLabel.setPosition(clipboard.getMidpoint().x - songsLabel.width * 0.5, clipboard.y + 35.0);

        add(songsLabel);

        songListText = new FlxText(0.0, 0.0, clipboard.width, "");

        songListText.color = FlxColor.BLACK;

        songListText.size = 24;

        songListText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        songListText.alignment = CENTER;

        songListText.setPosition(clipboard.getMidpoint().x - songsLabel.width * 0.5, songsLabel.y + 45.0);

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

        weekNameText.setPosition(weekInfoBoard.getMidpoint().x - weekNameText.width * 0.5, weekInfoBoard.y + 25.0);

        add(weekNameText);

        weekDescText = new FlxText(0.0, 0.0, weekInfoBoard.width - 27.5);

        weekDescText.color = FlxColor.BLACK;

        weekDescText.size = 22;

        weekDescText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        weekDescText.alignment = CENTER;

        weekDescText.setPosition(weekInfoBoard.getMidpoint().x - weekDescText.width * 0.5, weekNameText.y + 55.0);

        add(weekDescText);

        chalkboard = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/chalkboard"));

        chalkboard.scale.set(1.25, 1.25);

        chalkboard.updateHitbox();

        chalkboard.setPosition(FlxG.width - chalkboard.width - 180.0, weekInfoBoard.getMidpoint().y - chalkboard.height * 0.5);

        add(chalkboard);

        weekPortrait = new FlxSprite();

        add(weekPortrait);

        difficultyText = new FlxText(0.0, 0.0, chalkboard.width, "");

        difficultyText.color = FlxColor.BLACK;

        difficultyText.size = 28;

        difficultyText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        difficultyText.alignment = CENTER;

        difficultyText.setPosition(difficultyText.getCenterX(chalkboard), chalkboard.y + chalkboard.height - 15.0);

        add(difficultyText);

        weekScore = 0;

        scoreText = new FlxText(0.0, 0.0, FlxG.width, "");

        scoreText.color = FlxColor.BLACK;

        scoreText.size = 24;

        scoreText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        scoreText.alignment = RIGHT;

        scoreText.setPosition(FlxG.width - scoreText.width - 160.0, FlxG.height - scoreText.height);

        add(scoreText);

        startButton = new FlxSprite();

        startButton.loadGraphic(AssetCache.getGraphic("menus/StoryMenuScreen/start-button"), true, 256, 128);

        startButton.animation.add("deselect", [0], 0.0, false);

        startButton.animation.add("select", [1], 0.0, false);

        startButton.scale.set(1.25, 1.25);

        startButton.updateHitbox();

        startButton.setPosition(startButton.getCenterX(chalkboard), chalkboard.y + chalkboard.height + 55.0);

        add(startButton);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(FlxG.switchState.bind(() -> new ModeSelectScreen()));

        backOutButton.setPosition(FlxG.width - backOutButton.width - 165.0, 5.0);

        add(backOutButton);

        changeDifficulty(0);

        var leftDifficulty:OrientedButton = addOrientedButton(LEFT, clickLeftDifficulty);

        leftDifficulty.scale.set(1.5, 1.5);

        leftDifficulty.updateHitbox();

        leftDifficulty.centerTo(difficultyText);

        leftDifficulty.x -= 96.0;

        var rightDifficulty:OrientedButton = addOrientedButton(RIGHT, clickRightDifficulty);

        rightDifficulty.scale.set(1.5, 1.5);

        rightDifficulty.updateHitbox();

        rightDifficulty.centerTo(difficultyText);

        rightDifficulty.x += 96.0;

        var leftWeek:OrientedButton = addOrientedButton(LEFT, clickLeftWeek);

        leftWeek.setPosition(chalkboard.x - leftWeek.width + 85.0, chalkboard.getMidpoint().y - leftWeek.height * 0.5);

        var rightWeek:OrientedButton = addOrientedButton(RIGHT, clickRightWeek);

        rightWeek.setPosition(chalkboard.x + chalkboard.width - 85.0, chalkboard.getMidpoint().y - rightWeek.height * 0.5);

        MainMenuScreen.playTune();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(startButton, camera))
        {
            startButton.animation.play("select");

            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
            {
                var week:WeekData = weeks[selectedWeek];

                if (#if debug false #else !week.scoresValidated() #end)
                    return;

                ClickSoundUtil.play();

                MainMenuScreen.fadeTune();

                week = week.copy();

                week.levels = week.filterByDifficulty(Difficulty.list[selectedDifficulty]);

                PlayState.loadWeek(week);
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

    public function filterWeeksList():Array<WeekData>
    {
        var res:Array<WeekData> = new Array<WeekData>();

        for (i in 0 ... WeekData.list.length)
        {
            var week:WeekData = WeekData.list[i];

            if (!week.showInStoryMenu)
                continue;

            var difficulty:String = Difficulty.list[selectedDifficulty];

            var hasDifficulty:Bool = week.hasDifficulty(difficulty);

            if (!hasDifficulty #if !debug || (difficulty != "Normal" &&
                HighScore.getWeekScore(week.name, "Normal").score == 0.0) #end)
                    continue;

            res.push(week);
        }

        return res;
    }

    public function changeDifficulty(change:Int):Void
    {
        var list:Array<String> = Difficulty.list;

        selectedDifficulty = FlxMath.wrap(selectedDifficulty + change, 0, list.length - 1);

        var newWeeks:Array<WeekData> = filterWeeksList();

        if (newWeeks.length == 0.0)
        {
            selectedDifficulty = FlxMath.wrap(selectedDifficulty - change, 0, list.length - 1);

            return;
        }

        weeks = newWeeks;

        if (change != 0.0)
            selectedWeek = lastSelectedWeek.exists(selectedDifficulty) ? lastSelectedWeek[selectedDifficulty] : 0;

        difficultyText.text = 'Difficulty:\n${list[selectedDifficulty].toUpperCase()}';

        changeSelection(0);
    }

    public function changeSelection(change:Int):Void
    {
        selectedWeek = FlxMath.wrap(selectedWeek + change, 0, weeks.length - 1);

        lastSelectedWeek[selectedDifficulty] = selectedWeek;

        var week:WeekData = weeks[selectedWeek];

        var levels:Array<LevelData> = week.filterByDifficulty(Difficulty.list[selectedDifficulty]);

        var text:String = "";

        for (i in 0 ... levels.length)
            text += '${levels[i].name}\n';

        var scoresValidated:Bool = #if debug true #else week.scoresValidated() #end;

        songListText.text = scoresValidated ? text : "";

        weekNameText.text = scoresValidated ? week.name + week.nameSuffix : "???";

        weekDescText.text = week.description;

        scoreTween?.cancel();

        scoreTween = tweens.num(weekScore, HighScore.getWeekScore(week.name, levels[0].difficulty).score, 0.35, null, (v:Float) -> {
            weekScore = Math.floor(v); scoreText.text = 'High Score: ${weekScore}';});

        updateWeekPortrait(week);
    }

    public function updateWeekPortrait(week:WeekData):Void
    {
        var path:String = 'menus/StoryMenuScreen/week-portrait-${week.name.setCase(" ", KEBAB)}';

        var difficulty:String = Difficulty.list[selectedDifficulty];

        if (difficulty != "Normal")
        {
            if (Paths.exists(Paths.image(Paths.png('${path}-${difficulty.toLowerCase()}'))))
                path += '-${difficulty.toLowerCase()}';
        }

        if (#if debug false #else !week.scoresValidated() #end)
            path = 'menus/StoryMenuScreen/week-portrait-obfuscated';

        weekPortrait.loadGraphic(AssetCache.getGraphic(path));

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

    public function clickLeftDifficulty():Void
    {
        changeDifficulty(-1);
    }

    public function clickRightDifficulty():Void
    {
        changeDifficulty(1);
    }

    public function clickLeftWeek():Void
    {
        changeSelection(-1);
    }

    public function clickRightWeek():Void
    {
        changeSelection(1);
    }
}