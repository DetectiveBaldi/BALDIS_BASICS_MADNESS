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

import game.stages.ViralSS;

using StringTools;

using flixel.util.FlxColorTransformUtil;

using util.MathUtil;
using util.PlayFieldTools;

class ViralSL extends PlayState
{
    public var viralSS:ViralSS;

    override function create():Void
    {
        stage = new ViralSS();

        viralSS = cast (stage, ViralSS);

        super.create();

        viralSS.space.visible = true;

        gameCamBopStrength = 0.0;

        hudCamBopStrength = 0.0;

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.0;
        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCameraZoom = 1.0;
        
        player.setPosition(700, 125);
        player.visible = false;

        opponent.screenCenter();
        opponent.y += 35.0;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 272)
        {
            opponent.skipDance = true;

            opponent.animation.play("talk0");

            playField.setVisible(false);
        }

        if (step == 336)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.setVisible(true);

            opponent.skipDance = false;
        }

        if (step == 576)
        {
            opponent.skipDance = true;

            opponent.animation.play("frown");
        }

        if (step == 1096)
            opponent.animation.play("smile");

        if (step == 1104 || step == 1336)
            opponent.skipDance = false;

        if (step == 1232)
        {
            tweens.tween(hudCamera, {alpha: 0.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1244)
            plrStrumline.botplay = true;

        if (step == 1273)
        {
            opponent.skipDance = true;

            opponent.animation.play("talk1");
        }

        if (step == 1344)
        {
            tweens.tween(opponent.scale, {x: 0.0, y: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(opponent, {angle: 180.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1360)
            opponent.visible = false;
    }
}