package game.levels.bladderw;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.stages.bladderw.WallsS;

using util.MathUtil;
using util.PlayFieldTools;

using StringTools;

class WallsL extends PlayState
{
    public var wallsS:WallsS;

    override function create():Void
    {
        stage = new WallsS();

        wallsS = cast (stage, WallsS);

        super.create();

        playField.setVisible(false);

        playField.strumlines.visible = false;
            
        oppStrumline.visible = false;
        oppStrumline.strums.visible = false;

        wallsS.room0_Alt0.visible = true;
       
        player.setPosition(300, 100);
        
        opponent.scale.set(1.2, 1.2);
        opponent.setPosition(280, -25);
        opponent.visible = false;
    
        gameCameraZoom = 1.4;

        setCamStartPos();
    
        cameraLock = FOCUS_CAM_POINT;

        plrStrumline.botplay = true;
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
            var plr:Character = getPlayer("bf-face-back-right");
            plr.skipDance = false;

            var opp:Character = getOpponent("bladder-side");
            opp.skipDance = true;
            opp.animation.play("spin");

            opponent.visible = true;
            
            wallsS.room0_Alt0.visible = false;
            
            wallsS.room0.visible = true;
            
            wallsS.remove(opponents, true);
            wallsS.insert(wallsS.members.indexOf(wallsS.room0_Overlay0), opponents);
            wallsS.room0_Overlay0.visible = true;
        }

        if (step == 16)
        {            
            playField.setVisible(true);

            playField.strumlines.visible = true;

            plrStrumline.botplay = Options.botplay;
        
            gameCameraZoom = 1.3;

            var opp:Character = getOpponent("bladder-side");
            opp.skipDance = false;
        }
  
        if (step == 272 || step == 560 || step == 624 || step == 912) 
        {
            gameCameraZoom = 1;
        }

        if (step == 556 || step == 620) 
        {
            gameCameraZoom = 1.35;
        }

        if (step == 784)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 1.3;
                        
            wallsS.room0.visible = false;
            wallsS.room0_Overlay0.visible = false;
        
            wallsS.room1.visible = true;
            
            wallsS.remove(opponents, true);
            wallsS.insert(wallsS.members.indexOf(players), opponents);

            wallsS.remove(players, true);
            wallsS.insert(wallsS.members.indexOf(wallsS.room1_Overlay0), players);
            wallsS.room1_Overlay0.visible = true;

            var plr:Character = getPlayer("bf-face-back-right");
            plr.visible = false;

            var opp:Character = getOpponent("bladder-side");
            opp.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-left"));
            plr.scale.set(1.75, 1.75);
            plr.setPosition(450, 50);
            players.add(plr);

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bladder-back"));
            opp.scale.set(3, 3);
            opp.setPosition(150, 50);
            opponents.add(opp);
        }

        if (step == 1424)
        {
            gameCameraZoom = 1.5;
        }

        if (step == 1432)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 1;

            wallsS.remove(opponents, true);
            wallsS.insert(wallsS.members.indexOf(wallsS.room0_Overlay0), opponents);

            var plr:Character = getPlayer("bf-face-left");
            plr.visible = false;

            var opp:Character = getOpponent("bladder-back");
            opp.visible = false;

            var plr:Character = getPlayer("bf-face-back-right");
            plr.visible = true;

            var opp:Character = getOpponent("bladder-side");
            opp.visible = true;

            wallsS.room1.visible = false;
            wallsS.room1_Overlay0.visible = false;
           
            wallsS.room0.visible = true;
            wallsS.room0_Overlay0.visible = true;
        }

        if (step == 1680)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
           
            gameCameraZoom = 1.4;
        }
    }
}