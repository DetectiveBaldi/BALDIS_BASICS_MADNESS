package game.levels.bladderw;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.bladderw.WallsS;

using util.MathUtil;

using StringTools;

class WallsL extends PlayState
{
    public var wallsS:WallsS;

    override function create():Void
    {
        stage = new WallsS();

        wallsS = cast (stage, WallsS);

        super.create();

        playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
            
        oppStrumline.visible = false;
        oppStrumline.strums.visible = false;

        wallsS.room0_Alt0.visible = true;
       
        player.setPosition(300, 100);
        
        opponent.scale.set(1.2, 1.2);
        opponent.setPosition(300, -25);
        opponent.visible = false;
    
        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            var plr:Character = getPlayer("bf-face-back-right");
            plr.skipDance = true;
            plr.animation.play("slap");
        }
       
        if (step == 12)
        {
            wallsS.room0_Alt0.visible = false;
            
            wallsS.room0.visible = true;
            
            wallsS.remove(opponents, true);
            wallsS.insert(wallsS.members.indexOf(wallsS.room0_Overlay0), opponents);
            wallsS.room0_Overlay0.visible = true;
        
            var plr:Character = getPlayer("bf-face-back-right");
            plr.skipDance = false;
            
            var opp:Character = getOpponent("bladder-side");
            opp.skipDance = true;
            opp.animation.play("spin");

            opponent.visible = true;
        }

        if (step == 16)
        {
            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        
            var opp:Character = getOpponent("bladder-side");
            opp.skipDance = false;
        }
    }
}