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
import game.notes.Note;
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

        cameraPoint.y += 75.0;
        
        gameCameraZoom = 0.8;

        gameCamera.snapToTarget();

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
            playField.timerNeedle.visible = false;

        playField.strumlines.visible = false;

        literatureS.hall0.visible = true;
    
        player.setPosition(600.0, 190.0);
    
        opponent.setPosition(-50.0, -100.0);

        opponent.skipDance = true;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 16)            
            opponent.animation.play("talk");
        
        if (step == 88)
        {
            tween.tween(opponent, {x: 1200.0, y: -120.0}, conductor.beatLength * 4.5 * 0.001, {ease: FlxEase.quadIn});

            tween.tween(opponent.scale, {x: 0.75, y: 0.75}, conductor.beatLength * 4.5 * 0.001, {ease: FlxEase.quadIn});
        }

        if (step == 112)
        {
            tween.tween(this, {gameCameraZoom: 1.2}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});
            
            opponent.skipDance = false;
        }

        if (step == 128)
        {
            opponent.scale.set(1.5, 1.5);
            opponent.x = -250.0;

            player.setPosition(700.0, 180.0);

            tween.tween(player, {x: 515.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            literatureS.remove(players, true);

            literatureS.insert(literatureS.members.indexOf(literatureS.chairs), players);

            cameraLock = FOCUS_CAM_CHAR;
           
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = true;

            playField.strumlines.visible = true;
           
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        
            literatureS.hall0.visible = false;

            literatureS.classroom.visible = true;

            literatureS.chairs.visible = true;
        }

        if (step == 512)
            gameCameraZoom = 0.75;

        if (step == 640)
        {
            tween.tween(this, {gameCameraZoom: 1.1}, conductor.beatLength * 16.0 * 0.001);
            
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            opponent.skipDance = true;

            opponent.animation.play("talk");
        }

        if (step == 736)
        {
            gameCameraZoom = 0.75;
            
            tween.tween(player, {x: 1500.0, y: 140.0}, conductor.beatLength * 7.9 * 0.001, {ease: FlxEase.quartIn});
        
            tween.tween(player.scale, {x: 0.8, y: 0.8}, conductor.beatLength * 7.9 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 768)
        {
            FlxG.camera.visible = false;

            var plr:Character = getPlayer("bf-baldina");
            plr.visible = false;

            var opp:Character = getOpponent("baldina-happy");
            opp.skipDance = false;
            opp.visible = false;
        }

        if (step == 776)
        {
            FlxG.camera.visible = true;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldina-angry"));
            opp.visible = false;
            opp.setPosition(650.0, -130.0);
            opp.scale.set(1.2, 1.2);
            opponents.add(opp);
            opponent = opp;
            
            updateHealthBar("opponent");

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-baldina-flipped"));
            plr.setPosition(-50.0, 155.0);
            plr.scale.set(1.2, 1.2);
            players.add(plr);
            player = plr;

            literatureS.classroom.visible = false;

            literatureS.chairs.visible = false;
           
            literatureS.sky.visible = true;

            literatureS.clouds.visible = true;

            literatureS.clouds.velocity.set(-30.0, 0.0);

            literatureS.hall1.visible = true;

            var oppStrumlineX:Float = oppStrumline.strums.x;
            var plrStrumlineX:Float = plrStrumline.strums.x;

            oppStrumline.strums.x = plrStrumlineX;
            plrStrumline.strums.x = oppStrumlineX;
        }

        if (step == 888)
        {
            cameraLock = FOCUS_CAM_POINT;

            SetCamFocusEvent.dispatch(this, 0.0, 0.0, "opponent", -1.0, "linear", true);

            opponent.visible = true;

            opponent.x = 1800;

            tween.tween(opponent, {x: 650.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            opponent.animation.play("talk");
        }

        if (step == 904)
        {
            cameraLock = FOCUS_CAM_CHAR;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 1288)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            literatureS.hall1.color = 0xACACAC;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            tween.tween(this, {gameCameraZoom: 1.2}, conductor.beatLength * 31.9 * 0.001);
        }

        if (step == 1416)
            FlxG.camera.visible = false;

        if (step == 1432)
        {
            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1464)
        {
            FlxG.camera.visible = true;
            
            opponent.visible = false;

            player.visible = false;

            cameraLock = FOCUS_CAM_CHAR;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldina-dance"));
            opp.scale.set(1.5, 1.5);
            opponents.add(opp);
            opponent = opp;

            updateHealthBar("opponent");

            var plr:Character = getPlayer("bf-baldina");
            plr.scale.set(1.5, 1.5);
            plr.visible = true;
            player = plr;

            opponent.setPosition(-200.0, -100.0);

            player.setPosition(515.0, 180.0);

            literatureS.remove(players, true);

            literatureS.insert(literatureS.members.indexOf(literatureS.chairs), players);

            cameraLock = FOCUS_CAM_CHAR;

            gameCameraZoom = 0.8;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
           
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        
            literatureS.hall1.visible = false;

            literatureS.clouds.visible = false;

            literatureS.sky.visible = false;

            literatureS.classroom.visible = true;

            literatureS.chairs.visible = true;
        }

        if (step == 1592)
            gameCameraZoom += 0.1;

        if (step == 1712)
            gameCameraZoom = 0.7;

        if (step == 1716)
        {
            gameCameraZoom = 0.8;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            player.skipDance = true;
            player.animation.play("ay");
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 32 && beat < 160)
            if (cameraCharTarget == "OPPONENT")
                gameCameraZoom = 0.9;
            else
                gameCameraZoom = 0.8;

        if (beat >= 120 && beat <= 128 || beat >= 152 && beat <= 160)
        {
            if (beat % 2 == 0)
                gameCameraZoom += 0.1;
        }
    }
}