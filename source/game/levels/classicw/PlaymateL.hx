package game.levels.classicw;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;

import flixel.math.FlxRect;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.PlaymateS;

using util.MathUtil;

using StringTools;

class PlaymateL extends PlayState
{
    public var playmateS:PlaymateS;

    public var black:FlxSprite;

    public var opp:Character;

    public var jumpMinigame:JumpRopeMinigame;

    public var jumpUI:JumpRopeUI;

    override function create():Void
    {
        stage = new PlaymateS();

        playmateS = cast (stage, PlaymateS);

        super.create();

        playmateS.cafe.visible = true;

        playmateS.hall.visible = true;

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        gameCamera.snapToTarget();

        gameCameraZoom = 0.75;

        player.setPosition(700.0, 150.0);

        opponent.setPosition(-1500.0, 190.0);

        gameCamera.color = FlxColor.BLACK;

        playField.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 32.0 * 0.001, true);
        }

        if (step == 128)
        {
            opponent.skipDance = true;
            
            opponent.animation.play("play");

            tween.tween(opponent, {x: -80.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 142)
            cameraLock = FOCUS_CAM_CHAR;

        if (step == 144 || step == 656)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            opponent.skipDance = false;

            playField.visible = true;

            gameCameraZoom = 0.65;
        }

        if (step == 392 || step == 520 || step == 648 || step == 1304)
            gameCameraZoom = 0.8;

        if (step == 400 || step == 528 || step == 1312)
        {
            gameCameraZoom -= 0.05;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 912)
        {
            gameCameraZoom = 0.8;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;
        }

        if (step == 928)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.7;

            oppStrumline.strums.alpha = 0.0;

            plrStrumline.strums.alpha = 0.0;

            playmateS.hall.color = playmateS.cafe.color = 0xADADAD;
        }
        
        if (step == 1040)
        {
            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});

            tween.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 1168)
        {
            tween.tween(this, {gameCameraZoom: 0.55}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1184)
        {
            playmateS.hall.color = playmateS.cafe.color = 0x777777;

            opp = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad-face-front"));
            opp.setPosition(650.0, 110.0);
            opp.scale.set(0.95, 0.95);
            opp.skipDance = true;
            opp.skipSing = true;
            opp.animation.play("slap");
            add(opp);

            remove(opp, true);
            playmateS.insert(playmateS.members.indexOf(playmateS.hall), opp);

            tween.tween(opp, {x: 400.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom = 0.8;
        }

        if (step == 1200)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 120.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1188)
        {
            playmateS.hall.color = playmateS.cafe.color = 0xFFFFFF;

            gameCameraZoom = 0.7;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 1440)
        {   
            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();

            gameCameraZoom = 0.6;
            
            opp = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad"));
            opp.setPosition(-700.0, 30.0);
            opp.scale.set(2.9, 2.9);
            opp.skipDance = true;
            opp.skipSing = true;
            opp.animation.play("slap");
            add(opp);

            tween.tween(opp, {x: -300.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1456)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 0.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom += 0.05;
        }

        if (step == 1464)
            tween.tween(player, {x: 1600.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 1472)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 400.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            gameCameraZoom = 0.7;
        }

        if (step == 1488)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 800.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(opponent, {x: -1200.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 8.0 * 0.001, false);
        }

        if (step == 1504)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 1300.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 360 && beat < 368)
        {
            if (beat % 2 == 0)
                gameCameraZoom += 0.025;
        }
    }
}

class JumpRopeMinigame extends FlxBasic
{
    public function new():Void
    {
        super();
    }
}

class JumpRopeUI extends FlxGroup
{

}