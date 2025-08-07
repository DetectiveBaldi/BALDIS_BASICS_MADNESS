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

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.baldiw.GainGS;

using util.MathUtil;

using StringTools;

class GainGL extends PlayState
{
    public var gainGS:GainGS;

    public var temperature:FlxSprite;

    public var principal:FlxSprite;

    override function create():Void
    {
        stage = new GainGS();

        gainGS = cast (stage, GainGS);

        super.create();

        gameCameraZoom = 1;

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        temperature = new FlxSprite();

        var plr:Character = getPlayer("bf-peaking");
        plr.setPosition(900, 125);
        plr.visible = false;

        var opp:Character = getOpponent("baldi-mad-face-front");
        opp.scale.set(0.35, 0.35);
        opp.setPosition(390.0, 100.0);
        opp.skipDance = true;

        AssetCache.getGraphic("game/Character/gotta-sweep");
    
        gainGS.remove(opponents, true);
        gainGS.insert(gainGS.members.indexOf(gainGS.entranceA4_Overlay0), opponents);
        
        gainGS.entranceA4.visible = true;
        gainGS.entranceA4_Overlay0.visible = true;

        playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
        
        if (step == 56)
        {
            var plr:Character = getPlayer("bf-peaking");
            plr.visible = true;
            tween.tween(plr, {x: plr.x - 250.0}, 0.75, {ease: FlxEase.quartOut});
        
            gainGS.remove(players, true);
            gainGS.insert(gainGS.members.indexOf(gainGS.entranceA4_Overlay2), players);

            gainGS.entranceA4.visible = false;
            gainGS.entranceA4_Alt0.visible = true;
            gainGS.entranceA4_Overlay2.visible = true;
        }

        if (step == 124)
        {      
            var opp:Character = getOpponent("baldi-mad-face-front");

            gainGS.remove(opponents, true);
            gainGS.insert(gainGS.members.indexOf(players), opponents);
            
            gainGS.entranceA4_Overlay0.visible = false;
            gainGS.entranceA4_Overlay1.visible = true;
        
            tween.tween(opp.scale, {x: opp.scale.x + 0.25, y: opp.scale.y + 0.25}, conductor.beatLength * 0.275 * 0.001);
            tween.tween(opp, {y: opp.y + 10}, conductor.beatLength * 0.275 * 0.001);
            
            opp.animation.play("slap", true);
        }

        if (step == 128)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.skipDance = false;
        }

        if (step == 144)
        {    
            gainGS.entranceA4_Overlay1.visible = false;
            gainGS.entranceA4_Overlay0.visible = true;
        }
   
        if (step == 312)
        {
            gameCamera.color = 0xFFC6C6C6;

            temperature.color = 0xFFC6C6C6;

            gameCameraZoom = 1.1;
        }
        
        if (step == 320)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCamera.color = 0xFFA8A8A8;

            temperature.color = 0xFFA8A8A8;

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            cameraPoint.x -= 180.0;

            gameCamera.snapToTarget();

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
        
            var plr:Character = getPlayer("bf-peaking");
            plr.visible = false;
        
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-clutching-wall"));
            plr.setPosition(-100.0, 125.0);
            players.add(plr);
            plr.visible = true;

            gainGS.remove(players, true);
            gainGS.add(players);

            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.setPosition(375.0, 120.0);
            opp.scale.set(0.9, 0.9);
            opp.color = 0xFF000000;
        
            gainGS.remove(opponents, true);
            gainGS.add(opponents);

