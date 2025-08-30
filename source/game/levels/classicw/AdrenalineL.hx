package game.levels.classicw;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.AdrenalineS;

using util.MathUtil;

using StringTools;

class AdrenalineL extends PlayState
{
    public var adrenalineS:AdrenalineS;
    
    public var plrStrumlineX:Float;

    public var oppStrumlineX:Float;

    public var noSquee:FlxSprite;
    
    override function create():Void
    {
        stage = new AdrenalineS();

        adrenalineS = cast (stage, AdrenalineS);

        super.create();

        gameCameraZoom = 0.6;

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        playField.visible = false;
        
        plrStrumlineX = plrStrumline.strums.x;

        oppStrumlineX = oppStrumline.strums.x;

        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.25;
       
        adrenalineS.closet.visible = true;
    
        noSquee = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/no-squee"));
        noSquee.scale.set(0.75, 0.75);
        noSquee.updateHitbox();
        noSquee.setPosition(683.0, 350.0);

        tween.tween(noSquee, {y: noSquee.y - 25}, conductor.beatLength * 2.0 * 0.001, 
            {
                ease: FlxEase.sineInOut, 
                type: PINGPONG
            }
        );

        player.scale.set(2.4, 2.4);
        player.setPosition(1600.0, 110.0);

        opponent.scale.set(1.5, 1.5);
        opponent.setPosition(300.0, 50.0);

        adrenalineS.remove(opponents, true);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            player.animation.play("walk");
            player.skipDance = true;
            player.skipSing = true;

            tween.tween(player, {x: 540.0}, conductor.beatLength * 4.0 * 0.001);
        }
    
        if (step == 16)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.visible = true;

            adrenalineS.closet.visible = false;
            
