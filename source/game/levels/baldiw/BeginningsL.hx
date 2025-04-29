package game.levels.baldiw;

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

import game.stages.Mystery;

using util.MathUtil;

using StringTools;

class BeginningsL extends PlayState
{
    public var castedStage(get, never):Mystery;

    @:noCompletion
    function get_castedStage():Mystery
    {
        return cast (stage, Mystery);
    }

    override function create():Void
    {
        stage = new Mystery();

        super.create();

        CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5 + 200.0,
            (FlxG.height - gameCameraTarget.height) * 0.5 + 0.0, "", -1.0);

        gameCamera.snapToTarget();

        gameCameraZoom = 0.8;

        castedStage.testRoom.visible = true;
        
        var spectator:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("mystery/placeface-anim-spectate"));
        spectator.scale.set(1, 1);
        spectator.setPosition(125.0, -235.0);
        castedStage.insert(castedStage.members.indexOf(opponents), spectator);

        players.scale.set(2, 2);
        players.setPosition(750, 100);

        opponents.scale.set(1.5, 1.5);
        opponents.setPosition(-200, -150);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 16)
        {
            gameCameraZoom = 1;

            var opp:Character = getOpponent("placeface0");
            opp.skipDance = true;
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
    
        if (step == 464)
        {
            CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5 - 400.0,
                (FlxG.height - gameCameraTarget.height) * 0.5 + 0.0, "", -1.0);
        }
   
       
        if (step == 480)
        {
            if (Options.flashing)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5 + 400.0,
                (FlxG.height - gameCameraTarget.height) * 0.5 + 0.0, "", -1.0);
        }
    
        if (step == 544)
        {
            gameCameraZoom = 0.6;
        }
    
        if (step == 816)
        {
            gameCameraZoom = 0.8;
        }
    }
}