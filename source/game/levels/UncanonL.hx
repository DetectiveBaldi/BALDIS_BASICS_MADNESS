package game.levels;

import openfl.filters.BitmapFilter;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.Options;
import core.Paths;

import data.CharacterData;

import extendable.TransitionState;

import game.stages.UncanonS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class UncanonL extends PlayState
{
    public var uncanonS:UncanonS;

    override function create():Void
    {
        stage = new UncanonS();

        uncanonS = cast (stage, UncanonS);

        TransitionState.cancelFadeIn = true;

        super.create();

        cameraLock = FOCUS_CAM_POINT;
    
        cameraPoint.centerTo(opponent);

        cameraPoint.x -= 50.0;

        gameCamera.zoom = 0.3;

        gameCameraZoom = 0.3;

        gameCamBopStrength = 0.0;

        gameCamera.snapToTarget();

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = oppStrumline.strums.visible = plrStrumline.strums.visible = false;

        player.scale.set(4.5, 4.5);
        player.setPosition(500.0, 150.0);
        player.visible = false;
        
        opponent.setPosition(-75.0, 0.0);
        opponent.colorTransform.setOffsets(FlxColor.WHITE);
        opponent.alpha = 0.0;

        countdown.skip();

        plrStrumline.botplay = true;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 60)
        {
            cameraPoint.x += 75.0;

            gameCameraZoom = 0.65;

            gameCamBopStrength = 0.035;

            gameCamera.snapToTarget();

            cameraLock = FOCUS_CAM_CHAR;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = oppStrumline.strums.visible = plrStrumline.strums.visible = true;

            uncanonS.connorRoom0.visible = true;

            plrStrumline.botplay = Options.botplay;
            
            player.visible = true;

            opponent.alpha = 1.0;
            opponent.colorTransform.setOffsets(0.0, 0.0, 0.0, 0.0);
        }

        if (step == 316 || step == 448 || step == 568 || step == 720)
            gameCameraZoom = 0.7;

        if (step == 320 || step == 452)
        {
            gameCameraZoom = 0.65;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 589)
        {
            plrStrumline.botplay = true;
            plrStrumline.resetStrums();

            FlxG.camera.visible = false;
        }

        if (step == 592)
        {
            FlxG.camera.visible = true;

            plrStrumline.botplay = Options.botplay;
        
            gameCameraZoom = 0.65;

            uncanonS.connorRoom0.visible = false;
            
            uncanonS.connorRoom1.visible = true;
        
            var plr:Character = getPlayer("bf-face-back-left");
            plr.visible = false;

            opponent.scale.set(3.4, 3.4);
            opponent.x += 20.0;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-left"));
            plr.scale.set(1.65, 1.65);
            plr.setPosition(480, 40);
            players.add(plr);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 0 && beat < 16)
        {
            if (beat % 4 == 0)
            {
                opponent.alpha = 1.0;
                
                if (beat == 12)
                    tweens.tween(this, {gameCameraZoom: 5.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});
                else
                    tweens.tween(opponent, {alpha: 0.0}, conductor.beatLength * 2.0 * 0.001);
            }
        }
    }
}