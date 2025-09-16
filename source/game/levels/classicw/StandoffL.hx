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

import game.stages.classicw.StandoffS;

using util.MathUtil;

using StringTools;

class StandoffL extends PlayState
{
    public var standoffS:StandoffS;

    public var baldi:Character;

    public var sweeper:FlxSprite;

    override function create():Void
    {
        stage = new StandoffS();

        standoffS = cast (stage, StandoffS);

        super.create();
    
        gameCameraZoom = 0.75;

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        plrStrumline.strums.alpha = oppStrumline.strums.alpha = 0.0;

        standoffS.hall.visible = true;

        player.setPosition(700.0, 150.0);

        opponent.setPosition(-600.0, -575.0);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 48 || step == 704 || step == 1376)
            cameraLock = FOCUS_CAM_CHAR;

        if (step == 64)
        {
            gameCameraZoom = 0.7; 
        
            tween.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);

            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);
        }

        if (step == 304)
        {
            gameCameraZoom = 1;
            
            standoffS.hall.color = 0xADADAD;
        }

        if (step == 320)
        {
            standoffS.hall.color = 0xFFFFFF;
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
        
        if (step == 576)
        {
            gameCameraZoom = 0.6;

            cameraPoint.centerTo();

            cameraLock = FOCUS_CAM_POINT;
            
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
        
        if (step == 816)
        {
            gameCameraZoom = 0.75;

            standoffS.hall_Overlay0.visible = true;

            baldi = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad-face-front"));
            baldi.setPosition(400.0, 110.0);
            baldi.scale.set(0.25, 0.25);
            baldi.skipDance = true;
            baldi.skipSing = true;
            baldi.animation.play("slap");
            standoffS.insert(standoffS.members.indexOf(standoffS.hall_Overlay0), baldi);
            
            tween.tween(baldi, {x: 338.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }
    
        if (step == 832)
        {
            gameCameraZoom = 0.8;
            
            standoffS.hall_Overlay0.visible = false;
            
            standoffS.hall_Alt.visible = true;
            standoffS.hall_Overlay1.visible = true;

            sweeper = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/gotta-sweep"));
            sweeper.scale.set(0.325, 0.325);
            sweeper.updateHitbox();
            sweeper.setPosition(500.0, 322.0);
            standoffS.insert(standoffS.members.indexOf(standoffS.hall_Overlay0), sweeper);
            
            baldi.animation.play("slap");
        
            tween.tween(baldi, {y: 112.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        
            tween.tween(baldi.scale, {x: baldi.scale.x + 0.035, y: baldi.scale.y + 0.035}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(sweeper, {x: 547.0}, conductor.beatLength * 1.0 * 0.001, 
                {
                    ease: FlxEase.quartOut,
                    onComplete: (_tween:FlxTween) ->
                    {
                        tween.tween(baldi, {y: 110.0}, conductor.beatLength * 1.0 * 0.001, {startDelay: 0.05});

                        tween.tween(baldi.scale, {x: baldi.scale.x - 0.035, y: baldi.scale.y - 0.035}, conductor.beatLength * 1.0 * 0.001, {startDelay: 0.05});

                        tween.tween(sweeper, {y: 320.0}, conductor.beatLength * 1.0 * 0.001);

                        tween.tween(sweeper, {x: 550.0}, conductor.beatLength * 1.0 * 0.001);

                        tween.tween(sweeper.scale, {x: sweeper.scale.x - 0.035, y: sweeper.scale.y - 0.035}, conductor.beatLength * 1.0 * 0.001,
                            {
                                onComplete: (_tween:FlxTween) ->
                                {
                                    tween.tween(baldi, {x: 500.0}, conductor.beatLength * 1.0 * 0.001);
                                    
                                    tween.tween(sweeper, {x: 700.0}, conductor.beatLength * 1.0 * 0.001, 
                                        {
                                            onComplete: (_tween:FlxTween) ->
                                            {
                                                standoffS.hall_Alt.visible = false;

                                                standoffS.hall_Overlay1.visible = false;
                                            
                                                baldi.visible = false;

                                                sweeper.visible = false;
                                            }
                                        });
                                }
                            });
                    }
                });
        }
    
        if (step == 848 || step == 1520)
            gameCameraZoom = 0.85;

        if (step == 864)
        {
            gameCameraZoom = 1.0; 
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 1120)
        {
            gameCameraZoom = 0.85; 
                
            cameraLock = FOCUS_CAM_POINT;
        }

        if (step == 1248)
        {            
            gameCameraZoom = 0.6;

            cameraPoint.centerTo();

            gameCamera.snapToTarget();

            sweeper.scale.set(2.75, 2.75);
            sweeper.setPosition(1200.0, 400.0);
            sweeper.visible = true;
        
            tween.tween(player, {x: player.x - 500.0}, conductor.beatLength * 0.5 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        tween.tween(player, {x: player.x + 500.0}, conductor.beatLength * 1.5 * 0.001, {ease: FlxEase.circInOut});
                    }
                });

            tween.tween(sweeper, {x: 200.0}, conductor.beatLength * 1.0 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {                        
                        tween.tween(sweeper.scale, {x: 0.3, y: 0.3}, conductor.beatLength * 3.5 * 0.001);

                        tween.tween(sweeper, {x: 547, y: 325.0}, conductor.beatLength * 4.0 * 0.001,
                            {
                                onComplete: (_tween:FlxTween) ->
                                {
                                    standoffS.hall_Alt.visible = true;

                                    standoffS.hall_Overlay1.visible = true;
                                    
                                    tween.tween(sweeper, {x: 400.0}, conductor.beatLength * 1.0 * 0.001,
                                        {
                                            onComplete: (_tween:FlxTween) ->
                                            {
                                                sweeper.visible = false;
                                            }
                                        });
                                }
                            });
                    }
                });
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 1280)
        {
           standoffS.hall_Alt.visible = false;
           
           standoffS.hall_Overlay1.visible = false;
        }
    
        if (step == 1488)
            gameCameraZoom = 0.75;

        if (step == 1504)
            gameCameraZoom = 0.8;
        
        if (step == 1536)
        {
            gameCameraZoom = 0.75;
            
            cameraPoint.centerTo();

            cameraLock = FOCUS_CAM_POINT;

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

            opponent.visible = false;
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 12 && beat < 76 || beat >= 80 && beat < 114 || beat >= 176 && beat < 204 || beat >= 344 && beat < 372)
            if (cameraCharTarget == "OPPONENT")
                gameCameraZoom = 0.9;
        else
                gameCameraZoom = 0.7;
    
        if (beat >= 280 && beat < 296)
        {
            if (beat % 2 == 0)
            {
                cameraPoint.centerTo(player);
        
                cameraPoint.x -= 55;

                gameCamera.snapToTarget();
            }
        
            if (beat % 4 == 0)
            {
                cameraPoint.centerTo(opponent);

                cameraPoint.x -= 25;

                cameraPoint.y -= 50;

                gameCamera.snapToTarget();
            }
        }
    
        if (beat >= 296 && beat < 312)
        {
            if (beat % 2 == 0)
            {
                cameraPoint.centerTo(opponent);

                cameraPoint.x -= 25;

                cameraPoint.y -= 50;

                gameCamera.snapToTarget();
            }
        
            if (beat % 4 == 0)
            {
                cameraPoint.centerTo(player);
        
                cameraPoint.x -= 55;

                gameCamera.snapToTarget();
            }
        }
    }
}