            gainGS.entranceA4.visible = false;
            gainGS.entranceA4_Overlay0.visible = false;
            gainGS.entranceA4_Overlay2.visible = false;
            gainGS.entranceA5.visible = true;
            gainGS.entranceA5.color = 0xFF050505;
        }

        if (step == 432)
        {
            var opp:Character = getOpponent("baldi-mad-face-front");
            tween.color(opp, conductor.beatLength * 3.0 * 0.001, opp.color, 0xFFFFFFFF,
                {onUpdate: (_tween:FlxTween) -> {opp.color;}});
        }

        if (step == 440)
        {
            gameCameraZoom = 0.7;

            tween.color(temperature, conductor.beatLength * 1.0 * 0.001, temperature.color, 0xFFFFFFFF,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});

            tween.color(gainGS.entranceA5, conductor.beatLength * 1.0 * 0.001, gainGS.entranceA5.color, 0xFFFFFFFF,
                {onUpdate: (_tween:FlxTween) -> {gainGS.entranceA5.color;}});

            var plr:Character = getPlayer("bf-clutching-wall");
            tween.tween(plr, {x: -1500.0}, 0.75, {ease: FlxEase.quartIn});
        
            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.animation.play("slap");
            tween.tween(opp, {x: opp.x - 300.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});
        }
        
        if (step == 448)
        {
            gameCameraZoom = 1;

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});        

            var plr:Character = getPlayer("bf-clutching-wall");
            plr.visible = false;
            
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-face-left"));
            plr.scale.set(1.75, 1.75);
            plr.setPosition(950.0, 125.0);
            plr.visible = true;
            players.add(plr);

            player = plr;

            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("baldi-mad"));
            opp.scale.set(2.0, 2.0);
            opp.setPosition(-600.0, 0.0);
            opp.skipDance = true;
            opponents.add(opp);

            opponent = opp;
            
            gainGS.remove(players, true);
            gainGS.insert(gainGS.members.indexOf(gainGS.ggfaculty0_Overlay0), players);

            gainGS.entranceA5.visible = false;
            gainGS.ggfaculty0_Alt0.visible = true;
            gainGS.ggfaculty0_Overlay0.visible = true;

            opp.x += 200.0;

            FocusCamCharEvent.dispatch(this, "opponent", -1.0, "linear", true);

            opp.x -= 200.0;

            tween.tween(opp, {x: opp.x + 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});
            opp.animation.play("slap", true);
        }
        
        if (step == 464)
        {                   
            gainGS.ggfaculty0_Alt0.visible = false;
            gainGS.ggfaculty0.visible = true;
        }

        if (step == 480.0)
            cameraLock = FOCUS_CAM_CHAR;
    
        if (step == 504 || step == 507 || step == 510)
        {                        
            gameCameraZoom += 0.1;
        }
    
        if (step == 512)
        {                        
            gameCameraZoom = 0.8;
        }

        if (step == 624)
        {
            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();
        }

        if (step == 632)
        {                       
            var plr:Character = getPlayer("bf-face-left");
            
            principal = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/principal"));
            principal.scale.set(1.15, 1.15);
            principal.updateHitbox();
            principal.setPosition(2500, 150.0);
            gainGS.insert(gainGS.members.indexOf(gainGS.ggfaculty0_Overlay0), principal);
        
            tween.tween(principal, {x: plr.x + 200}, 1,                
                {
                    onComplete: (_tween:FlxTween) ->  
                    {
                        principal.visible = false;
                        plr.visible = false;
                    }
                });
        }
    
        if (step == 648)
        {
            var opp:Character = getOpponent("baldi-mad");
            
            tween.tween(opp, {x: opp.x + 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});
            opp.animation.play("slap", true);
        }
    
        if (step == 656)
        {
            cameraPoint.x -= 150.0;

            gameCamera.snapToTarget();
            
            gameCameraZoom = 1.4;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible =
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            oppStrumline.strums.x = oppStrumline.strums.getCenterX();

            oppStrumline.strums.alpha = 0.0;

            plrStrumline.strums.x = plrStrumline.strums.getCenterX();
            
            var opp:Character = getOpponent("baldi-mad");
            opp.visible = false;

            var plr:Character = getPlayer("bf-face-left");
            plr.visible = false;
            
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-face-back-left"));
            plr.scale.set(2.0, 2.0);      
            plr.setPosition(350.0, 200.0);
            players.add(plr);
           
            gainGS.remove(opponents, true);
            gainGS.insert(gainGS.members.indexOf(gainGS.principalOffice0_Overlay0), opponents);

            gainGS.remove(players, true);
            gainGS.add(players);

            gainGS.ggfaculty0.visible = false;
            gainGS.ggfaculty0_Overlay0.visible = false;
            gainGS.principalOffice0.visible = true;
            gainGS.principalOffice0_Overlay0.visible = true;
        }

        if (step == 896.0)
        {
            gameCameraZoom = 1.3;

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("baldi-mad-angled"));

            opp.scale.set(1.5, 1.5);

            opp.setPosition(100.0, -50.0);

            opponents.add(opp);

            tween.tween(opp, {x: opp.x - 75.0, y: opp.y + 15.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.quadOut});

            var plr:Character = getPlayer("bf-face-back-left");
        }
    
        if (step == 912)
        {
            cameraPoint.centerTo();

            gameCamera.snapToTarget();

            gameCameraZoom = 0.8;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible =
                playField.timerClock.visible = playField.timerNeedle.visible = true;
            
            oppStrumline.strums.x = 45.0;

            oppStrumline.strums.alpha = 1.0;

            plrStrumline.strums.x = FlxG.width - plrStrumline.strums.width - 45.0;

            var plr:Character = getPlayer("bf-face-back-left");
            plr.visible = false;

            var opp:Character = getOpponent("baldi-mad-angled");
            opp.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-walking"));

            var anim:FlxAnimation = plr.animation.getByName("dance");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            plr.setPosition(798.5, 205.5);

            players.add(plr);

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("walk-legs"));

            anim = _plr.animation.getByName("legs");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            anim = _plr.animation.getByName("legs miss");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 2.0 * 0.001);

            _plr.animation.play("legs", true);

            _plr.skipDance = true;

            _plr.skipSing = true;

            _plr.setPosition(plr.x, plr.y);

            players.insert(players.members.indexOf(plr), _plr);

            plr.animation.onFrameChange.add(updateLegStatus);

            var opp:Character = getOpponent("baldi-mad");
            opp.visible = true;
            opp.skipDance = true;
            opp.scale.set(3.0, 3.0);
            opp.setPosition(-845.0, 18.5);
            
            gainGS.remove(opponents, true);
            gainGS.add(opponents);

            gainGS.principalOffice0.visible = false;
            gainGS.principalOffice0_Overlay0.visible = false;
        
            gainGS.scrollingHall0.active = true;
            gainGS.scrollingHall0.visible = true;
            gainGS.scrollingHall0.velocity.set(-1560.0, 0.0);
        }

        if (step == 1040.0)
        {
            gameCameraZoom = 0.75;
        }

        if (step == 1152.0)
        {
            var plr:Character = getPlayer("bf-walking");

            var _plr:Character = getPlayer("walk-legs");

            tween.tween(plr, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.sineIn, 
                onUpdate: (tween:FlxTween) -> {_plr.x = plr.x;}});

            tween.tween(plr.animation, {timeScale: 1.25}, conductor.beatLength * 0.001, {ease: FlxEase.sineIn});

            tween.tween(_plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001 * 0.001, {ease: FlxEase.sineIn});
        }

        if (step == 1168.0)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCameraZoom = 1.0;

            var plr:Character = getPlayer("bf-walking");

            plr.visible = false;

            var _plr:Character = getPlayer("walk-legs");

            _plr.visible = false;

            var __plr:Character = getPlayer("bf-face-left");

            __plr.visible = true;

            __plr.scale.set(2.5, 2.5);

            __plr.setPosition(520.0, 155.0);

            cameraPoint.centerTo(__plr);

            cameraPoint.y -= 70.0;

            gameCamera.snapToTarget();

            gainGS.scrollingHall0.visible = false;

            gainGS.phoneHall0.visible = true;
        }

        if (step == 1264.0)
        {
            cameraPoint.centerTo();

            gameCameraZoom = 0.75;

            var opp:Character = getOpponent("baldi-mad");

            tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.35 * 0.001);
        }

        if (step == 1268.0)
        {
            var opp:Character = getOpponent("baldi-mad");

            tween.tween(opp, {x: -opp.width * 1.85}, 0.5, {startDelay: 1.0, ease: FlxEase.quartIn});

            var _opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("gotta-sweep"));

            _opp.skipSing = true;

            _opp.setPosition(-_opp.width, -100.0);

            opponents.add(_opp);

            tween.tween(_opp, {x: opp.x -50.0}, 0.5, {startDelay: 0.5, ease: FlxEase.quartOut,
                onComplete: (_tween:FlxTween) -> {tween.tween(_opp, {x: -opp.width * 2}, 0.5, {ease: FlxEase.quartIn});}});
        }

        if (step == 1296.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible =
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            tween.color(temperature, conductor.beatLength * 7.0 * 0.001, temperature.color, 0xFF000000,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
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
                    tween.tween(opp, {y: opp.y + 2.25}, conductor.beatLength * 0.275 * 0.001);
    
                    opp.animation.play("slap", true);
                }
            }
    
        if (beat >= 80.0 && beat < 112.0)
            {
                if (beat % 4 == 0.0)
                {
                    var opp:Character = getOpponent("baldi-mad-face-front");
        
                    tween.tween(opp.scale, {x: opp.scale.x + 0.225, y: opp.scale.y + 0.225}, 
                        conductor.beatLength * 0.275 * 0.001);
        
                    tween.tween(opp, {x: opp.x + 40, y: opp.y + 5}, conductor.beatLength * 0.275 * 0.001);
        
                    opp.animation.play("slap", true);
                }
            }
        
        if (beat >= 228.0 && beat < 292.0)
        {
            if (beat % 4.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad");
                
                tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.35 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 725.0}, 0.5);}});
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