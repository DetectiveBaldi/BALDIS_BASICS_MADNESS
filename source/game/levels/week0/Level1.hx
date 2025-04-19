package game.levels.week0;

import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ShaderFilter;

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

import game.stages.School;

using util.MathUtil;

using StringTools;

class Level1 extends PlayState
{
    public var castedStage(get, never):School;

    @:noCompletion
    function get_castedStage():School
    {
        return cast (stage, School);
    }

    public var quarter:FlxSprite;

    override function create():Void
    {
        stage = new School();

        super.create();

        gameCameraTarget.centerTo();

        gameCameraZoom = 1;
    
        CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5 - 300.0,
            (FlxG.height - gameCameraTarget.height) * 0.5, "", -1.0);

        gameCamera.snapToTarget();

        castedStage.entranceA1.visible = true;
        
        quarter = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("globals/quarter"))));
        quarter.setPosition(15.0, 350.0);
        add(quarter);

        tween.tween(quarter, {y: quarter.y - 50}, 0.75, {ease: FlxEase.sineInOut, type: PINGPONG});

        players.setPosition(125.0, 175.0);
        opponents.setPosition(75.0, 250.0);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
        trace(step);

        if (step == 676)
        {
            if (!Options.middlescroll)
                {
                    var oppStrumlineX:Float = oppStrumline.strums.x;
    
                    var plrStrumlineX:Float = plrStrumline.strums.x;
    
                    tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
    
                    tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
                }
            
            gameCameraZoom = 0.8;
            
            CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5 + 300.0,
                (FlxG.height - gameCameraTarget.height) * 0.5 + 50, "", -1.0);

            castedStage.entranceA1.visible = false;
            castedStage.entranceA2.visible = true;

            quarter.scale.set(2, 2);
            quarter.setPosition(1200.0, 350.0);

            var plr:Character = getPlayer("bf3");
            plr.visible = false;
        
            var opp:Character = getOpponent("baldi1");
            opp.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf1"));
            plr.scale.set(4, 4);
            plr.setPosition(-100.0, 50.0);
            players.add(plr);
        }
    
        if (step == 1216)
        {
            playField.scoreClip.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
            
            playField.scoreTxt.color = FlxColor.WHITE;

            gameCameraTarget.centerTo();
            gameCamera.snapToTarget();

            gameCameraZoom = 1;
        
            castedStage.entranceA2.visible = false;
            tween.cancelTweensOf(quarter);
            quarter.visible = false;

            var plr:Character = getPlayer("bf1");
            plr.visible = false;

            var opp:Character = getOpponent("baldi1");
            opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("classic-remastered/baldi2"));
            opp.setPosition(275.0, 235.0);
            opponents.add(opp);
    
            var thinkpad:FlxSprite;
            thinkpad = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("globals/thinkpad"))));
            thinkpad.scale.set(2, 2);
            thinkpad.screenCenter();
            add(thinkpad);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    }
}