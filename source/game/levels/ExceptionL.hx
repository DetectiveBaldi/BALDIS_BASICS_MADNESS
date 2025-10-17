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

import game.stages.ExceptionS;

using StringTools;

using flixel.util.FlxColorTransformUtil;

using util.MathUtil;
using util.PlayFieldTools;

class ExceptionL extends PlayState
{
    public var exceptionS:ExceptionS;

    override function create():Void
    {
        stage = new ExceptionS();

        exceptionS = cast (stage, ExceptionS);

        super.create();

        exceptionS.bg.visible = true;

        exceptionS.bg.animation.play("off");

        gameCamBopStrength = 0.0;

        hudCamBopStrength = 0.0;

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.25;
        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        countdown.skip();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        playField.setVisible(false);

        playField.strumlines.visible = false;

        gameCameraZoom = 1.0;
        
        player.setPosition(700, 125);

        player.visible = false;

        opponent.setPosition(160.0, 0.0);

        opponent.visible = false;

        plrStrumline.botplay = true;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 16)
            exceptionS.bg.animation.play("on");

        if (step == 32)
        {
            playField.strumlines.visible = true;

            opponent.visible = true;

            exceptionS.bg.animation.play("room");

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 216 || step == 408 || step == 432 || step == 496 || step == 636)
            exceptionS.bg.color = 0x3A3A3A;

        if (step == 224 || step == 416 || step == 434 || step == 498 || step == 640)
            exceptionS.bg.color = 0xFFFFFF;

        if (step == 552)
        {
            opponent.visible = false;

            plrStrumline.botplay = true;

            plrStrumline.resetStrums();

            plrStrumline.strums.alpha = 0.0;
            oppStrumline.strums.alpha = 0.0;

            if (Options.flashingLights)
                exceptionS.bg.animation.play("g0");
            else
                exceptionS.bg.animation.play("gep");
        }

        if (step == 680 || step == 744 || step == 808 || step == 872)
        {
            if (Options.flashingLights)
                exceptionS.bg.animation.play("g2");
        }

        if (step == 648)
            exceptionS.text.visible = true;

        if (step >= 648 && step <= 888)
        {
            if (step % 32 == 8.0)
            {
                exceptionS.text.animation.play("textjump");
            }
        }

        if (step == 664 || step == 696 || step == 708 || step == 766 || step == 792 || step == 856)
            exceptionS.text.animation.play("textleft");

        if (step == 664 || step == 702 || step == 728 || step == 760 || step == 824)
            exceptionS.text.animation.play("textright");

        if (step >= 888 && step < 900)
        {
            if (step % 3 == 0.0)
            {
                exceptionS.text.animation.play("textleft");
            }
        }

        if (step == 900)
        {
            if (Options.flashingLights)
            {
                exceptionS.bg.animation.play("gf");
            }
            else
            {
                tweens.tween(exceptionS.bg, {alpha: 0.0}, conductor.beatLength * 1.0 * 0.001);
            }
            
            exceptionS.text.animation.play("textgone");
        }

        if (step == 906)
        {
            exceptionS.bg.animation.play("gn");

            exceptionS.text.visible = false;

            exceptionS.bg.alpha = 1.0;
        }

        if (step == 920)
        {
            var opp:Character = new Character(this, 0.0, 0.0, Character.getConfig("null-death"));
            opp.scale.set(1.3, 1.3);
            opp.updateHitbox();
            opp.screenCenter();
            opp.alpha = 0.0;
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 924)
            tweens.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001);

        if (step == 940)
        {
            tweens.tween(opponent, {alpha: 1.0}, conductor.beatLength * 1.0 * 0.001);

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 944)
            exceptionS.bg.animation.play("nl");

        if (step == 1118)
        {
            opponent.skipSing = true;

            opponent.skipDance = true;

            opponent.animation.play("die");
        }

        if (step == 1126)
            opponent.visible = false;

        if (step == 1136)
        {
            plrStrumline.botplay = true;

            exceptionS.bg.animation.play("ni");

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 8.0 * 0.001);

            tweens.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 8.0 * 0.001);
        }

        if (step == 1168)
            exceptionS.bg.animation.play("ne");

        if (step == 1264)
            exceptionS.bg.alpha = 0.0;

        if (step == 1280)
        {
            exceptionS.bg.animation.play("pc");

            tweens.tween(exceptionS.bg, {alpha: 1.0}, conductor.beatLength * 3.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 1312)
        {
            tweens.tween(exceptionS.bg, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 58 && beat <= 64 || beat >= 66 && beat <= 70)
        {
            if (beat % 2 == 1.0)
            {    
                exceptionS.bg.color = 0xFF7979;
            }
            if (beat % 2 == 0.0)
            {    
                exceptionS.bg.color = 0xFFFFFF;
            }
        }

        if (beat >= 162 && beat <= 222)
        {
            if (Options.flashingLights)
            {
                if (beat % 8 == 2.0)
                {
                    if (beat % 4 == 2.0)
                    {
                        exceptionS.bg.animation.play("g1");
                    }
                }
            }
        }
    }
}