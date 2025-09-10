package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.AssetCache;
import core.Paths;

import data.Difficulty;
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

// TODO: Optimize using local static variables.
class FreeplayScreen extends CustomState
{
    public static var selectedDifficulty:Int = 0;

    public static var lastSelectedLevel:Map<Int, Int> = new Map<Int, Int>();

    public static var selectedLevel:Int = 0;

    public var levels:Array<LevelData>;

    public var background:FlxSprite;

    public var scrollBg:FlxSprite;

    public var tv:FlxSprite;

    public var tvPortrait:FlxSprite;

    public var tvStatic:FlxSprite;

    public var poster:FlxSprite;

    public var difficultyPanel:FlxSprite;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

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

        difficultyPanel = new FlxSprite();

        difficultyPanel.active = false;

        add(difficultyPanel);

        updateDifficultyPanel(true);

        changeDifficulty(0);

        var playButton:HeightenedButton = addHeightenedButton("Play!", LARGE, clickPlayButton);

        playButton.setPosition(playButton.getCenterX(), FlxG.height - playButton.height + 35.0);

        var exitButton:HeightenedButton = addHeightenedButton("Exit", SMALL, clickExitButton);

        exitButton.onClick.remove(MainMenuScreen.fadeTune);

        exitButton.setPosition(playButton.x - exitButton.width - 30.0, FlxG.height - exitButton.height + 35.0);

        var infoButton:HeightenedButton = addHeightenedButton("Info", SMALL, clickInfoButton);

        infoButton.setPosition(playButton.x + playButton.width + 30.0, FlxG.height - infoButton.height + 35.0);

        var leftLevel:OrientedButton = addOrientedButton(LEFT, clickLeftLevel);

        leftLevel.setPosition(leftLevel.getCenterX() - 225.0, leftLevel.getCenterY());

        var rightLevel:OrientedButton = addOrientedButton(RIGHT, clickRightLevel);

        rightLevel.setPosition(rightLevel.getCenterX() + 225.0, rightLevel.getCenterY());

        var leftDifficulty:OrientedButton = addOrientedButton(LEFT, clickLeftDifficulty);

        leftDifficulty.scale.set(2.0, 2.0);

        leftDifficulty.updateHitbox();

        leftDifficulty.setPosition(leftDifficulty.getCenterX(difficultyPanel) - 142.0, 42.0);

        var rightDifficulty:OrientedButton = addOrientedButton(RIGHT, clickRightDifficulty);

        rightDifficulty.scale.set(2.0, 2.0);

        rightDifficulty.updateHitbox();

        rightDifficulty.setPosition(rightDifficulty.getCenterX(difficultyPanel) + 142.0, 42.0);

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

    public function changeDifficulty(change:Int):Void
    {
        var list:Array<String> = Difficulty.list;

        lastSelectedLevel[selectedDifficulty] = selectedLevel;

        selectedDifficulty = FlxMath.wrap(selectedDifficulty + change, 0, list.length - 1);

        var newLevels:Array<LevelData> = filterLevelsList();

        if (newLevels.length == 0.0)
        {
            selectedDifficulty = FlxMath.wrap(selectedDifficulty - change, 0, list.length - 1);

            return;
        }

        levels = newLevels;

        if (change != 0.0)
            selectedLevel = lastSelectedLevel.exists(selectedDifficulty) ? lastSelectedLevel[selectedDifficulty] : 0;

        changeSelection(0);

        if (change != 0.0)
            updateDifficultyPanel();
    }

    public function changeSelection(change:Int):Void
    {
        selectedLevel = FlxMath.wrap(selectedLevel + change, 0, levels.length - 1);

        scrollBg.visible = true;

        scrollBg.animation.play("move", false, change < 0.0);

        poster.visible = false;

        var level:LevelData = levels[selectedLevel];

        updateTvPortrait(level);

        updatePoster(level);

        tween.cancelTweensOf(tvStatic, ["alpha"]);

        tvStatic.alpha = 1.0;

        var week:WeekData = level.week;

        if (week != null)
        {
            var filtered:Array<LevelData> = week.filterByDifficulty(level.difficulty);
            
           if (#if debug true #else week.scoresValidated() && (filtered.indexOf(level) == 0.0 ||
                HighScore.getLevelScore(level.name, level.difficulty).score != 0.0) #end)
                    tween.tween(tvStatic, {alpha: 0.0}, 0.5);
        }
    }

