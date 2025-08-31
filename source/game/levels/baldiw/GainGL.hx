package game.levels.baldiw;

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

import core.AssetCache;
import core.Options;
import core.Paths;

import data.CharacterData;

import game.stages.baldiw.GainGS;

using util.MathUtil;

using StringTools;

class GainGL extends PlayState
{
    public var gainGS:GainGS;

    public var plrStrumlineX:Float;

    public var oppStrumlineX:Float;

    public var principal:FlxSprite;

    override function create():Void
    {
        stage = new GainGS();

        gainGS = cast (stage, GainGS);

        super.create();

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

        plrStrumlineX = plrStrumline.strums.x;

        oppStrumlineX = oppStrumline.strums.x;

        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.25;

        gainGS.entranceA4.visible = true;
        gainGS.entranceA4_Overlay0.visible = true;

        gainGS.remove(players, true);
        gainGS.insert(gainGS.members.indexOf(gainGS.entranceA4_Overlay2), players);

        player.setPosition(900, 125);
        player.visible = false;

        gainGS.remove(opponents, true);
        gainGS.insert(gainGS.members.indexOf(gainGS.entranceA4_Overlay0), opponents);

        opponent.scale.set(0.35, 0.35);
        opponent.updateHitbox();
        opponent.setPosition(595.0, 330.0);
        opponent.skipDance = true;
    
        AssetCache.getGraphic("game/Character/gotta-sweep");
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
        
        if (step == 56)
        {
            gainGS.entranceA4.visible = false;
            
            gainGS.entranceA4_Alt0.visible = true;
            gainGS.entranceA4_Overlay2.visible = true;
            
            player.visible = true;
            tween.tween(player, {x: player.x - 250.0}, 0.75, {ease: FlxEase.quartOut});
        }

        if (step == 124)
        {
            gameCameraZoom += 0.05;

            gainGS.entranceA4_Overlay0.visible = false;
           
            gainGS.entranceA4_Overlay1.visible = true;

            gainGS.remove(opponents, true);
            gainGS.insert(gainGS.members.indexOf(players), opponents);
        
            tween.tween(opponent.scale, {x: opponent.scale.x + 0.25, y: opponent.scale.y + 0.25}, conductor.beatLength * 0.275 * 0.001);
            
            tween.tween(opponent, {y: opponent.y + 10.0}, conductor.beatLength * 0.275 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        opponent.updateHitbox();
                        opponent.setPosition(462.0, 205.0);
                    }
                }
            );

