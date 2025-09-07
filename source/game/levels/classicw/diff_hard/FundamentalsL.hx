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

        AssetCache.getGraphic("game/Character/principal");

        AssetCache.getGraphic("game/Character/bully");

        AssetCache.getGraphic("game/Character/bf-face-left");
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step >= 10.0 && step <= 15.0)
        {
            if (step % 2 == 0.0)
                gameCamera.alpha += 0.25;
        }

        if (step == 16.0)
            gameCamera.alpha += 1.0;

        if (step == 272.0)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.65;

            cameraLock = FOCUS_CAM_CHAR;
        }

        if (step == 784.0)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("principal"));
            opp.setPosition(0.0, 22.0);
            opp.color = 0xADA493;
            opponents.add(opp);

            player.visible = false;
        }

        if (step == 848.0)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            fundamentalsS.hall0.visible = false;
            fundamentalsS.office.visible = true;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            cameraLock = FOCUS_CAM_CHAR;

            opponent.visible = false;
            
            var plr:Character = getPlayer("bf-face-left");
            plr.setPosition(720.0, 205.0);
            plr.visible = true;
            player = plr;

            var opp:Character = getOpponent("principal");
            opp.setPosition(-60.0, 60.0);
            opponent = opp;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 64.0 && beat <= 67.0)
        {
            gameCameraZoom += 0.025;
        }
    }
}