    public function filterLevelsList():Array<LevelData>
    {
        var res:Array<LevelData> = new Array<LevelData>();

        var list:Array<String> = Difficulty.list;

        for (i in 0 ... WeekData.list.length)
        {
            var week:WeekData = WeekData.list[i];

            if (!week.showInFreeplayMenu)
                continue;

            var difficulty:String = Difficulty.list[selectedDifficulty];

            var hasDifficulty:Bool = week.hasDifficulty(difficulty);

            if (!hasDifficulty #if !debug || (difficulty != "Normal" &&
                HighScore.getWeekScore(week.name, "Normal").score == 0.0) #end)
                    continue;

            for (j in 0 ... week.levels.length)
            {
                var level:LevelData = week.levels[j];

                if (level.difficulty != difficulty)
                    continue;

                res.push(level);
            }
        }
    
        for (i in 0 ... LevelData.list.length)
        {
            var level:LevelData = LevelData.list[i];

            if (level.difficulty != list[selectedDifficulty] || !level.showInFreeplayMenu || level.showInMysteryMenu)
                continue;

            res.push(level);
        }

        return res;
    }

    public function updateTvPortrait(level:LevelData):Void
    {
        var week:WeekData = level.week;

        var portraitStr:String = 'menus/FreeplayScreen/portraits/${week?.name?.toLowerCase()}';

        if (Paths.list.contains(Paths.image(Paths.png(portraitStr))))
            tvPortrait.loadGraphic(AssetCache.getGraphic(portraitStr));

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
            if (#if debug false #else HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end)
                path = "level-score-needed";
        }
        else
        {
            var filtered:Array<LevelData> = week.filterByDifficulty(level.difficulty);
            
            if (#if debug false #else !week.scoresValidated() || filtered.indexOf(level) != 0.0 &&
                HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end)
                    path = "week-score-needed";
        }

        poster.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/posters/${path}'));

        poster.setGraphicSize(350.0, 350.0);

        poster.updateHitbox();

        poster.screenCenter();
    }

    public function updateDifficultyPanel(cancelFadeIn:Bool = false):Void
    {
        tween.cancelTweensOf(difficultyPanel);

        if (cancelFadeIn)
        {
            difficultyPanel.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/panels/diff-${Difficulty.list[selectedDifficulty]}'));

            difficultyPanel.setPosition(difficultyPanel.getCenterX(), -difficultyPanel.height);
        }
        else
        {
            tween.tween(difficultyPanel, {y: -difficultyPanel.height}, 0.25, {ease: FlxEase.backOut, onComplete: (_:FlxTween) ->
            {
                difficultyPanel.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/panels/diff-${Difficulty.list[selectedDifficulty]}'));
            }});
        }

        tween.tween(difficultyPanel, {y: -15.0}, 0.25, {ease: FlxEase.backOut, startDelay: cancelFadeIn ? 0.0 : 0.25});

        FlxG.sound.play(AssetCache.getSound("shared/swinging-lock"));
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
        if (!scrollBg.animation.finished)
            return;

        changeDifficulty(-1);
    }

    public function clickRightDifficulty():Void
    {
        if (!scrollBg.animation.finished)
            return;

        changeDifficulty(1);
    }

    public function clickLeftLevel():Void
    {
        if (!scrollBg.animation.finished)
            return;

        changeSelection(-1);
    }

    public function clickRightLevel():Void
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
        var level:LevelData = levels[selectedLevel];

        var week:WeekData = level.week;
        
        if (week != null)
        {
            var filtered:Array<LevelData> = week.filterByDifficulty(level.difficulty);
            
            if (#if debug false #else !week.scoresValidated() || filtered.indexOf(level) != 0.0 &&
                HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end)
                    return;
        }

        MainMenuScreen.fadeTune();

        PlayState.loadLevel(level);
    }

    public function clickExitButton():Void
    {
        FlxG.switchState(() -> new ModeSelectScreen());
    }

    public function clickInfoButton():Void
    {
        var level:LevelData = levels[selectedLevel];

        var week:WeekData = level.week;

        if (week == null)
        {
            if (#if debug false #else HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end)
                return;
        }
        else
        {
            if (#if debug false #else !week.scoresValidated() #end)
                return;
        }

        openSubState(new LevelInfoScreen(levels[selectedLevel]));
    }
}