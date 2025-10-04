package menus;

import openfl.desktop.Clipboard;

import openfl.geom.Rectangle;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import flixel.input.keyboard.FlxKey;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.text.FlxInputText;
import flixel.text.FlxInputTextManager;
import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

import api.DiscordHandler;

import core.AssetCache;
import core.Paths;

import data.Difficulty;
import data.LevelData;
import data.PlayStats;
import data.WeekData;

import extendable.TransitionState;

import game.HighScore;
import game.PlayState;

import interfaces.ISequenceHandler;

import ui.HeightenedButton;
import ui.OrientedButton;

using StringTools;

using util.MathUtil;
using util.StringUtil;

class FreeplayScreen extends TransitionState implements ISequenceHandler
{
    public static var selectedDifficulty:Int = 0;

    public static var lastSelectedLevel:Map<Int, Int> = new Map<Int, Int>();

    public static var selectedLevel:Int = 0;

    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;

    public var levels:Array<LevelData>;

    public var background:FlxSprite;

    public var scrollBgH:FlxSprite;

    public var scrollBgV:FlxSprite;

    public var isScrolling(get, never):Bool;

    @:noCompletion
    function get_isScrolling():Bool
    {
        return !scrollBgH.animation.finished || !scrollBgV.animation.finished;
    }

    public var tv:FlxSprite;

    public var tvPortrait:FlxSprite;

    public var tvStatic:FlxSprite;

    public var poster:FlxSprite;

    public var difficultyPanel:FlxSprite;

    public var searchItem:SearchItem<LevelData>;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        DiscordHandler.setState("Finding a level to play.");

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        DiscordHandler.setImageTexts(null, null);

        tweens = new FlxTweenManager();

        add(tweens);

        timers = new FlxTimerManager();

        add(timers);

        background = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/FreeplayScreen/background"));

        background.setGraphicSize(FlxG.width, FlxG.height);

        background.updateHitbox();

        background.clipRect = FlxRect.get(160.0, 0.0, 960.0, 720.0);

        background.screenCenter();

        add(background);

        scrollBgH = new FlxSprite();

        scrollBgH.visible = false;

