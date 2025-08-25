package game.levels.classicw;

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

import game.stages.classicw.HugsS;

using util.MathUtil;

using StringTools;

class HugsL extends PlayState
{
    public var hugsS:HugsS;

    override function create():Void
    {
        stage = new HugsS();

        hugsS = cast (stage, HugsS);

        super.create();

        hugsS.hall.visible = true;

        hugsS.doorStandard.visible = true;

        hugsS.doorStandard.x = 600.0;
    
        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCamera.color = 0x000000;

        gameCameraZoom = 0.6;

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

        player.setPosition(-1000.0, 140.0);

        opponent.setPosition(200.0, -180.0);

        var oppStrumlineX:Float = oppStrumline.strums.x;

        var plrStrumlineX:Float = plrStrumline.strums.x;

        oppStrumline.strums.x = plrStrumlineX;

        plrStrumline.strums.x = oppStrumlineX;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 16.0 * 0.001, true);

            tween.tween(opponent, {x: 450.0}, conductor.beatLength * 8.0 * 0.001);
        }

        if (step == 16)
            tween.tween(player, {x: -260.0}, conductor.beatLength * 12.0 * 0.001, {ease: FlxEase.quartOut});

        if (step == 64)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            var opp:Character = getOpponent("1st-prize-270");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-292-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 96)
        {
            var opp:Character = getOpponent("1st-prize-292-5");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-315"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 128)
        {
            var opp:Character = getOpponent("1st-prize-315");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-337-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 160)
        {
            var opp:Character = getOpponent("1st-prize-337-5");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-0"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 192)
        {
            var opp:Character = getOpponent("1st-prize-0");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-22-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 224)
        {
            var opp:Character = getOpponent("1st-prize-22-5");
            opp.visible = false;
      
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-45"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 256)
        {
            var opp:Character = getOpponent("1st-prize-45");
            opp.visible = false;
      
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-67-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 288)
        {
            var opp:Character = getOpponent("1st-prize-67-5");
            opp.visible = false;
     
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-90"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -180.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 306)
            tween.tween(opponent, {x: -1500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 316)
            tween.tween(player, {x: -800.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 320)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            hugsS.hallcorner2.visible = false;

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;
            
            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            var opp:Character = getOpponent("1st-prize-90");
            opp.visible = false;

            var opp:Character = getOpponent("1st-prize-270");
            opp.x = -1500.0;
            opp.visible = true;
            opponent = opp;

            hugsS.hall.velocity.set(-3840.0, 0.0);
            hugsS.doorStandard.visible = false;

            player.x = -800.0;

            tween.tween(opponent, {x: -100.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(player, {x: 500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }
        
        if (step == 576)
            gameCameraZoom += 0.1;

        if (step == 697)
        {
            hugsS.hallcorner2.visible = true;

            hugsS.hallcorner2.velocity.x = -3840.0;

            hugsS.hallcorner2.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 704)
        {
            hugsS.hall.velocity.x = hugsS.hallcorner2.velocity.x = 0;

            var opp:Character = getOpponent("1st-prize-270");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-225"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(-100.0, -180.0);
            opponents.add(opp);
            opponent = opp;

            hugsS.remove(players, true);
            hugsS.insert(hugsS.members.indexOf(opponents), players);

            tween.tween(player.scale, {x: 2.4, y: 2.4}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(player, {x: 190.0, y: 110.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 720)
        {
            var opp:Character = getOpponent("1st-prize-225");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-180"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(-100.0, -180.0);
            opponents.add(opp);
            opponent = opp;

            tween.tween(opponent.scale, {x: 2.0, y: 2.0}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player.scale, {x: 1.5, y: 1.5}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(opponent, {x: -95.0, y: -250.0}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player, {x: 192.0, y: 80.0}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 736)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            hugsS.hallcorner2.visible = false;

            var opp:Character = getOpponent("1st-prize-180");
            opp.visible = false;

            player.y = 140.0;
            player.scale.set(2.7, 2.7);

            var opp:Character = getOpponent("1st-prize-270");
            opp.x = -1500.0;
            opp.visible = true;
            opponent = opp;

            hugsS.hall.velocity.set(-3840.0, 0.0);

            player.x = -800.0;

            hugsS.remove(opponents, true);
            hugsS.insert(hugsS.members.indexOf(players), opponents);

            tween.tween(opponent, {x: -100.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(player, {x: 500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 992)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCameraZoom += 0.2;
        }

        if (step == 1110)
        {
            hugsS.hallcorner4.visible = true;

            hugsS.hallcorner4.velocity.x = -3840.0;

            hugsS.hallcorner4.x = gameCamera.viewX + gameCamera.viewWidth;   
        }

        if (step == 1116)
            hugsS.hall.velocity.x = hugsS.hallcorner4.velocity.x = 0.0;

        if (step == 1120)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            hugsS.hallcorner4.visible = false;

            var opp:Character = getOpponent("1st-prize-180");
            opp.visible = false;
        }
    }
}