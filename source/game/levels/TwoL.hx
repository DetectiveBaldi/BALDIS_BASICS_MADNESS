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

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.TwoS;

using util.MathUtil;

using StringTools;

class TwoL extends PlayState
{
    public var twoS:TwoS;

    override function create():Void
    {
        stage = new TwoS();

        twoS = cast (stage, TwoS);

        super.create();

        setCamStartPos();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        FlxG.camera.bgColor = FlxColor.WHITE;

        playField.visible = false;

        gameCameraZoom = 0.8;
        
        player.setPosition(700, 125);
        player.visible = false;

        opponent.setPosition(0.0, 0.0);
        opponent.scale.set(3.5, 3.5);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 260)
        {
            playField.visible = true;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }
    }
}