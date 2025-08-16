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

import game.events.SetCamFocusEvent;

import game.stages.LiteratureS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class LiteratureL extends PlayState
{
    public var literatureS:LiteratureS;

    override function create():Void
    {
        stage = new LiteratureS();

        literatureS = cast (stage, LiteratureS);

        super.create();
    
        cameraLock = FOCUS_CAM_POINT;
        
        cameraPoint.centerTo(player);

        cameraPoint.x += 250.0;

        gameCamera.snapToTarget();

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = oppStrumline.strums.visible = plrStrumline.strums.visible = false;

        literatureS.hall0.visible = true;
    
        player.setPosition(600.0, 125.0);
    
        opponent.setPosition(-50.0, -100.0);

        opponent.skipDance = true;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 16)            
            opponent.animation.play("talk");
        
        if (step == 112)            
            opponent.skipDance = false;

        if (step == 128)
        {
            cameraLock = FOCUS_CAM_CHAR;
            
            gameCamera.snapToTarget();

            gameCameraZoom = 0.9;
           
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = oppStrumline.strums.visible = plrStrumline.strums.visible = true;            
           
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        
            literatureS.hall0.visible = false;

            literatureS.classroom.visible = true;
        
            opponent.x = -275;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 32 && beat < 160)
            if (cameraCharTarget == "OPPONENT")
                gameCameraZoom = 1.3;
            else
                gameCameraZoom = 1;
    }
}