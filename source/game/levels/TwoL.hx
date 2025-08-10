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

        gameCamZoomStrength = 0.0;

        hudCamZoomStrength = 0.0;

        countdown.skip();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        playField.visible = false;

        gameCameraZoom = 1.0;
        
        player.setPosition(700, 125);
        player.visible = false;

        opponent.setPosition(100.0, -148.0);
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