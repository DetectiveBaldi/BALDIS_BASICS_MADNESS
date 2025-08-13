package game;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.util.FlxTimer;

import core.AssetCache;

import data.CharacterData;

import extendable.CustomSubState;

import menus.FreeplayScreen;
import menus.StoryMenuScreen;

using util.ArrayUtil;
using util.MathUtil;

class GameOverScreen extends CustomSubState
{
    public var player:Character;

    public var dead:FlxSound;

    public var rollTimer:FlxTimer;

    public var retryButton:FlxSprite;

    public var canSkip:Bool;

    public var canRetry:Bool;

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.last();

        camera.zoom = 0.75;

        player = new Character(null, 0.0, 0.0, Character.getConfig("bf-dead"));

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
                FlxG.switchState(PlayState.isWeek ? () -> new StoryMenuScreen() : () -> new FreeplayScreen());

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

                if (FlxG.mouse.justPressed)
                {
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
        var rollIndex:Int = 0;

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
                    skipShowcase(false);
                else
                    rollTimer.time += 0.01;

            if (rollTimer.loopsLeft != 0.0)
                rollIndex = FlxMath.wrap(rollIndex + 1, 0, 4);

            rollSprite.loadGraphic(AssetCache.getGraphic
                ('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : FlxG.random.int(0, 4, [rollIndex])}'));

            rollSprite.updateHitbox();

            rollSound.loadEmbedded(AssetCache.getSound('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : 5.0}'));

            rollSound.play();
        }, 35);

        canSkip = true;
    }

    public function skipShowcase(skipTimer:Bool):Void
    {
        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

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
}