            adrenalineS.closet_Alt.visible = true;
            adrenalineS.closet_Overlay.visible = true;
        
            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.closet_Overlay), noSquee);

            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.closet_Overlay), opponents);

            tween.tween(player, {x: 560.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            player.animation.play("shock");
            player.skipDance = false;
            player.skipSing = false;
        }

        if (step == 288)
        {
            tween.tween(opponent.scale, {x: 2, y: 2}, conductor.beatLength * 0.5 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        adrenalineS.remove(opponents, true);
                        adrenalineS.insert(adrenalineS.members.indexOf(players), opponents);
                        
                        tween.tween(opponent.scale, {x: 2.75, y: 2.75}, conductor.beatLength * 0.5 * 0.001);
                    }
                }
            );
            
            tween.tween(opponent, {y: opponent.y + 65.0}, conductor.beatLength * 1.0 * 0.001,
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        tween.tween(player, {x: 1750}, conductor.beatLength * 1.0 * 0.001);
                        
                        tween.tween(opponent, {x: 1750}, conductor.beatLength * 1.0 * 0.001);
                    }
                }
            );
        }
    
        if (step == 304)
        {
            gameCameraZoom = 0.65;
            
            plrStrumline.strums.x = plrStrumlineX;

            oppStrumline.strums.x = oppStrumlineX;
            oppStrumline.strums.alpha = 1.0;
            
            adrenalineS.closet_Alt.visible = false;
            adrenalineS.closet_Overlay.visible = false;
            
            adrenalineS.hall.visible = true;
            adrenalineS.hall.velocity.set(-3560.0, 0.0);

            player.visible = false;
            
            opponent.visible = false;
        
            adrenalineS.remove(players, true);
            adrenalineS.insert(adrenalineS.members.indexOf(opponents), players);

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("gotta-sweep"));
            opp.setPosition(-1500, -100);
            opponents.add(opp);
            opponent = opp;
            
            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-1200.0, 170.0);
            players.add(plr);
            player = plr;

            tween.tween(player, {x: 300}, conductor.beatLength * 1.0 * 0.001,                 
                {
                    ease: FlxEase.backOut
                }
            );

            tween.tween(opponent, {x: 100}, conductor.beatLength * 1.0 * 0.001,                 
                {
                    ease: FlxEase.backOut
                }
            );
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 560)
            tween.tween(this, {gameCameraZoom: 0.8}, conductor.beatLength * 0.5 * 0.001, {ease: FlxEase.backIn});

        if (step == 564)
        {
            gameCameraZoom = 0.65;

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            adrenalineS.hall.velocity.set(10560.0, 0.0);
            
            player.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-left"));
            plr.setPosition(300.0, 170.0);
            players.add(plr);
            player = plr;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 808)
        {
            gameCameraZoom = 0.7;
            
            tween.tween(player, {x: -1200}, conductor.beatLength * 1.0 * 0.001,
                {
                    ease: FlxEase.backIn
                }
            );

            tween.tween(opponent, {x: -1500}, conductor.beatLength * 1.0 * 0.001,
                {
                    ease: FlxEase.backIn
                }
            );
        }
    
        if (step == 816)
        {            
            plrStrumline.strums.x = plrStrumline.strums.getCenterX();
            
            oppStrumline.strums.x = oppStrumline.strums.getCenterX();
            oppStrumline.strums.alpha = 0.25;

            adrenalineS.hall.visible = false;
            
            adrenalineS.closetInside_Alt.visible = true;
            adrenalineS.closetInside_Overlay.visible = true;

            player.visible = false;

            var plr:Character = getPlayer("bf-face-right");
            plr.scale.set(3.1, 3.1);
            plr.setPosition(1100.0, 130.0);
            plr.visible = true;
            player = plr;

            opponent.visible = false;

            adrenalineS.remove(opponents, true);
            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.closetInside_Overlay), opponents);

            adrenalineS.remove(players, true);
            adrenalineS.insert(adrenalineS.members.indexOf(opponents), players);

            var opp:Character = getOpponent("gotta-sweep-face-front");
            opp.scale.set(3.25, 3.25);
            opp.setPosition(1200.0, 100.0);
            opp.visible = true;
            opponent = opp;

            tween.tween(player, {x: 200.0}, conductor.beatLength * 1.0 * 0.001);
            
            tween.tween(opponent, {x: 300.0}, conductor.beatLength * 1.0 * 0.001);
         
            adrenalineS.remove(noSquee);
            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.closetInside_Overlay), noSquee);

            noSquee.scale.set(1.55, 1.55);
            noSquee.updateHitbox();
            noSquee.setPosition(28.0, 300.0);

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 832)
        {
            adrenalineS.closetInside_Alt.visible = false;
            adrenalineS.closetInside_Overlay.visible = false;

            adrenalineS.closetInside.visible = true;
        }

        if (step == 1212)
        {
            tween.tween(player, {x: 1700.0}, conductor.beatLength * 0.75 * 0.001);
            
            tween.tween(opponent, {x: 1700.0}, conductor.beatLength * 0.75 * 0.001);
        }

        if (step == 1213)
        {
            adrenalineS.closetInside.visible = false;
            
            adrenalineS.closetInside_Alt.visible = true;
            adrenalineS.closetInside_Overlay.visible = true;
        }
        
        if (step == 1216)
        {
            gameCameraZoom = 0.4;
            adrenalineS.closetInside_Alt.visible = false;
            adrenalineS.closetInside_Overlay.visible = false;
            
            adrenalineS.hall3_Alt.visible = true;
            adrenalineS.hall3_Overlay.visible = true;
        
            player.visible = false;

            adrenalineS.remove(opponents, true);
            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.hall3_Overlay), opponents);

            adrenalineS.remove(players, true);
            adrenalineS.insert(adrenalineS.members.indexOf(opponents), players);

            opponent.scale.set(0.275, 0.275);
            opponent.setPosition(100.0, 55.0);

            tween.tween(opponent, {x: 255.0}, conductor.beatLength * 1.0 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        adrenalineS.hall3_Overlay.visible = false;

                        tween.tween(opponent.scale, {x: 2.75, y: 2.75}, conductor.beatLength * 2.25 * 0.001);

                        tween.tween(opponent, {x:-80, y: 125.0}, conductor.beatLength * 2.25 * 0.001);
                    }
                }
            );
        }
        
        if (step == 1232)
        {
            gameCameraZoom = 1.2;
            
            adrenalineS.hall3_Alt.visible = false;
            adrenalineS.hall3_Overlay.visible = false;

            adrenalineS.hall2.visible = true;

            opponent.scale.set(0.25, 0.25);
            opponent.setPosition(325.0, 50.0);
            
            //tween.tween(opponent.scale, {x: 1.0, y: 1.0}, conductor.beatLength * 2 * 0.001);

           // tween.tween(opponent, {x: 325.0, y: 50.0}, conductor.beatLength * 2 * 0.001);

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 0 && beat < 4)
            gameCameraZoom += 0.05;
    }

    public function updateLegStatus(name:String, frameNum:Int, frameIndex:Int):Void
    {
        var plr:Character = getPlayer("run-legs");
    
        var curFrame:Int = plr.animation.curAnim.curFrame;
    
        if (name.contains("MISS"))
        {
            if (!plr.animation.name.contains("miss"))
                plr.animation.play("legs miss", true, false, curFrame);
        }
        else
        {
            if (plr.animation.name.contains("miss"))
                plr.animation.play("legs", true, false, curFrame);
        }
    }
}