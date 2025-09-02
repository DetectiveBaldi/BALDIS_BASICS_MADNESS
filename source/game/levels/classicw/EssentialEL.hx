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

using util.MathUtil;

using StringTools;

class EssentialEL extends PlayState
{
    public var essentialES:EssentialES;

    public var temperature:FlxSprite;

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

        var opp:Character = getOpponent("baldi-mad-face-front");
        opp.scale.set(1.4, 1.4);
        opp.updateHitbox();
        opp.setPosition(-240.0, 200.0);

        var plr:Character = getPlayer("bf-face-back-left");
        plr.scale.set(6.0, 6.0);
        plr.updateHitbox();
        plr.setPosition(1600.0, -250.0);

        playField.visible = false;

        temperature = new FlxSprite();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 16.0 * 0.001, true);

            tween.tween(this, {gameCameraZoom: 0.6}, conductor.beatLength * 16.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 64)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            tween.tween(player, {x: 550.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            playField.visible = true;
        }

        if (step == 320)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            essentialES.exit0.visible = false;
            essentialES.exit1.visible = true;

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
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
            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});

            tween.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});

            tween.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFFD8D8,
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

            tween.tween(plr, {x: 785.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(__plr, {x: 785.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            essentialES.exit1.visible = false;
            essentialES.hall.visible = true;
        }

        if (step == 656 || step == 784)
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

            tween.color(temperature, conductor.beatLength * 8.0 * 0.001, temperature.color, 0xFFFF8D8D,
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

            tween.color(temperature, conductor.beatLength * 8.0 * 0.001, temperature.color, 0xFFFF6363,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1168)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            cameraPoint.x = 950.0;

            tween.tween(this, {gameCameraZoom: 0.95}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1248)
        {
            tween.tween(this.cameraPoint, {x: 500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
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
                tween.tween(opp, {x: opp.x + 830.0}, conductor.beatLength * 0.15 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 830.0}, 0.15);}});
                }
                else 
                {
                tween.tween(opp, {x: opp.x + 830.0}, conductor.beatLength * 0.35 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 830.0}, 0.5);}});
                }

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 228.0 && beat <= 323.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                tween.tween(opp, {x: opp.x + 870.0}, conductor.beatLength * 0.35 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 870.0}, 0.5);}});

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