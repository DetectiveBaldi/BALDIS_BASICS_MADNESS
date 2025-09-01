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
        }

        if (step == 400)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.visible = false;

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