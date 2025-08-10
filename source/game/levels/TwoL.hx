package game.levels;

import flixel.animation.FlxAnimation;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import core.AssetCache;

import core.Paths;

import core.Options;

import data.CharacterData;

import flixel.addons.display.FlxBackdrop;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.TwoS;

using util.MathUtil;

using StringTools;

class TwoL extends PlayState
{
    public var twoS:TwoS;

    public var black:FlxSprite;

    override function create():Void
    {
        stage = new TwoS();

        twoS = cast (stage, TwoS);

        super.create();

        black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);

        black.scale.set(960.0, 720.0);

        black.updateHitbox();

        black.screenCenter();

        add(black);

        black.visible = false;

        gameCamZoomStrength = 0.0;

        hudCamZoomStrength = 0.0;

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.25;
        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

        countdown.skip();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        twoS.plus.visible = false;

        twoS.noise.visible = false;

        playField.visible = false;

        gameCameraZoom = 1.0;
        
        player.setPosition(700, 125);
        player.visible = false;

        opponent.setPosition(100.0, -148.0);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 256)
        {
            black.visible = true;
        }
    
        if (step == 260)
        {
            opponent.alpha = 1.0;

            playField.visible = true;

            black.visible = false;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 768)
        {
            twoS.plus.visible = true;
            twoS.plus.animation.play("0");
            tween.tween(twoS.plus, {alpha: 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1024)
            tween.tween(twoS.plus, {alpha: 0.35}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

        if (step == 1032)
            tween.tween(twoS.plus, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

        if (step == 1280)
        {
            twoS.noise.visible = true;
            twoS.noise.animation.play("1");
            tween.tween(twoS.noise, {alpha: 0.35}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }
        
        if (step == 1536)
        {
            opponent.alpha = 0.0;

            playField.visible = false;

            black.visible = true;

            twoS.noise.alpha = 1.0;

            tween.tween(twoS.noise, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            black.alpha = 0.0;

            tween.tween(black, {alpha: 0.9}, conductor.beatLength * 16.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 1600)
            tween.tween(black, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 1616)
        {
            opponent.alpha = 1.0;

            tween.tween(black, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});
            
            twoS.noise.alpha = twoS.plus.alpha = 0.75;
        }
    }
}