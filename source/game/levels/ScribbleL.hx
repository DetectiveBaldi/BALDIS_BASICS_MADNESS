package game.levels;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.ScribbleS;

using util.MathUtil;

using StringTools;

class ScribbleL extends PlayState
{
    public var scribbleS:ScribbleS;

    override function create():Void
    {
        stage = new ScribbleS();

        scribbleS = cast (stage, ScribbleS);

        super.create();
        
        playField.scoreClip.visible = false;
        
        playField.scoreTxt.textField.sharpness = 0;
        playField.scoreTxt.x = playField.scoreTxt.x - 50;
        
        var plrStrumlineX:Float = plrStrumline.strums.x;
        
        var oppStrumlineX:Float = oppStrumline.strums.x;

        plrStrumline.strums.x = oppStrumlineX;
        
        oppStrumline.strums.x = plrStrumlineX;

        scribbleS.classicHall0.visible = true;

        player.scale.set(3.75, 3.75);
        player.setPosition(700, 100);

        opponent.setPosition(1050, 200);

        setCamStartPos();
    }

    override function beatHit(beat:Int):Void
    {
        var player:String;
        
        super.beatHit(beat);
    
        if (cameraTarget == "idc")
        {
            trace("AAAAAAAAAAH");
        }

    }
   
    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    }
}