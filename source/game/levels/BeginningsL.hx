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

import core.Assets;
import core.Options;
import core.Paths;

import data.CharacterData;

import game.events.FocusCamPointEvent;

import game.stages.BeginningsS;

using util.MathUtil;

using StringTools;

class BeginningsL extends PlayState
{
    public var beginningsS:BeginningsS;

    override function create():Void
    {
        stage = new BeginningsS();

        beginningsS = cast (stage, BeginningsS);

        beginningsS.testRoom.visible = true;

        super.create();

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCameraZoom = 1.0;

        spectator.scale.set(1.0, 1.0);

        spectator.setPosition(425.0, 110.0);

        opponent.scale.set(1.5, 1.5);

        opponent.setPosition(-185.0, -150);

        player.scale.set(1.75, 1.75);

        player.setPosition(beginningsS.testRoom.x + beginningsS.testRoom.width - player.width, -25.0);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 16.0 || step == 19.0 || step == 22.0)
            gameCameraZoom += 0.05;

        if (step == 16.0)
        {
            var opp:Character = getOpponent("placeface");
            
            opp.skipDance = true;
        }
        
        if (step == 18.0)
        {
            var opp:Character = getOpponent("placeface");

            opp.animation.play("elephant");
        }
    
        if (step == 32)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 0.8;
            
            var opp:Character = getOpponent("placeface");
            opp.skipDance = false;
        }
    
        if (step == 288)
        {
            gameCameraZoom = 1;
        }
    
        if (step == 416)
        {
            tween.tween(this, {gameCameraZoom: 0.8}, 0.25,
                {
                    ease: FlxEase.backIn
                }
            );
        }
        
        if (step == 420)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 1;
        }
       
        if (step == 480)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }
    
        if (step == 544)
        {
            gameCameraZoom = 0.8;
        }
    
        if (step == 800)
        {
            gameCameraZoom = 1.15;
        }
        
        if (step == 816)
        {
            gameCameraZoom = 0.8;
        }
    }
}