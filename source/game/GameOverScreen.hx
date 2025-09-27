package game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.tweens.FlxTween;

import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

import core.AssetCache;

import data.CharacterData;
import data.Difficulty;
import data.LevelData;
import data.WeekData;

import extendable.TransitionState;

import interfaces.ISequenceHandler;

import menus.FreeplayScreen;
import menus.MysteryScreen;
import menus.StoryMenuScreen;
import menus.TitleScreen;

import util.ClickSoundUtil;

using util.ArrayUtil;
using util.MathUtil;

class GameOverScreen extends FlxSubState implements ISequenceHandler
{
    public var game:PlayState;

    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;
    
    public var player:Character;

    public var dead:FlxSound;

    public var rollSprite:FlxSprite;

    public var rollSound:FlxSound;

    public var rollTimer:FlxTimer;

    public var retryButton:FlxSprite;

    public var canSkip:Bool;

    public var canRetry:Bool;

    public function new(game:PlayState):Void
    {
        super();

        this.game = game;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.last();

        camera.zoom = 0.75;

        tweens = new FlxTweenManager();

        add(tweens);

        timers = new FlxTimerManager();

        add(timers);

        player = new Character(null, 0.0, 0.0, Character.getConfig(game.player.deathCharacter));

        player.dance();

        player.screenCenter();

        add(player);

        var split:Array<String> = player.config.name.split("-");

        split.pop();

        dead = FlxG.sound.load(AssetCache.getSound('game/GameOverScreen/dead-${split.join("-")}'));

        dead.onComplete = showImages;

        dead.play();

        rollTimer = new FlxTimer(timers);

        retryButton = new FlxSprite(0.0, 0.0);

        retryButton.visible = false;

        retryButton.loadGraphic(AssetCache.getGraphic('game/GameOverScreen/retryButton'), true, 128, 66);

        retryButton.animation.add("0", [0], 0.0, false);

        retryButton.animation.add("1", [1], 0.0, false);

        retryButton.animation.play("0");

        retryButton.scale.set(2.5, 2.5);

        retryButton.updateHitbox();

        retryButton.setPosition(retryButton.getCenterX(), FlxG.height - retryButton.height + 50.0);

        add(retryButton);

        canSkip = false;

        canRetry = false;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (canSkip)
        {
            if (FlxG.keys.justPressed.ESCAPE)
            {
                var nextState:NextState = game.params?.nextState;

                if (PlayState.isWeek)
                {
                    nextState ??= () -> new StoryMenuScreen();

                    var weeks:Array<WeekData> = WeekData.list;

                    var weekToSearch:WeekData = weeks.first((w:WeekData) -> w.name == PlayState.week.name);

                    StoryMenuScreen.selectedDifficulty = Difficulty.list.indexOf(PlayState.level.difficulty);

                    StoryMenuScreen.selectedWeek = weeks.indexOf(weekToSearch);
                }
                else
                {
                    var level:LevelData = PlayState.level;

                    if (level.obscurity == NONE)
                        nextState ??= () -> new FreeplayScreen();
                    else
                    {
                        nextState ??= () -> new MysteryScreen();

                        var filtered:Array<LevelData> = LevelData.list.filter((lv:LevelData) -> lv.obscurity != NONE);

                        MysteryScreen.curSelected = filtered.indexOf(level);
                    }
                }

                FlxG.switchState(nextState);
            }

            if (FlxG.keys.justPressed.ENTER && !rollTimer.finished)
            {
                skipShowcase(true);

                return;
            }
        }

        if (canRetry)
        {
            if (FlxG.mouse.overlaps(retryButton, camera))
            {
                retryButton.animation.play("1");

                if (FlxG.mouse.justReleased)
                {
                    ClickSoundUtil.play();
                    
                    tweens.tween(retryButton, {alpha: 0.0}, 0.5);

                    canRetry = false;

                    new FlxTimer(timers).start(2.5, (_timer:FlxTimer) -> FlxG.resetState());

                    FlxG.sound.play(AssetCache.getSound("game/GameOverScreen/confirm"), 0.5, false, null, true);
                }
            }
            else
                retryButton.animation.play("0");
        }
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function showImages():Void
    {
        camera.zoom = 1.0;

        player.visible = false;

        var rollIndex:Int = 0;

        var totalRolls:Int = 0;

        rollSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic('game/GameOverScreen/${rollIndex}'));

        rollSprite.scale.set(2.0, 2.0);

        rollSprite.updateHitbox();

        rollSprite.screenCenter();

        add(rollSprite);

        rollSound = FlxG.sound.load(AssetCache.getSound('game/GameOverScreen/${rollIndex}'));

        rollSound.play();

        var rollExclusions:Array<Int> = [0];

        rollTimer.start(0.125, (_rollTimer:FlxTimer) ->
        {
            if (rollTimer.loopsLeft == 1.0)
            {
                var sequence:FlxSound = FlxG.sound.play(AssetCache.getSound("game/GameOverScreen/suspence"), 1.0, false, null, true);

                rollTimer.time = sequence.length * 0.001;
            }
            else
            {
                if (rollTimer.loopsLeft == 0.0)
                    skipShowcase();
                else
                    rollTimer.time += 0.01;
            }

            if (rollTimer.loopsLeft != 0.0)
            {
                rollIndex = FlxMath.wrap(rollIndex + 1, 0, 4);

                rollExclusions[0] = rollIndex;

                totalRolls++;
            }

            if (rollSprite.exists)
            {
                rollSprite.loadGraphic(AssetCache.getGraphic
                    ('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : FlxG.random.int(0, 4, rollExclusions)}'));

                rollSprite.updateHitbox();

                rollSound.loadEmbedded(AssetCache.getSound('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : 5.0}'));

                rollSound.play();
            }
        }, 35);

        canSkip = true;
    }

    public function skipShowcase(skipTimer:Bool = false):Void
    {
        camera.zoom = 0.75;

        if (skipTimer)
        {
            @:privateAccess
            {
                rollTimer._loopsCounter = rollTimer.loops;

                rollTimer._timeCounter = rollTimer.time;
            }
        }
        else
        {
            var chance:Int = 1;

            if (PlayState.isWeek)
                chance = -1;

            if (PlayState.level.obscurity != NONE)
                chance = -1;

            var scoresValidated:Bool = #if debug true #else HighScore.getWeekScore(WeekData.list[0].name, "Normal").score != 0.0 &&
                HighScore.getLevelScore("Overseer", "Normal").score == 0.0 #end ;

            if (!scoresValidated)
                chance = -1;

            var oddsValidated:Bool = FlxG.random.int(1, 9) == chance;

            if (oddsValidated)
            {
                secretSequence();

                rollSprite.kill();

                return;
            }
        }

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        retryButton.visible = true;

        canRetry = true;

        FlxG.sound.play(AssetCache.getSound("game/GameOverScreen/whistle"), 1.0, false, null, true);
    }

    public function secretSequence():Void
    {
        camera.zoom = 1.0;

        var opponent:Character = new Character(null, 0.0, 0.0, Character.getConfig("overseer-99"));

        opponent.scale.set(0.85, 0.85);

        opponent.updateHitbox();

        opponent.screenCenter();

        add(opponent);

        new FlxTimer(timers).start(9.9, (_:FlxTimer) ->
        {
            TransitionState.cancelNextTransition();

            PlayState.loadLevel(LevelData.list.first((lv:LevelData) -> lv.name == "Overseer"));
        });
    }
}