            opponent.animation.play("slap", true);
        }

        if (step == 128)
        {
            gameCameraZoom == 0.8;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 144)
        {    
            gainGS.entranceA4_Overlay1.visible = false;
            
            gainGS.entranceA4_Overlay0.visible = true;
        }
   
        if (step == 312)
        {
            gameCameraZoom = 1.5;
        }
        
        if (step == 320)
        {
            gameCameraZoom = 0.75;

            cameraPoint.x -= 180.0;

            gameCamera.snapToTarget();

            tween.tween(cameraPoint, {x: 950, y: 300.0}, conductor.beatLength * 28.0 * 0.001);

            tween.tween(this, {gameCameraZoom: 1.35}, conductor.beatLength * 28.0 * 0.001);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            plrStrumline.strums.x = oppStrumlineX;

            oppStrumline.strums.x = plrStrumlineX;
            oppStrumline.strums.alpha = 1.0;

            gainGS.entranceA4.visible = false;
            gainGS.entranceA4_Overlay0.visible = false;
            gainGS.entranceA4_Overlay2.visible = false;
            
            gainGS.entranceA5.visible = true;

            player.visible = false;
        
            gainGS.remove(players, true);
            gainGS.add(players);

            player = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-clutching-wall"));
            player.setPosition(-100.0, 125.0);
            players.add(player);

            gainGS.remove(opponents, true);
            gainGS.add(opponents);

            opponent.setPosition(455.0, 190.0);
            opponent.updateHitbox();
            opponent.scale.set(0.9, 0.9);
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 440)
        {
            gameCameraZoom = 0.75;
            
            cameraPoint.centerTo();

            player.visible = false;
        }
        
        if (step == 444)
        {
            tween.tween(opponent, {x: opponent.x - 300.0}, conductor.beatLength * 0.275 * 0.001, 
                {
                    ease: FlxEase.sineIn
                }
            );
       
            opponent.animation.play("slap");
        }
        
        if (step == 448)
        {
            gameCameraZoom = 1.35;

            cameraPoint.x -= 550.0;

            gameCamera.snapToTarget();

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            plrStrumline.strums.x = plrStrumlineX;

            oppStrumline.strums.x = oppStrumlineX;      
            
            gainGS.entranceA5.visible = false;
            
            gainGS.ggfaculty0_Alt0.visible = true;
            gainGS.ggfaculty0_Overlay0.visible = true;

            opponent.visible = false;

            gainGS.remove(players, true);
            gainGS.insert(gainGS.members.indexOf(gainGS.ggfaculty0_Overlay0), players);

            player = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-left"));
            player.scale.set(1.75, 1.75);
            player.updateHitbox();
            player.setPosition(1000.0, 225.0);
            players.add(player);

            opponent = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad"));
            opponent.scale.set(1.9, 1.9);
            opponent.updateHitbox();
            opponent.setPosition(-500.0, 145.0);
            opponents.add(opponent);

            tween.tween(opponent, {x: opponent.x + 200.0}, conductor.beatLength * 0.275 * 0.001, 
                {
                    ease: FlxEase.sineIn
                }
            );
            
            opponent.animation.play("slap", true);
        }
        
        if (step == 464)
        {                   
            gameCameraZoom = 1.0;

            cameraLock = FOCUS_CAM_CHAR;

            gainGS.ggfaculty0_Alt0.visible = false;
            
            gainGS.ggfaculty0.visible = true;
        }
    
        if (step == 504 || step == 507 || step == 510)
        {                        
            gameCameraZoom += 0.1;
        }
    
        if (step == 512)
        {                        
            gameCameraZoom = 0.95;
        }

        if (step == 624)
        {
            gameCameraZoom = 0.75;
            
            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();
        }

        if (step == 632)
        {                                   
            principal = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/principal"));
            principal.scale.set(1.15, 1.15);
            principal.updateHitbox();
            principal.setPosition(2500, 150.0);
            gainGS.insert(gainGS.members.indexOf(gainGS.ggfaculty0_Overlay0), principal);
        
            tween.tween(principal, {x: player.x + 200}, conductor.beatLength * 2.0 * 0.001,                
                {
                    onComplete: (_tween:FlxTween) ->  
                    {
                        principal.visible = false;
                        player.visible = false;
                    }
                }
            );
        }
    
        if (step == 640)
        {
            gameCameraZoom = 1.4;

            cameraPoint.x -= 150.0;

            gameCamera.snapToTarget();

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible =
                playField.timerClock.visible = playField.timerNeedle.visible = false;
                
            plrStrumline.strums.x = plrStrumline.strums.getCenterX();
                
            oppStrumline.strums.x = oppStrumline.strums.getCenterX();
            oppStrumline.strums.alpha = 0.25;

            gainGS.ggfaculty0.visible = false;
            gainGS.ggfaculty0_Overlay0.visible = false;
            
            gainGS.principalOffice0.visible = true;
            gainGS.principalOffice0_Overlay0.visible = true;

            opponent.visible = false;
            
            gainGS.remove(players, true);
            gainGS.add(players);

            player = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-back-left"));
            player.scale.set(2.0, 2.0);
            player.updateHitbox();
            player.setPosition(350.0, 175.0);
            players.add(player);
           
            gainGS.remove(opponents, true);
            gainGS.insert(gainGS.members.indexOf(gainGS.principalOffice0_Overlay0), opponents);
        
            opponent = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad-angled"));
            opponent.scale.set(1.5, 1.5);
            opponent.updateHitbox();
            opponent.setPosition(500.0, 180.0);
            opponents.add(opponent);

            tween.tween(opponent, {x: opponent.x - 150.0, y: opponent.y + 15.0}, conductor.beatLength * 0.275 * 0.001, 
                {
                    ease: FlxEase.quadOut
                }
            );
        
            var timerText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "You get detention!\n15 seconds remain!", 48);

            timerText.camera = hudCamera;

            timerText.color = FlxColor.RED;
            
            timerText.font = Paths.font(Paths.ttf("Comic Sans MS"));

            timerText.alignment = CENTER;

            timerText.textField.antiAliasType = ADVANCED;

            timerText.textField.sharpness = 400.0;

            timerText.screenCenter();

            add(timerText);

            new FlxTimer(timer).start(1.0, (_timer:FlxTimer) ->
            {
                if (_timer.loopsLeft == 0.0)
                    timerText.active = timerText.visible = false;

                timerText.text = 'You get detention!\n${_timer.loopsLeft} seconds remain!';

                timerText.screenCenter();
            }, 15);
        }

        if (step == 648 || step == 880 || step == 896)
        {            
            tween.tween(opponent, {x: opponent.x - 150.0}, conductor.beatLength * 0.275 * 0.001, 
                {
                    ease: FlxEase.sineIn
                }
            );
        }
    
        if (step == 912)
        {
            gameCameraZoom = 0.8;
            
            cameraPoint.centerTo();

            gameCamera.snapToTarget();

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible =
                playField.timerClock.visible = playField.timerNeedle.visible = true;
            
            plrStrumline.strums.x = plrStrumlineX;

            oppStrumline.strums.x = oppStrumlineX;
            oppStrumline.strums.alpha = 1.0;

            gainGS.principalOffice0.visible = false;
            gainGS.principalOffice0_Overlay0.visible = false;
        
            gainGS.scrollingHall0.visible = true;

            player.visible = false;

            opponent.visible = false;

            player = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-walking"));
            player.setPosition(798.5, 205.5);
            players.add(player);

            player.animation.onFrameChange.add(updateLegStatus);

            var anim:FlxAnimation = player.animation.getByName("dance");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            var _plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("walk-legs"));
            _plr.setPosition(player.x, player.y);
            _plr.skipDance = true;
            _plr.skipSing = true;
            players.insert(players.members.indexOf(player), _plr);

            anim = _plr.animation.getByName("legs");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);
            anim = _plr.animation.getByName("legs miss");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            _plr.animation.play("legs", true);

            gainGS.remove(opponents, true);
            gainGS.add(opponents);

            opponent = getOpponent("baldi-mad");
            opponent.visible = true;
            opponent.scale.set(3.0, 3.0);
            opponent.updateHitbox();
            opponent.setPosition(-845.0, 20.0);
            
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 1040.0)
        {
            gameCameraZoom = 0.75;
        }

        if (step == 1152.0)
        {
            gainGS.scrollingHall0.animation.pause();

            var _plr:Character = getPlayer("walk-legs");

            tween.tween(player, {x: FlxG.width / 0.75}, conductor.beatLength * 2.0 * 0.001, 
                {
                    ease: FlxEase.sineIn, 
                    onUpdate: (tween:FlxTween) -> 
                    {
                        _plr.x = player.x;
                    }
                }
            );

            tween.tween(player.animation, {timeScale: 1.25}, conductor.beatLength * 0.001, {ease: FlxEase.sineIn});

            tween.tween(_plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001 * 0.001, {ease: FlxEase.sineIn});
        }

        if (step == 1168.0)
        {
            gameCameraZoom = 0.4;

            gainGS.scrollingHall0.visible = false;

            gainGS.phoneHall0.visible = true;

            player.visible = false;

            var _plr:Character = getPlayer("walk-legs");
            _plr.visible = false;

            player = getPlayer("bf-face-left");
            player.visible = true;
            player.scale.set(2.7, 2.7);
            player.updateHitbox();
            player.setPosition(520.0, 175.0);
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 1264.0)
        {
            tween.tween(opponent, {x: opponent.x + 725.0}, conductor.beatLength * 0.35 * 0.001);
        }

        if (step == 1268.0)
        {
            var opp:Character = getOpponent("baldi-mad");

            tween.tween(opp, {x: -opp.width * 1.85}, 0.5, {startDelay: 1.0, ease: FlxEase.quartIn});

            var _opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("gotta-sweep"));

            _opp.skipSing = true;

            _opp.setPosition(-_opp.width, -100.0);

            opponents.add(_opp);

            tween.tween(_opp, {x: opp.x -50.0}, 0.5, {startDelay: 0.5, ease: FlxEase.quartOut,
                onComplete: (_tween:FlxTween) -> {tween.tween(_opp, {x: -opp.width * 2}, 0.5, {ease: FlxEase.quartIn});}});
        }

        if (step == 1296.0)
        {
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible =
                playField.timerClock.visible = playField.timerNeedle.visible = false;
        
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }
    }
    
    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 0.0 && beat < 30.0)
            {
                if (beat % 4.0 == 0.0)
                {
                    var opp:Character = getOpponent("baldi-mad-face-front");
    
                    tween.tween(opp.scale, {x: opp.scale.x + 0.1, y: opp.scale.y + 0.1}, conductor.beatLength * 0.275 * 0.001);
                    tween.tween(opp, {y: opp.y + 0.25}, conductor.beatLength * 0.275 * 0.001);
    
                    opp.animation.play("slap", true);
                }
            }
    
        if (beat >= 80.0 && beat < 112.0)
            {
                if (beat % 4 == 0.0)
                {        
                    tween.tween(opponent.scale, {x: opponent.scale.x + 0.225, y: opponent.scale.y + 0.225}, conductor.beatLength * 0.275 * 0.001);
        
                    tween.tween(opponent, {x: opponent.x + 40.0, y: opponent.y + 5.0}, conductor.beatLength * 0.275 * 0.001);
        
                    opponent.animation.play("slap", true);
                }
            }
        
        if (beat >= 228.0 && beat < 288.0)
        {
            if (beat % 4.0 == 0.0)
            {                
                tween.tween(opponent, {x: opponent.x + 725.0}, conductor.beatLength * 0.35 * 0.001,
                    {
                        ease: FlxEase.quadOut, 
                        onComplete: (_tween:FlxTween) -> 
                        {
                            if (beat < 290)
                                tween.tween(opponent, {x: opponent.x - 725.0}, 0.5);
                        }
                    }
                );
            }
        }
    }

    public function updateLegStatus(name:String, frameNum:Int, frameIndex:Int):Void
    {
        var plr:Character = getPlayer("walk-legs");
    
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