package game.levels.classicw;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.animation.FlxAnimation;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.EssentialES;

using flixel.util.FlxColorTransformUtil;

using util.MathUtil;

using StringTools;

class EssentialEL extends PlayState
{
    public var essentialES:EssentialES;

    public var temperature:FlxSprite;

    public var win:FlxSprite;

    override function create():Void
    {
        stage = new EssentialES();

        essentialES = cast (stage, EssentialES);

        super.create();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.color = FlxColor.BLACK;

        gameCameraZoom = 1.5;

        essentialES.exit0.visible = true;

        plrStrumline.botplay = true;

        var opp:Character = getOpponent("baldi-mad-face-front");
        opp.scale.set(1.4, 1.4);
        opp.updateHitbox();
        opp.setPosition(-240.0, 200.0);

        var plr:Character = getPlayer("bf-face-back-left");
        plr.scale.set(6.0, 6.0);
        plr.updateHitbox();
        plr.setPosition(1600.0, -250.0);

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
            playField.timerNeedle.visible = false;

        playField.strumlines.visible = false;

        temperature = new FlxSprite();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 16.0 * 0.001, true);

            tweens.tween(this, {gameCameraZoom: 0.6}, conductor.beatLength * 16.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 64)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            tweens.tween(player, {x: 550.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = true;

            playField.strumlines.visible = true;

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 320)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            essentialES.exit0.visible = false;
            essentialES.exit1.visible = true;

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 336.0)
        {
            plrStrumline.botplay = true;

            plrStrumline.resetStrums();
        }

        if (step == 384 || step == 394 || step == 396)
        {
            essentialES.exit1.color = 0xF19999;

            gameCameraZoom += 0.05;
        }

        if (step == 392 || step == 395)
            essentialES.exit1.color = 0xFFFFFF;

