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

import game.events.CameraFollowEvent;

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

        super.create();

        CameraFollowEvent.dispatch(this, gameCameraTarget.getCenterX() + 150.0,
            gameCameraTarget.getCenterY(), "", -1.0);

        gameCamera.snapToTarget();

        gameCameraZoom = 0.8;

        beginningsS.testRoom.visible = true;
        
        var spectator:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("mystery/placeface-anim-spectate"));
        spectator.scale.set(1, 1);
        spectator.setPosition(125.0, -235.0);
        beginningsS.insert(beginningsS.members.indexOf(opponents), spectator);

        players.scale.set(1.75, 1.75);
        players.setPosition(650, -25);

        opponents.scale.set(1.5, 1.5);
        opponents.setPosition(-200, -150);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 16 || step == 19 || step == 22)
        {
            gameCameraZoom += 0.1;
           
            var opp:Character = getOpponent("placeface0");
            opp.skipDance = true;
        }
        
        if (step == 18)
        {
            var opp:Character = getOpponent("placeface0");
            opp.animation.play("elephant");
        }
    
        if (step == 32)
        {
            if (Options.flashing)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 0.8;
            
            var opp:Character = getOpponent("placeface0");
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
            if (Options.flashing)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 1;
        }
       
        if (step == 464)
        {
            CameraFollowEvent.dispatch(this, gameCameraTarget.getCenterX() - 100.0,
                gameCameraTarget.getCenterY(), "", -1.0);
        }
   
       
        if (step == 480)
        {
            if (Options.flashing)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            CameraFollowEvent.dispatch(this, gameCameraTarget.getCenterX() + 150.0,
                gameCameraTarget.getCenterY(), "", -1.0);
        }
    
        if (step == 544)
        {
            gameCameraTarget.centerTo();
            
            gameCameraZoom = 0.6;
        }
    
        if (step == 800)
        {
            CameraFollowEvent.dispatch(this, gameCameraTarget.getCenterX() + 250.0,
                gameCameraTarget.getCenterY(), "", -1.0);
           
            gameCameraZoom = 1.25;
        }
        
        if (step == 816)
        {
            CameraFollowEvent.dispatch(this, gameCameraTarget.getCenterX() + 150.0,
                gameCameraTarget.getCenterY(), "", -1.0);
            
            gameCameraZoom = 0.8;
        }
    }
}