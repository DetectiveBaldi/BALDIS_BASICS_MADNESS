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
        oppStrumline.strums.alpha = 0.25;
        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCameraZoom = 1.0;
        
        player.setPosition(700, 125);
        player.visible = false;

        opponent.setPosition(200.0, -78.0);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        
    }
}