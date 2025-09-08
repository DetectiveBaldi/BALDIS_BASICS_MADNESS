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

import game.stages.BloxyCS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class BloxyCL extends PlayState
{
    public var bloxyCS:BloxyCS;

    override function create():Void
    {
        stage = new BloxyCS();

        bloxyCS = cast (stage, BloxyCS);

        super.create();
            
        cameraPoint.centerTo();

        cameraPoint.x += 50.0;

        cameraLock = FOCUS_CAM_POINT;

        playField.visible = false;

        bloxyCS.oldSchool.visible = true;

        player.setPosition(800.0, 335.0);
        player.scale.set(1.55, 1.55);
    
        opponent.setPosition(200.0, 125.0);

        var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("old-baldi-mad"));
        opp.setPosition(168.0, 134.0);
        opp.skipDance = true;
        opp.visible = false;
        opponents.add(opp);
    }

    override function stepHit(step:Int):Void
    {
         
        if (step == 16)
        {
            gameCameraZoom = 0.85;
            
            cameraLock = FOCUS_CAM_CHAR;
            
            playField.visible = true;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 160 || step == 192 || step == 224 || step == 256)
            gameCameraZoom = 0.85;
    
        if (step == 208 || step == 672)
        {
            gameCameraZoom = 0.8;
        }
    
        if (step == 272 || step == 656 || step == 784)
        {
            gameCameraZoom = 0.95;
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 328)
        {
            tween.tween(hudCamera, {alpha: 0.0}, conductor.beatLength * 2.0 * 0.001);
        }
        
        if (step == 336)
        {
            gameCameraZoom = 0.75;

            opponent.skipDance = true;
            
            cameraPoint.centerTo();

            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.x += 50.0;
        }

        if (step == 368)
        {
            opponent.skipDance = true;
            opponent.animation.play("annoyed");
        }
        
        if (step == 384)
        {
            opponent.skipDance = true;
            opponent.animation.play("angry");
        }
        
        if (step == 396)
        {
            opponent.visible = false;
            
            var opp:Character = getOpponent("old-baldi-mad");
            opp.animation.play("slap");
            opp.visible = true;
            opponent = opp;

            updateHealthBar("opponent");
        }
        
        if (step == 400)
        {
            gameCameraZoom = 0.8;

            cameraLock = FOCUS_CAM_CHAR;
            
            hudCamera.alpha = 1.0;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 776)
            gameCameraZoom = 0.95;

        if (step == 784)
        {
            gameCameraZoom = 0.75;
            
            cameraPoint.centerTo();

            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.x += 50.0;
        
            playField.visible = false;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 848)
            gameCamera.visible = false;
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 0 && beat < 4)
        {
            gameCameraZoom += 0.05;
            
            if (beat % 1 == 0)
            {
                cameraPoint.centerTo(player);

                cameraPoint.x -= 25;

                cameraPoint.y -= 50;

                gameCamera.snapToTarget();
            }
        
            if (beat % 2 == 0)
            {
                cameraPoint.centerTo(opponent);

                cameraPoint.x += 20;

                cameraPoint.y -= 100;

                gameCamera.snapToTarget();
            }
        }

        if (beat >= 38 && beat < 64 && (beat - 38) % 8 < 2)
        {
            gameCameraZoom += 0.05;
        }
        
        if (beat >= 88 && beat < 98)
        {
            if (beat % 4 == 0)
                gameCameraZoom += 0.05;
        }
    
        if (beat >= 100)
            if (beat % 2 == 1.0)
                opponent.animation.play("slap");
    
        if (beat >= 204)
            if (beat % 2 == 1.0)
                tween.tween(opponent, {x: opponent.x + 150.0}, conductor.beatLength * 0.275 * 0.001, 
                    {
                        ease: FlxEase.sineIn
                    }
                );
    }
}