        if (step == 384)
        {
            tweens.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});

            tweens.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});

            plrStrumline.botplay = Options.botplay;

            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFFD8D8,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 400)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.visible = false;

            var _opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad"));

            _opp.skipDance = true;

            _opp.setPosition(-845.0, 18.5);

            opponents.add(_opp);

            opponent = _opp;

            var _plr:Character = getPlayer("bf-face-back-left");

            _plr.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-running"));

            var anim:FlxAnimation = plr.animation.getByName("dance");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            plr.setPosition(680.5, 185.0);

            players.add(plr);

            player = plr;

            var __plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("run-legs"));

            anim = __plr.animation.getByName("legs");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            anim = __plr.animation.getByName("legs miss");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            __plr.animation.play("legs", true);

            __plr.skipDance = true;

            __plr.skipSing = true;

            __plr.setPosition(plr.x, plr.y);

            players.insert(players.members.indexOf(plr), __plr);

            plr.animation.onFrameChange.add(updateLegStatus);

            tweens.tween(plr, {x: 785.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tweens.tween(__plr, {x: 785.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            essentialES.exit1.visible = false;
            essentialES.hall.visible = true;
        }

        if (step == 656 || step == 784 || step == 1680)
            cameraPoint.x = 500.0;

        if (step == 720 || step == 848)
            cameraPoint.x = 800.0;

        if (step == 656)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom += 0.1;

            essentialES.exit.visible = false;

            essentialES.exit.active = false;

            essentialES.exitClosed.visible = true;

            essentialES.exitClosed.velocity.x = -2800.0;

            essentialES.exitClosed.x = essentialES.exit.x;

            tweens.color(temperature, conductor.beatLength * 8.0 * 0.001, temperature.color, 0xFFFF8D8D,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 784)
            gameCameraZoom += 0.1;

        if (step == 788)
            gameCameraZoom -= 0.1;

        if (step == 908 || step == 652)
        {
            essentialES.exit.visible = true;

            essentialES.exit.velocity.x = -2400.0;

            essentialES.exit.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 912)
        {
            essentialES.exit.visible = false;

            essentialES.exit.active = false;

            essentialES.exitClosed2.visible = true;

            essentialES.exitClosed2.velocity.x = -2800.0;

            essentialES.exitClosed2.x = essentialES.exit.x;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            opponent.x = -845.0;

            gameCameraZoom -= 0.1;

            cameraPoint.centerTo();

            tweens.color(temperature, conductor.beatLength * 8.0 * 0.001, temperature.color, 0xFFFF4848,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1168)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            cameraPoint.x = 950.0;

            tweens.tween(this, {gameCameraZoom: 0.95}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1248)
        {
            tweens.tween(this.cameraPoint, {x: 500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(essentialES.hall.colorTransform, {redOffset: 155.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 155.0},
                conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1264)
        {
            var opp:Character = getOpponent("baldi-mad");
            opp.visible = false;

            var _opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad-glitch"));
            _opp.setPosition(-100.0, 18.5);
            opponents.add(_opp);
            opponent = _opp;

            updateHealthBar("opponent");
        }

        if (step == 1296)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFF0E0E,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            opponent.x = -880.0;

            cameraPoint.x = 950.0;
        }

        if (step == 1360)
            gameCameraZoom = 0.9;

        if (step == 1424)
        {
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            var opp:Character = getOpponent("baldi-mad-glitch");
            opp.visible = false;

            var _opp:Character = getOpponent("baldi-mad");
            _opp.visible = true;
            opponent = _opp;

            updateHealthBar("opponent");

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            tweens.tween(player, {x: 1800.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartIn});

            var _plr:Character = getPlayer("run-legs");

            tweens.tween(_plr, {x: 1800.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartIn});

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 7.9 * 0.001, false);
        }

        if (step == 1456)
        {
            gameCamera.color = FlxColor.RED;
            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 7.9 * 0.001, true);

            essentialES.hall.visible = false;
            essentialES.hall0.visible = true;

            cameraPoint.x = 500.0;

            oppStrumline.strums.alpha = 0.0;
            plrStrumline.strums.alpha = 0.0;
            plrStrumline.botplay = true;
            plrStrumline.resetStrums();

            opponent.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-zesty-essential"));
            plr.visible = true;
            plr.skipDance = true;
            plr.skipSing = true;
            plr.animation.play("rest");
            plr.setPosition(-680.0, 185.0);
            players.add(plr);
            player = plr;

            tweens.tween(plr, {x: 300.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1472)
            player.animation.play("leftlook");

        if (step == 1488)
            player.animation.play("rightlook");

        if (step == 1504)
            player.animation.play("check");

        if (step == 1520)
            player.animation.play("found");

        if (step == 1528)
        {
            player.animation.play("smirkleft");

            opponent.visible = true;

            opponent.x = -1200.0;
        }

        if (step == 1540)
            player.animation.play("eat");

        if (step == 1544)
        {
            tweens.tween(player, {x: 1600.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quadIn});

            tweens.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001);
            tweens.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001);

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 1546)
            player.animation.play("run");

        if (step == 1552)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            essentialES.hall.visible = true;
            essentialES.hall0.visible = false;

            opponent.x = -845.0;

            cameraPoint.x = 950.0;

            var __plr:Character = getPlayer("bf-zesty-essential");
            __plr.visible = false;

            var plr:Character = getPlayer("bf-running");
            plr.x = 480.5;
            player = plr;

            var _plr:Character = getPlayer("run-legs");
            _plr.x = player.x;

            tweens.tween(player, {x: 785.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tweens.tween(_plr, {x: 785.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 1792)
        {
            gameCameraZoom += 0.05;

            opponent.x = -800.0;
        }

        if (step == 1808)
        {
            cameraPoint.centerTo();

            gameCameraZoom -= 0.15;
        }

        if (step == 1820)
            getTransitionSprite(conductor.beatLength * 1.0 * 0.001, OUT, null);

        if (step == 1824)
        {
            getTransitionSprite(conductor.beatLength * 1.0 * 0.001, IN, null);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            player.visible = false;

            var plr:Character = getPlayer("run-legs");
            plr.visible = false;

            opponent.visible = false;

            essentialES.hall.visible = false;

            essentialES.cafeExit0.visible = true;
        }

        if (step == 1828)
            essentialES.cafeExit1.visible = true;

        if (step == 1832)
            essentialES.cafeExit2.visible = true;

        if (step == 1836)
            essentialES.cafeExit3.visible = true;

        if (step == 1840)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCamera.color = FlxColor.WHITE;

            essentialES.cafeExit0.visible = false;
            essentialES.cafeExit1.visible = false;
            essentialES.cafeExit2.visible = false;
            essentialES.cafeExit3.visible = false;

            oppStrumline.strums.alpha = 0.25;

            tweens.tween(plrStrumline.strums, {x: plrStrumline.strums.getCenterX()}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(oppStrumline.strums, {x: oppStrumline.strums.getCenterX()}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            hudCamBopStrength = 0.0;
            gameCamBopStrength = 0.0;

            win = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/win"));
            win.scale.set(2.5, 2.5);
            win.camera = gameCamera;
            win.screenCenter();
            insert(0, win);
        }

        if (step == 1856)
        {
            plrStrumline.botplay = true;

            canPause = false;
        }

        if (step == 1916)
        {
            gameCamera.visible = false;
            
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = false;

            playField.strumlines.visible = false;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 100.0 && beat <= 227.0)
        {
            if (beat % 2.0 == 1.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                if (beat == 227)
                {
                tweens.tween(opp, {x: opp.x + 830.0}, conductor.beatLength * 0.15 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 830.0}, 0.15);}});
                }
                else 
                {
                tweens.tween(opp, {x: opp.x + 830.0}, conductor.beatLength * 0.35 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 830.0}, 0.5);}});
                }

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 228.0 && beat <= 315.0 || beat >= 356.0 && beat <= 363.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                tweens.tween(opp, {x: opp.x + 870.0}, conductor.beatLength * 0.35 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 870.0}, 0.5);}});

                opp.animation.play("slap", true);
            }
        }

        if (Options.flashingLights)
        {
            if (beat >= 316 && beat <= 323)
            {
                if (beat % 2.0 == 1.0)
                {
                    essentialES.hall.colorTransform.setOffsets(200, 0, 0, 155);

                    tweens.tween(essentialES.hall.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 255.0},
                        conductor.beatLength * 0.5 * 0.001, {ease: FlxEase.quartIn, onComplete: (_tween:FlxTween) -> {tweens.tween(this.gameCamera, {color: 0x000000}, 0.001);}});
                }
                else
                {
                    essentialES.hall.colorTransform.setOffsets(200, 0, 0, 155);

                    gameCamera.color = 0xFF0000;

                    tweens.tween(essentialES.hall.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 255.0},
                        conductor.beatLength * 0.5 * 0.001, {ease: FlxEase.quartIn, onComplete: (_tween:FlxTween) -> {tweens.tween(this.gameCamera, {color: 0x000000}, 0.001);}});
                }
            }
        }

        if (beat >= 324.0 && beat <= 355.0)
        {
            if (beat % 2.0 == 1.0)
            {
                var opp:Character = getOpponent("baldi-mad-glitch");

                tweens.tween(opp, {x: opp.x + 940.0}, conductor.beatLength * 0.35 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 940.0}, 0.5);}});
            }
        }

        if (beat >= 336.0 && beat <= 339.0)
            gameCameraZoom += 0.05;

        if (beat >= 384 && beat <= 387)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                tweens.tween(opp, {x: opp.x + 520.0}, conductor.beatLength * 0.35 * 0.001, {ease: FlxEase.quadOut});

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 388.0 && beat <= 455.0)
        {
            if (beat % 2.0 == 1.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                tweens.tween(opp, {x: opp.x + 900.0}, conductor.beatLength * 0.35 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 900.0}, 0.5);}});

                opp.animation.play("slap", true);
            }
        }
    }

    public function updateLegStatus(name:String, frameNum:Int, frameIndex:Int):Void
    {
        var plr:Character = getPlayer("run-legs");
    
        var curFrame:Int = plr.animation.curAnim.curFrame;
    
        if (name.contains("MISS"))
        {
            if (!plr.animation.name.contains("miss"))
                plr.animation.play("legs miss", true, false, curFrame);
        }
        else
        {
            if (plr.animation.name.contains("miss"))
                plr.animation.play("legs", true, false, curFrame);
        }
    }
}