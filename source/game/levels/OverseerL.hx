package game.levels;

import openfl.filters.BitmapFilter;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.animation.FlxAnimation;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import flixel.addons.display.FlxBackdrop; 

import core.AssetCache;
import core.Options;
import core.Paths;

import data.CharacterData;

import extendable.CustomSubState;

import game.stages.OverseerS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class OverseerL extends PlayState
{
    public var overseerS:OverseerS;

    public var scissors:FlxSprite;

    public var fidgetSpinner:FlxSprite;

    public var glassesCap:FlxSprite;

    public var musicBox:FlxSprite;

    override function create():Void
    {
        stage = new OverseerS();

        overseerS = cast (stage, OverseerS);

        super.create();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCamBopStrength = 0.0;

        hudCamBopStrength = 0.0;

        player.visible = false;

        overseerS.redstatic.visible = false;

        overseerS.ninenine.visible = false;
        overseerS.ninenine.alpha = 0.15;

        opponent.scale.set(0.85, 0.85);
        opponent.updateHitbox();
        opponent.screenCenter();

        countdown.skip();

        canPause = false;

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.25;
        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
            playField.timerNeedle.visible = false;

        playField.strumlines.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 64)
        {
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = true;

            playField.strumlines.visible = true;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 192)
        {
            gameCamBopStrength = 0.03;

            hudCamBopStrength = 0.03;
        }

        if (step == 448)
            gameCamBopStrength = 0.06;

        if (step == 704)
        {
            overseerS.redstatic.alpha = 1.0;
            tween.tween(overseerS.redstatic, {alpha: 0.1}, conductor.beatLength * 8 * 0.001, {ease: FlxEase.quartOut});

            opponent.color = 0xFF0000;

            gameCamBopStrength = 0.03;
        }

        if (step == 816)
        {
            tween.tween(overseerS.redstatic, {alpha: 0.8}, conductor.beatLength * 4 * 0.001, {ease: FlxEase.quadIn});
        }

        if (step == 832)
            opponent.color = 0xFFFFFF;

        if (step == 704 || step == 832 || step == 1856)
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

        if (step == 1152 || step == 1280 || step == 1536 || step == 1664)
            gameCameraZoom += 0.15;

        if (step == 1160 || step == 1288 || step == 1544 || step == 1672)
            gameCameraZoom -= 0.15;

        if (step == 1344)
        {
            overseerS.redstatic.alpha = 1.0;
            overseerS.redstatic.animation.play("0");
            tween.tween(overseerS.redstatic, {alpha: 0.2}, conductor.beatLength * 4 * 0.001, {ease: FlxEase.quadOut});

            overseerS.ninenine.visible = true;
            overseerS.ninenine.velocity.set(-100.0, -100.0);
        }

        if (step == 1856)
        {
            overseerS.redstatic.alpha = 1.0;
            tween.tween(overseerS.redstatic, {alpha: 0.2}, conductor.beatLength * 8 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 8 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 8 * 0.001, {ease: FlxEase.quartIn});

            opponent.color = 0xFF0000;

            overseerS.ninenine.visible = false;
        }

        if (step == 2000 || step == 2032 || step == 2064 || step == 2096 || step == 2128 || step == 2160)
        {
            overseerS.redstatic.visible = false;

            opponent.color = 0xFFFFFF;
        }

        if (step == 2008 || step == 2040 || step == 2072 || step == 2104 || step == 2136 || step == 2168 ||
            step == 2200 || step == 2232 || step == 2264 || step == 2296 || step == 2328)
        {
            opponent.color = 0xFF0000;

            opponent.visible = true;

            overseerS.redstatic.visible = true;

            opponent.animation.play("sreturn");

            opponent.screenCenter();
        }

        if (step == 2132 || step == 2134 || step == 2164 || step == 2192 || step == 2196 || step == 2198 ||
            step == 2224 || step == 2228 || step == 2230)
        {
            opponent.color = 0xFF0000;
            overseerS.redstatic.visible = false;
        }

        if (step == 2133 || step == 2135 || step == 2195 || step == 2197 || step == 2199 || step == 2227 ||
            step == 2229 || step == 2256 || step == 2288 || step == 2320)
        {
            opponent.color = 0x000000;
            overseerS.redstatic.visible = false;
        }

        if (step == 1995 || step == 2123)
        {
            opponent.animation.play("sscissors");
            opponent.screenCenter();
            opponent.skipDance = true;
        }

        if (step == 2027 || step == 2155)
        {
            opponent.animation.play("sfidget");
            opponent.screenCenter();
            opponent.skipDance = true;
        }

        if (step == 2059 || step == 2187)
        {
            opponent.animation.play("sglasses");
            opponent.screenCenter();
            opponent.skipDance = true;
        }

        if (step == 2091 || step == 2219)
        {
            opponent.animation.play("smusic");
            opponent.screenCenter();
            opponent.skipDance = true;
        }

        if (step == 2256)
        {
            var oppAnim:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("overseer-ref"));
            oppAnim.setPosition(400.0, 100.0);
            oppAnim.skipDance = true;
            oppAnim.animation.play("dclosed");
            opponents.add(oppAnim);
        }
        
        if (step == 2258)
        {
            var oppAnim:Character = getOpponent("overseer-ref");
            oppAnim.animation.play("dopen");
        }

        if (step == 2260)
        {
            var oppAnim:Character = getOpponent("overseer-ref");
            oppAnim.animation.play("dglitch");
        }

        if (step == 2288)
        {
            var oppAnim:Character = getOpponent("overseer-ref");
            oppAnim.animation.play("nidle");
        }

        if (step == 2292)
        {
            var oppAnim:Character = getOpponent("overseer-ref");
            oppAnim.animation.play("nnine");
        }

        if (step == 2320)
        {
            var oppAnim:Character = getOpponent("overseer-ref");
            oppAnim.animation.play("bidle");
        }

        if (step == 2256 || step == 2288 || step == 2320)
        {
            gameCamBopStrength = 0.0;

            hudCamBopStrength = 0.0;

            var opp:Character = getOpponent("overseer-99");
            opp.visible = false;

            var oppAnim:Character = getOpponent("overseer-ref");
            oppAnim.visible = true;
        }

        if (step == 2264 || step == 2296 || step == 2328)
        {
            var oppAnim:Character = getOpponent("overseer-ref");
            oppAnim.visible = false;
        }

        if (step == 2336)
        {
            tween.tween(overseerS.redstatic, {alpha: 0.6}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadIn});

            tween.tween(this, {gameCameraZoom: 1.5}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 2352)
            FlxG.camera.visible = false;

        if (step == 2368)
        {
            FlxG.camera.visible = true;

            gameCameraZoom = 1.2;

            gameCamBopStrength = 0.06;

            hudCamBopStrength = 0.03;
            
            tween.tween(overseerS.redstatic, {alpha: 0.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quadOut});

            oppStrumline.strums.alpha = 0.25;

            plrStrumline.strums.alpha = 1.0;
        }

        if (step == 2376)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCameraZoom = 1.0;
        }

        if (step == 2512 || step == 2518 || step == 2524 || step == 2640 || step == 2646 || step == 2652 ||
            step == 2768 || step == 2774 || step == 2780)
            gameCameraZoom += 0.1;
            
        if (step == 2528 || step == 2656 || step == 2784)
            gameCameraZoom = 1.0;

        if (step == 2864)
        {
            gameCameraZoom = 1.3;

            tween.tween(opponent, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 2880)
        {
            overseerS.redstatic.visible = false;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = false;

            playField.strumlines.visible = false;

            scissors = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/GameOverScreen/4"));
            scissors.scale.set(1.0, 1.0);
            scissors.camera = gameCamera;
            scissors.screenCenter();
            scissors.alpha = 0.35;
            add(scissors);
        }

        if (step == 2912)
        {
            scissors.visible = false;
            fidgetSpinner = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/GameOverScreen/3"));
            fidgetSpinner.scale.set(1.0, 1.0);
            fidgetSpinner.camera = gameCamera;
            fidgetSpinner.screenCenter();
            fidgetSpinner.alpha = 0.35;
            add(fidgetSpinner);
        }

        if (step == 2944)
        {
            fidgetSpinner.visible = false;
            glassesCap = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/GameOverScreen/2"));
            glassesCap.scale.set(1.0, 1.0);
            glassesCap.camera = gameCamera;
            glassesCap.screenCenter();
            glassesCap.alpha = 0.35;
            add(glassesCap);
        }

        if (step == 2976)
        {
            glassesCap.visible = false;
            musicBox = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/GameOverScreen/1"));
            musicBox.scale.set(1.0, 1.0);
            musicBox.camera = gameCamera;
            musicBox.screenCenter();
            musicBox.alpha = 0.35;
            add(musicBox);
        }

        if (step == 3104)
            tween.tween(musicBox, {alpha: 0.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quadIn});

        if (step == 3136 || step == 3148 || step == 3156)
        {
            overseerS.redstatic.visible = true;
            overseerS.redstatic.alpha = 0.6;
            tween.tween(overseerS.redstatic, {alpha: 0.0}, conductor.beatLength * 1.8 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 3160)
        {
            tween.tween(overseerS.redstatic, {alpha: 1.0}, conductor.beatLength * 3.0 * 0.001, {ease: FlxEase.quadIn});

            tween.tween(opponent, {alpha: 1.0}, conductor.beatLength * 3.0 * 0.001, {ease: FlxEase.quadIn});
        }

        if (step == 3168)
        {
            overseerS.redstatic.alpha = 1.0;

            opponent.scale.set(1.9, 1.9);

            opponent.updateHitbox();
        }

        if (step == 3216)
            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 4.0 * 0.001);
    }

    override function beatHit(beat:Int):Void
    {
        if (beat >= 48 && beat < 110)
        {
            if (beat % 2 == 0)
            {
                overseerS.redstatic.visible = true;
                overseerS.redstatic.alpha = 0.35;
                overseerS.redstatic.animation.play("0");
                tween.tween(overseerS.redstatic, {alpha: 0.0}, conductor.beatLength * 1.9 * 0.001, {ease: FlxEase.quadOut});
            }
        }

        if (beat >= 112 && beat < 176)
        {
            if (beat % 2 == 0)
            {
                overseerS.redstatic.visible = true;
                overseerS.redstatic.alpha = 0.35;
                overseerS.redstatic.animation.play("0");
                tween.tween(overseerS.redstatic, {alpha: 0.0}, conductor.beatLength * 1.9 * 0.001, {ease: FlxEase.quadOut});
            }

            if (beat % 4 == 0)
            {
                opponent.colorTransform.setOffsets(155, 0, 0, 155);
                tween.tween(opponent.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 0.0},
                conductor.beatLength * 3.0 * 0.001);
            }
        }

        if (beat >= 208 && beat < 336)
        {
            if (beat % 4 == 0)
            {
                overseerS.redstatic.visible = true;
                overseerS.redstatic.alpha = 0.15;
                overseerS.redstatic.animation.play("0");
                tween.tween(overseerS.redstatic, {alpha: 0.0}, conductor.beatLength * 1.9 * 0.001, {ease: FlxEase.quadOut});
            }
        }

        if (beat >= 596 && beat < 716)
        {
            if (beat % 2 == 0)
            {
                overseerS.redstatic.visible = true;
                overseerS.redstatic.alpha = 0.35;
                overseerS.redstatic.animation.play("0");
                tween.tween(overseerS.redstatic, {alpha: 0.0}, conductor.beatLength * 1.9 * 0.001, {ease: FlxEase.quadOut});
            }

            if (beat % 4 == 0)
            {
                opponent.colorTransform.setOffsets(155, 0, 0, 155);
                tween.tween(opponent.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 0.0},
                conductor.beatLength * 3.0 * 0.001);
            }
        }
    }

    override function gameOver():Void
    {
        persistentDraw = false;

        openSubState(new OverseerGameOverScreen());

        pauseMusic();
    }
}

class OverseerGameOverScreen extends CustomSubState
{
    public function new():Void
    {
        super();

        var opponent:Character = new Character(null, 0.0, 0.0, Character.getConfig("overseer-99"));

        opponent.scale.set(0.85, 0.85);

        opponent.updateHitbox();

        opponent.screenCenter();

        add(opponent);

        new FlxTimer(timer).start(5.0, (_:FlxTimer) ->
        {
            opponent.color = FlxColor.RED;
            
            opponent.scale.set(1.9, 1.9);

            opponent.updateHitbox();

            var no:FlxSound = FlxG.sound.load(AssetCache.getSound("shared/oh-no"), 1.0, true);

            no.play();

            new FlxTimer(timer).start(5.0, (_:FlxTimer) -> Sys.exit(0));
        });
    }
}