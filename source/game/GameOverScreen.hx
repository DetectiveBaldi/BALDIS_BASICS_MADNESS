package game;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.Assets;
import core.Paths;

import data.CharacterData;

import extendable.ResourceSubState;

import menus.TitleScreen;

class GameOverScreen extends ResourceSubState
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

        player = new Character(null, 0.0, 0.0, CharacterData.get("bf-dead0"));

        player.dance();

        player.screenCenter();

        add(player);

        dead = FlxG.sound.load(Assets.getSound(Paths.sound(Paths.ogg("game/GameOverScreen/dead")), false));

        dead.onComplete = showImages;

        dead.play();

        rollTimer = new FlxTimer(timer);

        retryButton = new FlxSprite(0.0, 0.0);

        retryButton.visible = false;

        retryButton.loadGraphic(Assets.getGraphic(Paths.image(Paths.png('game/GameOverScreen/retryButton'))), true, 128, 66);

        retryButton.animation.add("0", [0], 0.0, false);

        retryButton.animation.add("1", [1], 0.0, false);

        retryButton.animation.play("0");

        retryButton.scale.set(2.5, 2.5);

        retryButton.updateHitbox();

        retryButton.setPosition((FlxG.width - retryButton.width) * 0.5, FlxG.height - retryButton.height + 50.0);

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
                FlxG.switchState(() -> new TitleScreen());

            if (FlxG.keys.justPressed.ENTER && !rollTimer.finished)
            {
                skipShowcase(true);

                return;
            }
        }

        if (canRetry)
        {
            if (FlxG.mouse.overlaps(retryButton))
            {
                retryButton.animation.play("1");

                if (FlxG.mouse.justPressed)
                {
                    tween.tween(retryButton, {alpha: 0.0}, 0.5);

                    canRetry = false;

                    new FlxTimer(timer).start(2.5, (_timer:FlxTimer) -> FlxG.resetState());

                    FlxG.sound.play(Assets.getSound(Paths.sound(Paths.ogg("game/GameOverScreen/confirm")), false), 0.5, false, null, true);
                }
            }
            else
                retryButton.animation.play("0");
        }
    }

    public function showImages():Void
    {
        var rollIndex:Int = 0;

        var rollSprite:FlxSprite = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png('game/GameOverScreen/${rollIndex}'))));

        rollSprite.scale.set(2.0, 2.0);

        rollSprite.updateHitbox();

        rollSprite.screenCenter();

        add(rollSprite);

        var rollSound:FlxSound = FlxG.sound.load(Assets.getSound(Paths.sound(Paths.ogg('game/GameOverScreen/${rollIndex}')), false));

        rollSound.play();

        rollTimer.start(0.125, (_rollTimer:FlxTimer) ->
        {
            if (rollTimer.loopsLeft == 1.0)
            {
                var sequence:FlxSound = FlxG.sound.play(Assets.getSound(Paths.sound(Paths.ogg("game/GameOverScreen/suspence")), false),
                    1.0, false, null, true);

                rollTimer.time = sequence.length * 0.001;
            }
            else
                if (rollTimer.loopsLeft == 0.0)
                    skipShowcase(false);
                else
                    rollTimer.time += 0.01;

            if (rollTimer.loopsLeft != 0.0)
                rollIndex = FlxMath.wrap(rollIndex + 1, 0, 4);

            rollSprite.loadGraphic(Assets.getGraphic(Paths.image(Paths.png('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : FlxG.random.int(0, 4, [rollIndex])}'))));

            rollSprite.updateHitbox();

            rollSound.loadEmbedded(Assets.getSound(Paths.sound(Paths.ogg('game/GameOverScreen/${rollTimer.loopsLeft > 0.0 ? rollIndex : 5.0}')), false));

            rollSound.play();
        }, 35);

        canSkip = true;
    }

    public function skipShowcase(skipTimer:Bool):Void
    {
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

        FlxG.sound.play(Assets.getSound(Paths.sound(Paths.ogg("game/GameOverScreen/whistle")), false), 1.0, false, null, true);
    }
}