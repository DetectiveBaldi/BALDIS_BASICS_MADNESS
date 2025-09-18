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

    public var plrStrumlineX:Float;

    public var oppStrumlineX:Float;

    public var checkLayer:Bool;
    
    public var timeInterval:Float;

    override function create():Void
    {
        stage = new JealousyS();

        jealousyS = cast (stage, JealousyS);

        super.create();

        plrStrumline.botplay = true;

        player.setPosition(1600.0, 160.0);

        player.skipDance = true;
        player.skipSing = true;

        opponent.scale.set(2.3, 2.3);
        opponent.updateHitbox();
        opponent.setPosition(500.0, -250.0);

        opponent.skipDance = true;
        opponent.visible = false;

        playField.visible = false;

        gameCameraZoom = 0.6;

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        oppStrumlineX = oppStrumline.strums.x;
        plrStrumlineX = plrStrumline.strums.x;

        oppStrumline.strums.x = plrStrumlineX;
        plrStrumline.strums.x = oppStrumlineX;
    
        checkLayer = true;
        
        timeInterval = 0.75;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        var offset:Float = FlxG.random.float(0.0, 4.0) * 2.0;

        if (playField.healthBar.value > 80.0)
            offset = FlxG.random.float(4.0, 8.0) * 4.0;

        playField.healthBar.opponentIcon.offset.x = offset;
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
            plr.setPosition(115.0, 276.0);
            plr.skipDance = true;
            players.add(plr);
            player = plr;

            opponent.visible = true;

            tween.tween(player, {x: 108.0, y: 272.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
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

            plrStrumline.botplay = Options.botplay;

            player.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-260.0, 155.0);
            players.add(plr);
            player = plr;

            tween.cancelTweensOf(opponent);

            opponent.x = 1800.0;

            tween.tween(opponent, {x: 580.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 64)
        {
            playField.visible = true;

            opponent.skipDance = false;
        }

        if (step == 128 || step == 224 || step == 784)
            gameCameraZoom += 0.05;

        if (step == 192)
            gameCameraZoom -= 0.05;

        if (step == 316 || step == 512 || step == 720)
        {
            gameCameraZoom = 0.8;
        }

        if (step == 380)
        {
            gameCameraZoom += 0.05;
             
            jealousyS.hall.color = 0xADADAD;
        }
        
        if (step == 384)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.6;

            cameraLock = FOCUS_CAM_POINT;
            cameraPoint.centerTo();
            gameCamera.snapToTarget();
        
            jealousyS.hall.color = 0xFFFFFF;
        }

        if (step == 640)
            gameCameraZoom = 0.6;

        if (step == 964)
        {
            gameCameraZoom = 0.8;

            cameraLock = FOCUS_CAM_POINT;
            cameraPoint.centerTo();
            gameCamera.snapToTarget();

            tween.tween(opponent, {x: -1000.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            opponent.animation.play("scream");

            opponent.skipDance = true;
        }
        
        if (step == 976)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.6;

            plrStrumline.strums.x = plrStrumline.strums.getCenterX();
            
            oppStrumline.strums.x = oppStrumline.strums.getCenterX();
            oppStrumline.strums.alpha = 0.25;

            jealousyS.hall.visible = false;
            
            jealousyS.hall1.visible = true;

            player.visible = false;
                    
            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-nervous"));
            plr.setPosition(290.0, 150.0);
            players.add(plr);
            player = plr;

            opponent.skipDance = false;
            tween.cancelTweensOf(opponent);
            
            opponent.setPosition(50.0, -280.0);

            tween.tween(opponent, {x: -200}, 0.5,                
                {
                    onComplete: (_tween:FlxTween) ->  
                    {
                        tween.tween(opponent, {x: 300}, timeInterval, 
                            {
                                ease: FlxEase.quadInOut, 
                                type: PINGPONG,
                                onComplete: (_tween:FlxTween) -> {_tween.duration = timeInterval; craftersLayerUpdate();}
                            }
                        );
                    
                        tween.tween(opponent.scale, {x: 1.7, y: 1.7}, timeInterval / 2, 
                            {
                                ease: FlxEase.smootherStepOut, 
                                type: PINGPONG,
                                loopDelay: timeInterval / 2,
                                onComplete: (_tween:FlxTween) -> {_tween.loopDelay = timeInterval * 0.5; _tween.duration = timeInterval * 0.5;}
                            }
                        );
                    }
                }
            );
        }
        
        if (step == 1024)
        {
            gameCameraZoom = 1.0;

            opponent.skipDance = true;
            opponent.animation.play("scream");
        }
        
        if (step == 1040)
        {
            FlxG.camera.visible = false;

            gameCameraZoom = 0.6;

            plrStrumline.botplay = true;

            plrStrumline.resetStrums();

            opponent.visible = false;

            player.visible = false;

            playField.visible = false;

            jealousyS.hall1.visible = false;
            
            jealousyS.hall.visible = true;

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
        }
        
        if (step == 1072)
            FlxG.camera.visible = false;
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 80 && beat < 96 || beat >= 196 && beat < 240)
            if (cameraCharTarget == "OPPONENT")
            {
                cameraPoint.centerTo(opponent);
                cameraPoint.setPosition(cameraPoint.x - 175, cameraPoint.y - 80);

                gameCamera.snapToTarget();
            }
            else
            {
                cameraPoint.centerTo(player);
                cameraPoint.setPosition(cameraPoint.x + 250, cameraPoint.y - 50);

                gameCamera.snapToTarget();
            }
    }

    public function craftersLayerUpdate():Void
    {
        if (timeInterval > 0.1)
        {
            timeInterval = timeInterval - 0.05;
        }

        if (checkLayer == true)
        {
            checkLayer = false;        
            jealousyS.remove(opponent, true);
            jealousyS.insert(jealousyS.members.indexOf(players), opponent);
        }else
        {
            checkLayer = true;

            jealousyS.remove(opponent, true);
            jealousyS.add(opponent);
        }
    }
}