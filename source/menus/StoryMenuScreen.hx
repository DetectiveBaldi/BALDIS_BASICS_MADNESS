package menus;

import menus.ModeSelectScreen.ModeSelectIcon;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

import data.WeekData;

import extendable.ResourceState;

import menus.FreeplayScreen.ButtonOrientation;
import menus.FreeplayScreen.OrientedButton;

import game.PlayState;

using util.MathUtil;
using util.StringUtil;

class StoryMenuScreen extends ResourceState
{
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

    public var curSelected:Int;

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.WHITE;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic(Paths.image(Paths.png("globals/defaultCursor"))).bitmap);

        background = new FlxBackdrop(Assets.getGraphic(Paths.image(Paths.png("globals/microphone"))), XY, 32.0, 32.0);

        background.velocity.set(10.0, 10.0);

        background.alpha = 0.35;

        add(background);

        clipboard = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("globals/clipboard"))));

        clipboard.scale.set(1.5, 1.5);

        clipboard.updateHitbox();

        clipboard.setPosition(125.0, FlxG.height - clipboard.height * 0.75);

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

        weekInfoBoard = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("menus/StoryMenuScreen/week-info-board"))));

        weekInfoBoard.scale.set(1.25, 1.25);

        weekInfoBoard.updateHitbox();

        weekInfoBoard.setPosition(165.0, 15.0);
        
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

        weekDescText.size = 24;

        weekDescText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        weekDescText.alignment = CENTER;

        weekDescText.textField.antiAliasType = ADVANCED;

        weekDescText.textField.sharpness = 400.0;

        weekDescText.setPosition(weekInfoBoard.getMidpoint().x - weekDescText.width * 0.5, weekNameText.y + 65.0);

        add(weekDescText);

        chalkboard = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("globals/chalkboard"))));

        chalkboard.scale.set(1.25, 1.25);

        chalkboard.updateHitbox();

        chalkboard.setPosition(FlxG.width - chalkboard.width - 125.0, weekInfoBoard.getMidpoint().y - chalkboard.height * 0.5);

        add(chalkboard);

        weekPortrait = new FlxSprite();

        add(weekPortrait);

        exitButton = new FlxSprite();

        exitButton.loadGraphic(Assets.getGraphic(Paths.image(Paths.png("menus/MainMenuScreen/exitButton"))), true, 32, 32);

        exitButton.animation.add("deselect", [0], 0.0, false);

        exitButton.animation.add("select", [1], 0.0, false);

        exitButton.scale.set(2.0, 2.0);

        exitButton.updateHitbox();

        exitButton.setPosition(10.0, 10.0);

        add(exitButton);

        startButton = new FlxSprite();

        startButton.loadGraphic(Assets.getGraphic(Paths.image(Paths.png("menus/StoryMenuScreen/start-button"))), true, 256, 128);

        startButton.animation.add("deselect", [0], 0.0, false);

        startButton.animation.add("select", [1], 0.0, false);

        startButton.scale.set(1.25, 1.25);

        startButton.updateHitbox();

        startButton.setPosition(chalkboard.getMidpoint().x - startButton.width * 0.5, (FlxG.height - startButton.height) * 0.5 + 150.0);

        add(startButton);

        curSelected = 0;

        changeSelection(0);

        var leftButton:OrientedButton = addOrientedButton(LEFT, clickLeftButton);

        leftButton.setPosition(chalkboard.x - leftButton.width + 65.0, chalkboard.getMidpoint().y - leftButton.height * 0.5);

        var rightButton:OrientedButton = addOrientedButton(RIGHT, clickRightButton);

        rightButton.setPosition(chalkboard.x + chalkboard.width - 65.0, chalkboard.getMidpoint().y - rightButton.height * 0.5);

        MainMenuScreen.playMusic();
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
                MainMenuScreen.fadeMusic();

                PlayState.loadWeek(WeekData.list[curSelected], 0, true);
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
        curSelected = FlxMath.wrap(change, 0, WeekData.list.length - 1);

        var week:WeekData = WeekData.list[curSelected];

        var text:String = "";

        for (i in 0 ... week.levels.length)
            text += '${week.levels[i].name}\n';

        songListText.text = text;

        text = week.name;

        if (text == "Baldi")
            text += "'s Week";

        if (text == "Classic")
            text += " Week";

        weekNameText.text = text;

        text = week.description;

        weekDescText.text = text;

        updateWeekPortrait(week);
    }

    public function updateWeekPortrait(week:WeekData):Void
    {
        weekPortrait.loadGraphic(Assets.getGraphic(Paths.image(Paths.png('globals/week-portrait-${week.name.setCase(KEBAB)}'))));

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