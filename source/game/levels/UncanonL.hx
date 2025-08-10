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

import game.events.FocusCamPointEvent;

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

        super.create();

        gameCameraZoom = 0.3;

        cameraLock = FOCUS_CAM_POINT;
    
        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = oppStrumline.strums.visible = plrStrumline.strums.visible = false;

        player.scale.set(5, 5);
        player.setPosition(625, 225);
        player.visible = false;
        
        opponent.setPosition(-75, 0);
        opponent.colorTransform.setOffsets(FlxColor.WHITE);
        opponent.alpha = 0;

        cameraPoint.centerTo(opponent);

        cameraPoint.x -= 0.5;
        
        gameCamera.snapToTarget();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 60)
        {
            gameCameraZoom = 0.65;
            
            cameraPoint.x += 75;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = oppStrumline.strums.visible = plrStrumline.strums.visible = true;

            uncanonS.connorRoom0.visible = true;
            
            player.visible = true;

            opponent.alpha = 1;
            opponent.colorTransform.setOffsets(0, 0, 0, 0);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 0 && beat < 16)
        {
            if (beat % 4 == 0)
            {
                opponent.alpha = 1;
                
                if (beat == 12)
                    tween.tween(this, {gameCameraZoom: 5}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});
                else
                    tween.tween(opponent, {alpha: 0}, conductor.beatLength * 2.0 * 0.001);
            }
        }
    }
}