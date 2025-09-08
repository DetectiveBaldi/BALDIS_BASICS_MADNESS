package game.levels.classicw.diff_hard;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.diff_hard.FundamentalsS;

using util.MathUtil;

using StringTools;

class FundamentalsL extends PlayState
{
    public var fundamentalsS:FundamentalsS;

    override function create():Void
    {
        stage = new FundamentalsS();

        fundamentalsS = cast (stage, FundamentalsS);

        super.create();

        fundamentalsS.hall0.visible = true;

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCameraZoom = 0.65;

        opponent.setPosition(-650.0, -520.0);

        opponent.color = 0xA09A85;

        player.setPosition(720.0, 205.0);

        player.color = 0xB8B19C;

        gameCamera.alpha = 0.0;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step >= 10.0 && step <= 15.0)
        {
            if (step % 2 == 0.0)
                gameCamera.alpha += 0.25;
        }

        if (step == 16)
            gameCamera.alpha += 1.0;

        if (step == 272)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.65;

            cameraLock = FOCUS_CAM_CHAR;
        }

        if (step == 784)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("principal"));
            opp.setPosition(-1800.0, 80.0);
            opp.color = 0xADA493;
            opponents.add(opp);

            player.visible = false;
        }

        if (step == 790)
        {
            var opp:Character = getOpponent("principal");
            tween.tween(opp, {x: 2000.0}, conductor.beatLength * 6.5 * 0.001);
        }

        if (step == 798)
            opponent.visible = false;

        if (step == 840)
        {
            var opp:Character = getOpponent("principal");
            tween.tween(opp, {x: -700.0}, conductor.beatLength * 4.0 * 0.001);
        }

        if (step == 848)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            fundamentalsS.hall0.visible = false;
            fundamentalsS.office.visible = true;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            cameraLock = FOCUS_CAM_CHAR;

            opponent.visible = false;

            var bul:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bully-spectator"));
            bul.setPosition(-50.0, 115.0);
            bul.scale.set(2.05, 2.05);
            bul.updateHitbox();
            bul.color = 0xADA493;
            spectators.add(bul);
            
            var plr:Character = getPlayer("bf-face-left");
            plr.setPosition(720.0, 205.0);
            plr.visible = true;
            player = plr;

            var opp:Character = getOpponent("principal");
            tween.cancelTweensOf(opp);
            opp.setPosition(-60.0, 100.0);
            opponent = opp;

            updateHealthBar("opponent");
        }

        if (step == 1232 || step == 1343)
            gameCameraZoom += 0.05;

        if (step == 1232)
        {
            var bul:Character = getSpectator("bully-spectator");
            bul.visible = false;
        }

        if (step == 1360)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.visible = false;

            cameraLock = FOCUS_CAM_POINT;
            cameraPoint.centerTo();
            gameCamera.snapToTarget();

            fundamentalsS.office.visible = false;
            fundamentalsS.office2.visible = true;

            opponent.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("playtime-flipped"));
            opp.setPosition(1800.0, 180.0);
            opp.color = 0xBBAC91;
            opp.skipDance = true;
            opponents.add(opp);
            opponent = opp;

            player.visible = false;
        }

        if (step == 1432)
        {
            fundamentalsS.office2.visible = false;
            fundamentalsS.hall1.visible = true;

            updateHealthBar("opponent");
        }

        if (step == 1438)
        {
            tween.tween(opponent, {x: 665.0}, conductor.beatLength * 5.0 * 0.001, {ease: FlxEase.quartOut});

            opponent.animation.play("play");
        }

        if (step == 1456)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.visible = true;

            opponent.skipDance = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-105.0, 145.0);
            plr.color = 0xB8B19C;
            players.add(plr);
            player = plr;

            var oppStrumlineX:Float = oppStrumline.strums.x;
            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1660 || step == 1666)
            gameCameraZoom += 0.025;

        if (step == 1672)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.65;
        }

        if (step == 1876)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.725;

            cameraLock = FOCUS_CAM_CHAR;
        }

        if (step == 2044)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad"));
            opp.flipX = true;
            opp.setPosition(1800.0, 40.0);
            opp.color = 0xAFA38E;
            opp.scale.set(2.9, 2.9);
            opp.updateHitbox();
            opp.skipDance = true;
            opp.skipSing = true;
            opponents.add(opp);
        }

        if (step == 2056)
        {
            tween.tween(player, {x: -1800.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 2068)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            cameraLock = FOCUS_CAM_POINT;
            cameraPoint.centerTo();

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            tween.tween(opponent, {x: 2000.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 64.0 && beat <= 67.0)
        {
            gameCameraZoom += 0.025;
        }

        if (beat >= 511 && beat <= 532)
        {
            if (beat % 3 == 1.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                tween.tween(opp, {x: opp.x - 350.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

                opp.animation.play("slap");
            }
        }
    }
}