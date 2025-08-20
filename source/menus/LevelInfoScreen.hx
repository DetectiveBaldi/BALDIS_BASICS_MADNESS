package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.math.FlxMath;

import flixel.util.FlxColor;

import flixel.text.FlxText;

import core.AssetCache;
import core.Paths;

import data.LevelData;
import data.PlayStats;

import game.HighScore;

import ui.BackOutButton;

using util.MathUtil;

class LevelInfoScreen extends FlxSubState
{
    public var clipboard:FlxSprite;

    public var level:LevelData;

    public var nameText:FlxText;

    public var scoreText:FlxText;

    public var gradeText:FlxText;

    public var backOutButton:BackOutButton;

    public function new(level:LevelData):Void
    {
        super();

        this.level = level;
    }

    override function create():Void
    {
        super.create();

        clipboard = new FlxSprite();

        clipboard.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("menus/LevelInfoScreen/clipboard-info-flip"), 
            Paths.image(Paths.xml("menus/LevelInfoScreen/clipboard-info-flip")));

        clipboard.animation.addByPrefix("flip", "flip", 24.0, false);

        clipboard.setGraphicSize(960.0, 720.0);

        clipboard.updateHitbox();

        clipboard.screenCenter();

        add(clipboard);

        var name:String = level.name;

        var highScore:LevelScore = HighScore.getLevelScore(level.name, "normal");

        #if !debug
        if (highScore.score == 0.0)
            name = "...";
        #end

        nameText = new FlxText(0.0, 0.0, clipboard.width, name);

        nameText.visible = false;

        nameText.color = FlxColor.BLACK;

        nameText.size = 64;

        nameText.bold = true;

        nameText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        nameText.alignment = CENTER;

        nameText.textField.antiAliasType = ADVANCED;

        nameText.textField.sharpness = 400.0;

        nameText.setPosition(clipboard.getCenterX(), 160.0);

        add(nameText);

        scoreText = new FlxText(0.0, 0.0, clipboard.width, 'Score: ${highScore.score}\nMisses: ${highScore.misses}\nAccuracy: ${Std.string(FlxMath.roundDecimal(highScore.accuracy, 2))}%\nGrade:');

        scoreText.visible = false;

        scoreText.color = FlxColor.BLACK;

        scoreText.size = 44;

        scoreText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        scoreText.alignment = CENTER;

        scoreText.textField.antiAliasType = ADVANCED;

        scoreText.textField.sharpness = 400.0;

        scoreText.setPosition(clipboard.getCenterX(), 250.0);

        add(scoreText);

        gradeText = new FlxText(0.0, 0.0, clipboard.width, Std.string(HighScore.getLevelScore(level.name, "normal").grade));

        gradeText.visible = false;

        gradeText.color = PlayStats.getColorForGrade(highScore.grade);

        gradeText.size = 200;

        gradeText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        gradeText.alignment = CENTER;

        gradeText.textField.antiAliasType = ADVANCED;

        gradeText.textField.sharpness = 400.0;

        gradeText.setPosition(clipboard.getCenterX(), 450.0);

        add(gradeText);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(closePanel);

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

        clipboard.animation.onFinish.add((name:String) -> setUIVisible(true));

        clipboard.animation.play("flip");
    }

    public function setUIVisible(visible:Bool):Void
    {
        nameText.visible = visible;

        scoreText.visible = visible;

        gradeText.visible = visible;
    }

    public function closePanel():Void
    {
        if (clipboard.animation.finished)
        {
            clipboard.animation.onFinish.removeAll();

            clipboard.animation.onFinish.add((name:String) -> close());

            clipboard.animation.play("flip", false, true);

            setUIVisible(false);
        }
    }
}