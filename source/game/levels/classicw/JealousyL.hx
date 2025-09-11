package game.levels.classicw;

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

import game.stages.classicw.JealousyS;

using util.MathUtil;

using StringTools;

class JealousyL extends PlayState
{
    public var jealousyS:JealousyS;

    override function create():Void
    {
        stage = new JealousyS();

        jealousyS = cast (stage, JealousyS);

        super.create();

        player.setPosition(1600.0, 155.0);

        player.skipDance = true;
        player.skipSing = true;

        opponent.scale.set(2.3, 2.3);
        opponent.updateHitbox();
        opponent.setPosition(540.0, -285.0);

        opponent.skipDance = true;
        opponent.visible = false;

        playField.visible = false;

        gameCameraZoom = 0.6;

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        var oppStrumlineX:Float = oppStrumline.strums.x;
        var plrStrumlineX:Float = plrStrumline.strums.x;

        oppStrumline.strums.x = plrStrumlineX;
        plrStrumline.strums.x = oppStrumlineX;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            jealousyS.hall.visible = true;

            jealousyS.hall.animation.play("0", false, true);

            player.animation.play("wleft");

            tween.tween(player, {x: 500.0}, conductor.beatLength * 7.9 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 32)
        {
            jealousyS.hall.visible = false;
            jealousyS.hall.animation.pause();

            jealousyS.hall0.visible = true;

            tween.cancelTweensOf(player);
            player.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-anim-jealousy"));
            plr.scale.set(0.9, 0.9);
            plr.updateHitbox();
            plr.setPosition(110.0, 276.0);
            plr.skipDance = true;
            players.add(plr);
            player = plr;

            tween.tween(player, {x: 108.0, y: 272.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            opponent.visible = true;
        }

        if (step == 42)
            player.animation.play("turn");

        if (step == 48)
        {
            opponent.animation.play("scream");

            tween.tween(opponent, {x: -6960.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(opponent.scale, {x: 1.5, y: 1.5}, conductor.beatLength * 3.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 60)
        {
            jealousyS.hall0.visible = false;
            jealousyS.hall.visible = true;

            player.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-260.0, 155.0);
            players.add(plr);
            player = plr;

            tween.cancelTweensOf(opponent);

            opponent.x = 1800.0;

            tween.tween(opponent, {x: 660.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 64)
        {
            playField.visible = true;

            opponent.skipDance = false;

            tween.cancelTweensOf(opponent);

            tween.tween(opponent, {x: 600.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 320 || step == 912)
        {
            gameCameraZoom += 0.35;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            cameraLock = FOCUS_CAM_CHAR;
        }

        if (step == 384 || step == 788 || step == 976)
            gameCameraZoom -= 0.05;

        if (step == 656)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.6;

            cameraLock = FOCUS_CAM_POINT;
            cameraPoint.centerTo();
            gameCamera.snapToTarget();
        }

        if (step == 784)
            gameCameraZoom += 0.05;

        if (step == 1027)
        {
            tween.tween(opponent, {x: -1100.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            opponent.animation.play("scream");

            opponent.skipDance = true;
        }

        if (step == 1040)
        {
            FlxG.camera.visible = false;

            opponent.visible = false;

            player.visible = false;

            playField.visible = false;

            var plr:Character = getPlayer("bf-anim-jealousy");
            plr.scale.set(2.7, 2.7);
            plr.updateHitbox();
            plr.setPosition(120.0, 155.0);
            plr.skipDance = true;
            plr.visible = true;
            player = plr;
        }

        if (step == 1056)
        {
            FlxG.camera.visible = true;

            player.animation.play("teleport");

            gameCamera.snapToTarget();
            cameraPoint.y = -30.0;
        }
        
        if (step == 1072)
            FlxG.camera.visible = false;
    }
}