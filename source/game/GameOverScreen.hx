package game;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

import core.AssetCache;

import data.CharacterData;
import data.LevelData;

import extendable.CustomState;
import extendable.CustomSubState;

import menus.FreeplayScreen;
import menus.StoryMenuScreen;
import menus.TitleScreen;

import util.ClickSoundUtil;

using util.ArrayUtil;
using util.MathUtil;

class GameOverScreen extends CustomSubState
{
    public var game:PlayState;

    public var characterToShow:String;

    public var player:Character;

    public var dead:FlxSound;

    public var rollTimer:FlxTimer;

    public var retryButton:FlxSprite;

    public var canSkip:Bool;

    public var canRetry:Bool;

    public function new(game:PlayState, characterToShow:String = "bf-dead"):Void
    {
        super();

        this.game = game;

        this.characterToShow = characterToShow;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.last();

        camera.zoom = 0.75;

        player = new Character(null, 0.0, 0.0, Character.getConfig(characterToShow));

        player.dance();

        player.screenCenter();

        add(player);

        dead = FlxG.sound.load(AssetCache.getSound("game/GameOverScreen/dead"));

        dead.onComplete = showImages;

        dead.play();

        rollTimer = new FlxTimer(timer);

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
                var stateToSwitchTo:NextState = () -> new FreeplayScreen();

                if (PlayState.isWeek)
                    stateToSwitchTo = () -> new StoryMenuScreen();

                FlxG.switchState(game.nextState ?? stateToSwitchTo);
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
                    ClickSoundUtil.playSound();
                    
                    tween.tween(retryButton, {alpha: 0.0}, 0.5);

                    canRetry = false;

                    new FlxTimer(timer).start(2.5, (_timer:FlxTimer) -> FlxG.resetState());

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

        var rollIndex:Int = 0;

        var totalRolls:Int = 0;

        var rollSprite:FlxSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic('game/GameOverScreen/${rollIndex}'));

        rollSprite.scale.set(2.0, 2.0);

        rollSprite.updateHitbox();

        rollSprite.screenCenter();

        add(rollSprite);

        var rollSound:FlxSound = FlxG.sound.load(AssetCache.getSound('game/GameOverScreen/${rollIndex}'));

        rollSound.play();

        rollTimer.start(0.125, (_rollTimer:FlxTimer) ->
        {
            if (rollTimer.loopsLeft == 1.0)
            {
                var sequence:FlxSound = FlxG.sound.play(AssetCache.getSound("game/GameOverScreen/suspence"), 1.0, false, null, true);

                rollTimer.time = sequence.length * 0.001;
            }
            else
                if (rollTimer.loopsLeft == 0.0)
                    skipShowcase();
                else
                    rollTimer.time += 0.01;

            if (rollTimer.loopsLeft != 0.0)
            {
                rollIndex = FlxMath.wrap(rollIndex + 1, 0, 4);

                totalRolls++;

                var chance:Int = #if debug 3 #else 99 #end ; 

                if (totalRolls < 24.0)
                    chance = -1;

                if (#if debug false #else HighScore.getLevelScore("Overseer", "normal").score != 0.0 #end)
                    chance = -1;

                if (PlayState.level.showInMysteryMenu)
                    chance = -1;

                if (FlxG.random.int(1, Std.int(Math.abs(chance))) == chance)
                {
                    rollTimer.cancel();

                    rollSprite.kill();

                    secretSequence();

                    return;
                }
            }

            rollSprite.loadGraphic(AssetCache.getGraphic
                ('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : FlxG.random.int(0, 4, [rollIndex])}'));

            rollSprite.updateHitbox();

            rollSound.loadEmbedded(AssetCache.getSound('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : 5.0}'));

            rollSound.play();
        }, 35);

        canSkip = true;
    }

    public function skipShowcase(skipTimer:Bool = false):Void
    {
        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        camera.zoom = 0.75;

        if (skipTimer)
        {
            @:privateAccess
            {
                rollTimer._loopsCounter = rollTimer.loops;

                rollTimer._timeCounter = rollTimer.time;
            }
        }

        retryButton.visible = true;

        canRetry = true;

        FlxG.sound.play(AssetCache.getSound("game/GameOverScreen/whistle"), 1.0, false, null, true);
    }

    public function secretSequence():Void
    {
        CustomState.cancelNextTransition();

        var character:Character = new Character(null, 0.0, 0.0, Character.getConfig("overseer-99"));

        character.setPosition(590.0, 300.0);

        character.scale.set(0.85, 0.85);

        add(character);

        new FlxTimer(timer).start(9.0, (_:FlxTimer) ->
        {
            var levelToLoad:LevelData = LevelData.list.first((lv:LevelData) -> lv.name == "Overseer");
        
            PlayState.loadLevel(levelToLoad, () -> new TitleScreen());
        });
    }
}