        scrollBgH.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("menus/FreeplayScreen/scroll-bg-h"), 
            Paths.image(Paths.xml("menus/FreeplayScreen/scroll-bg-h")));

        scrollBgH.animation.addByPrefix("scroll-h", "scroll-h", 12.0, false);

        scrollBgH.animation.onFinish.add((name:String) -> { scrollBgH.visible = false; poster.visible = true; });

        scrollBgH.setGraphicSize(FlxG.width, FlxG.height);

        scrollBgH.updateHitbox();

        scrollBgH.clipRect = FlxRect.get(160.0, 0.0, 960.0, 720.0);

        scrollBgH.screenCenter();

        add(scrollBgH);

        scrollBgV = new FlxSprite();

        scrollBgV.visible = false;

        scrollBgV.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("menus/FreeplayScreen/scroll-bg-v"), 
            Paths.image(Paths.xml("menus/FreeplayScreen/scroll-bg-v")));

        scrollBgV.animation.addByPrefix("scroll-v", "scroll-v", 20.0, false);

        scrollBgV.animation.onFinish.add((name:String) -> { scrollBgV.visible = false; poster.visible = true; });

        scrollBgV.setGraphicSize(FlxG.width, FlxG.height);

        scrollBgV.updateHitbox();

        scrollBgV.clipRect = FlxRect.get(160.0, 0.0, 960.0, 720.0);

        scrollBgV.screenCenter();

        add(scrollBgV);

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

        searchItem = new SearchItem();

        searchItem.setPosition(searchItem.getCenterX(), 125.0);

        searchItem.updateIconPosition();

        searchItem.getSearchData = filterLevelsList;

        searchItem.onSearchComplete.add(processSearchStatus);

        add(searchItem);

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

        scrollBgH.animation.timeScale = FlxG.keys.pressed.SHIFT ? 2.0 : 1.5;

        scrollBgV.animation.timeScale = scrollBgH.animation.timeScale;

        searchItem.editable = !isScrolling;
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function changeDifficulty(change:Int):Void
    {
        var list:Array<String> = Difficulty.list;

        selectedDifficulty = FlxMath.wrap(selectedDifficulty + change, 0, list.length - 1);

        searchItem.emptySearch();

        var newLevels:Array<LevelData> = filterLevelsList();

        if (newLevels.length == 0.0)
        {
            selectedDifficulty = FlxMath.wrap(selectedDifficulty - change, 0, list.length - 1);

            return;
        }

        levels = newLevels;

        if (change != 0.0)
            selectedLevel = getLastSelectedLevel();

        changeSelection(0);

        if (change != 0.0)
            updateDifficultyPanel();
    }

    public function changeSelection(change:Int):Void
    {
        selectedLevel = FlxMath.wrap(selectedLevel + change, 0, levels.length - 1);

        if (searchItem.isEmpty())
            setLastSelectedLevel();

        var level:LevelData = levels[selectedLevel];

        updateTvPortrait(level);

        updatePoster(level);

        tweens.cancelTweensOf(tvStatic, ["alpha"]);

        tvStatic.alpha = 1.0;

        var week:WeekData = level.week;

        if (week != null)
        {
            var filtered:Array<LevelData> = week.filterByDifficulty(level.difficulty);
            
           if (#if debug true #else week.scoresValidated() && (filtered.indexOf(level) == 0.0 ||
                HighScore.getLevelScore(level.name, level.difficulty).score != 0.0) #end)
                    tweens.tween(tvStatic, {alpha: 0.0}, 0.5);
        }
    }

    public function filterLevelsList():Array<LevelData>
    {
        var filtered:Array<LevelData> = new Array<LevelData>();

        var list:Array<String> = Difficulty.list;

        var search:String = searchItem.text;

        for (i in 0 ... WeekData.list.length)
        {
            var week:WeekData = WeekData.list[i];

            if (!week.showInFreeplayMenu)
                continue;

            var difficulty:String = Difficulty.list[selectedDifficulty];

            var hasDifficulty:Bool = week.hasDifficulty(difficulty);

            if (!hasDifficulty #if !debug || (difficulty != "Normal" &&
                HighScore.getWeekScore(week.name, "Normal").score == 0.0) #end )
                    continue;

            for (j in 0 ... week.levels.length)
            {
                var level:LevelData = week.levels[j];

                var passesSearch:Bool = true;

                if (search != "")
                {
                    if (!level.name.toUpperCase().startsWith(search))
                        passesSearch = false;

                    if ( #if debug false #else !week.scoresValidated() || week.levels.indexOf(level) != 0.0 && HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end )
                        passesSearch = false;
                }

                if (!passesSearch || level.difficulty != difficulty)
                    continue;

                filtered.push(level);
            }
        }
    
        for (i in 0 ... LevelData.list.length)
        {
            var level:LevelData = LevelData.list[i];

            var passesSearch:Bool = true;

            if (search != "")
            {
                if (!level.name.toUpperCase().startsWith(search))
                    passesSearch = false;
                
                if ( #if debug false #else HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end )
                    passesSearch = false;
            }

            if (!passesSearch || level.difficulty != list[selectedDifficulty] || !level.showInFreeplayMenu ||
                level.obscurity != NONE)
                    continue;

            filtered.push(level);
        }

        return filtered;
    }

    public function scrollBg(axes:FlxAxes, reverse:Bool = false):Void
    {
        if (axes.x)
        {
            scrollBgH.visible = true;
            
            scrollBgH.animation.play("scroll-h", false, reverse);
        }

        if (axes.y)
        {
            scrollBgV.visible = true;

            scrollBgV.animation.play("scroll-v", false, reverse);
        }

        poster.visible = false;
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
            
            if ( #if debug false #else !week.scoresValidated() || filtered.indexOf(level) != 0.0 &&
                HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end )
                    path = "week-score-needed";
        }

        poster.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/posters/${path}'));

        poster.setGraphicSize(350.0, 350.0);

        poster.updateHitbox();

        poster.screenCenter();
    }

    public function updateDifficultyPanel(cancelFadeIn:Bool = false):Void
    {
        tweens.cancelTweensOf(difficultyPanel);

        if (cancelFadeIn)
        {
            difficultyPanel.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/panels/diff-${Difficulty.list[selectedDifficulty].toLowerCase()}'));

            difficultyPanel.setPosition(difficultyPanel.getCenterX(), -difficultyPanel.height);
        }
        else
        {
            tweens.tween(difficultyPanel, {y: -difficultyPanel.height}, 0.25, {ease: FlxEase.backOut, onComplete: (_:FlxTween) ->
            {
                difficultyPanel.loadGraphic(AssetCache.getGraphic('menus/FreeplayScreen/panels/diff-${Difficulty.list[selectedDifficulty].toLowerCase()}'));
            }});
        }

        tweens.tween(difficultyPanel, {y: -15.0}, 0.25, {ease: FlxEase.backOut, startDelay: cancelFadeIn ? 0.0 : 0.25});

        FlxG.sound.play(AssetCache.getSound("shared/swinging-lock"));
    }

    public function processSearchStatus(status:SearchStatus, result:Array<LevelData>, search:String, lastSearch:String):Void
    {
        if (status == SUCCESS)
        {
            levels = result;

            var isEmpty:Bool = searchItem.isEmpty();

            if (isEmpty)
                selectedLevel = getLastSelectedLevel();
            else
                selectedLevel = 0;

            changeSelection(0);

            scrollBg(Y, !isEmpty);
        }
        else
            FlxG.sound.play(AssetCache.getSound("shared/portal-poster-error"));
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }

    public function getLastSelectedLevel():Int
    {
        return lastSelectedLevel.exists(selectedDifficulty) ? lastSelectedLevel[selectedDifficulty] : 0;
    }

    public function setLastSelectedLevel():Void
    {
        lastSelectedLevel[selectedDifficulty] = selectedLevel;
    }

    public function clickLeftDifficulty():Void
    {
        if (!scrollBgV.animation.finished)
            return;

        changeDifficulty(-1);

        scrollBg(Y);
    }

    public function clickRightDifficulty():Void
    {
        if (!scrollBgV.animation.finished)
            return;

        changeDifficulty(1);

        scrollBg(Y, true);
    }

    public function clickLeftLevel():Void
    {
        if (isScrolling)
            return;

        changeSelection(-1);

        scrollBg(X, true);
    }

    public function clickRightLevel():Void
    {
        if (isScrolling)
            return;

        changeSelection(1);

        scrollBg(X);
    }

    public function addHeightenedButton(text:String, size:ButtonSize, onClick:()->Void):HeightenedButton
    {
        var button:HeightenedButton = new HeightenedButton(0.0, 0.0, text, size);

        button.onClick.add(onClick);

        add(button);

        return button;
    }

    public function clickExitButton():Void
    {
        FlxG.switchState(() -> new ModeSelectScreen());
    }

    public function clickPlayButton():Void
    {
        if (isScrolling)
            return;
        
        if (searchItem.text != searchItem.lastSearch && searchItem.text.length != 0.0)
        {
            searchItem.forceSearch();

            return;
        }

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

    public function clickInfoButton():Void
    {
        if (isScrolling)
            return;

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

        openSubState(new LevelInfoScreen(level));
    }
}

class SearchItem<T> extends FlxInputText
{
    public var lastSearch:String;

    public var getSearchData:()->Array<T>;

    public var onSearchComplete:FlxTypedSignal<(status:SearchStatus, result:Array<T>, search:String, lastSearch:String)->Void>;

    public var filterEReg:EReg;

    public var icon:FlxSprite;

    public function new():Void
    {
        super(0.0, 0.0, FlxG.width, "", 32, FlxColor.BLACK, FlxColor.TRANSPARENT);

        font = Paths.font(Paths.ttf("Comic Sans MS"));

        bold = true;

        underline = true;

        alignment = CENTER;

        setBorderStyle(OUTLINE, FlxColor.WHITE, 2.0);

        filterMode = REG(~/[^a-zA-Z ]/g);

        forceCase = UPPER_CASE;

        multiline = false;

        selectionColor = 0x990074FF;

        useSelectedTextFormat = false;

        lastSearch = "";

        onSearchComplete = new FlxTypedSignal<(status:SearchStatus, result:Array<T>, search:String, lastSearch:String)->Void>();

        filterEReg = switch (filterMode:FlxInputTextFilterMode)
        {
            case REG(reg):
                reg;
            
            default:
                null;
        }

        icon = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/FreeplayScreen/search-glass"));
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (icon.exists && icon.active)
            icon.update(elapsed);
    }

    override function draw():Void
    {
        super.draw();

        if (icon.exists && icon.visible)
            icon.draw();
    }

    override function dispatchTypingAction(action:TypingAction):Void
    {
        var oldText:String = text;

        super.dispatchTypingAction(action);

        switch (action:TypingAction)
        {
            case ADD_TEXT(text):
            {
                if (editable)
                {
                    if (text == filterEReg.replace(text, ""))
                    {
                        updateIconVisible();

                        updateIconPosition();

                        FlxG.sound.play(AssetCache.getSound("shared/type"));
                    }
                }
            }

            case COMMAND(cmd):
            {
                if (editable)
                {
                    if (cmd == NEW_LINE)
                    {
                        if (editable)
                            forceSearch();
                    }

                    if (cmd == DELETE_LEFT || cmd == DELETE_RIGHT || cmd == CUT || cmd == PASTE)
                    {
                        if (cmd == CUT || cmd == PASTE)
                        {
                            if (cmd == PASTE)
                            {
                                var clipboardText:String = Clipboard.generalClipboard.getData(TEXT_FORMAT);

                                var safeText:String = filterEReg.replace(clipboardText, "");

                                if (clipboardText != null && safeText.length > 0.0)
                                {
                                    updateIconVisible();

                                    updateIconPosition();

                                    FlxG.sound.play(AssetCache.getSound("shared/type"));
                                }
                            }
                            else
                                updateIconPosition();
                        }

                        if (cmd == DELETE_LEFT || cmd == DELETE_RIGHT)
                        {
                            updateIconVisible();

                            updateIconPosition();

                            var playSound:Bool = true;

                            if (oldText.length == 0.0)
                                playSound = false;

                            if (caretIndex == 0.0 && cmd == DELETE_LEFT)
                                playSound == false;

                            if (caretIndex == text.length + 1 && cmd == DELETE_RIGHT)
                                playSound = false;

                            if (playSound)
                                FlxG.sound.play(AssetCache.getSound("shared/type"));
                        }
                    }
                }
            }

            default:
        }
    }

    override function updateSelectionBoxes():Void
    {
        super.updateSelectionBoxes();

        for (v in _selectionBoxes)
            v.alpha = v.color.alphaFloat;
    }

    override function destroy():Void
    {
        super.destroy();

        onSearchComplete = cast FlxDestroyUtil.destroy(onSearchComplete);

        icon.destroy();
    }

    public function forceSearch():Void
    {
        var status:SearchStatus = SUCCESS;
        
        if (text == lastSearch)
        {
            status = FAIL;

            onSearchComplete.dispatch(status, null, text, lastSearch);

            return;
        }

        var result:Array<T> = getSearchData();

        if (result.length == 0.0)
            status = FAIL;

        var lastSearch:String = this.lastSearch;

        if (status == SUCCESS)
        {
            this.lastSearch = text;

            endFocus();
        }

        updateIconVisible();

        onSearchComplete.dispatch(status, result, text, lastSearch);
    }

    public function emptySearch():Void
    {
        text = "";

        updateIconPosition();

        updateIconVisible();
    }

    public function isEmpty():Bool
    {
        return text.length == 0.0;
    }

    public function updateIconVisible():Void
    {
        icon.visible = text.length == 0.0 || text != lastSearch;
    }

    public function updateIconPosition():Void
    {
        if (text.length == 0.0)
        {
            icon.centerTo(this);

            return;
        }

        var boundaries:Rectangle = getCharBoundaries(text.length - 1);

        icon.setPosition(boundaries.x + boundaries.width, icon.getCenterY(this));
    }
}

enum SearchStatus
{
    SUCCESS;

    FAIL;
}