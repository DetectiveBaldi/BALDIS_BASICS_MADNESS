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

import game.stages.MishapS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class MishapL extends PlayState
{
    public var mishapS:MishapS;

    override function create():Void
    {
        stage = new MishapS();

        mishapS = cast (stage, MishapS);

        super.create();
    
        setCamStartPos();

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        mishapS.breadySchool.visible = true;

        player.setPosition(840.0, 315.0);
    
        opponent.setPosition(-200.0, 125.0);
    }

    override function stepHit(step:Int):Void
    {
        if (step == 16)
        {
            opponent.skipDance = true;
            opponent.animation.play("wave");
        }
        
        if (step == 64)
        {
            gameCameraZoom -= 0.2;
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        
            opponent.skipDance = false;
        }
        
        if (step == 320 || step == 452)
        {
            gameCameraZoom -= 0.1;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 448)
            gameCameraZoom += 0.2;
    
        if (step == 576)
        {
            gameCameraZoom = 1;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    }
}