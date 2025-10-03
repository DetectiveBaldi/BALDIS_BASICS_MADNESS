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
using util.PlayFieldTools;

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

        playField.setVisible(false);

        playField.strumlines.visible = false;
        
        plrStrumlineX = plrStrumline.strums.x;

        oppStrumlineX = oppStrumline.strums.x;

        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.25;

        plrStrumline.botplay = true;
       
        adrenalineS.closet.visible = true;
    
        noSquee = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/no-squee"));
        noSquee.scale.set(0.75, 0.75);
        noSquee.updateHitbox();
        noSquee.setPosition(683.0, 350.0);

        tweens.tween(noSquee, {y: noSquee.y - 25}, conductor.beatLength * 2.0 * 0.001, 
            {
                ease: FlxEase.sineInOut, 
                type: PINGPONG
            }
        );

        player.scale.set(2.4, 2.4);
        player.updateHitbox();
        player.setPosition(-900.0, 145.0);

        opponent.scale.set(1.45, 1.45);
        opponent.updateHitbox();
        opponent.setPosition(390.0, 145.0);

        adrenalineS.remove(opponents, true);

        AssetCache.getGraphic("game/Character/bf-intro-adrenaline");
        AssetCache.getGraphic("game/Character/bf-face-left");
        AssetCache.getGraphic("game/Character/bf-face-right");
        AssetCache.getGraphic("game/Character/bf-face-front");

        AssetCache.getGraphic("game/Character/gotta-sweep");
        AssetCache.getGraphic("game/Character/gotta-sweep-face-front");

        AssetCache.getGraphic("game/stages/shared/scrolling-hall0");
        AssetCache.getGraphic("game/stages/shared/scrolling-hall1");
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            player.animation.play("wright");
            player.skipDance = true;
            player.skipSing = true;

            tweens.tween(player, {x: 560.0}, conductor.beatLength * 4.0 * 0.001);
        }
    
        if (step == 16)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            plrStrumline.botplay = Options.botplay;

            playField.setVisible(true);

            playField.strumlines.visible = true;

            adrenalineS.closet.visible = false;
            
            adrenalineS.closet_Alt.visible = true;
            adrenalineS.closet_Overlay.visible = true;
        
            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.closet_Overlay), noSquee);

            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.closet_Overlay), opponents);

            tweens.tween(player, {x: 590.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            player.animation.play("sleft");
            player.skipDance = false;
            player.skipSing = false;
        }

        if (step == 288)
        {
            tweens.tween(opponent.scale, {x: 2.0, y: 2.0}, conductor.beatLength * 0.35 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        adrenalineS.remove(opponents, true);
                        adrenalineS.insert(adrenalineS.members.indexOf(players), opponents);
                        
                        tweens.tween(opponent.scale, {x: 2.5, y: 2.5}, conductor.beatLength * 0.5 * 0.001);
                    }
                }
            );
            
            tweens.tween(opponent, {y: opponent.y + 30.0}, conductor.beatLength * 0.35 * 0.001,
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        tweens.tween(player, {x: 1750.0}, conductor.beatLength * 0.001);
                        
                        tweens.tween(opponent, {x: 1750.0}, conductor.beatLength * 0.001);
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
            adrenalineS.hall.animation.play("0");

            player.visible = false;
            
            opponent.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("gotta-sweep"));
            opp.setPosition(-1500.0, -25.0);
            opponents.add(opp);
            opponent = opp;
            
            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-1200.0, 170.0);
            players.add(plr);
            player = plr;

            tweens.tween(player, {x: 300.0}, conductor.beatLength * 0.001,                 
                {
                    ease: FlxEase.backOut
                }
            );

            tweens.tween(opponent, {x: 100.0}, conductor.beatLength * 0.001,                 
                {
                    ease: FlxEase.backOut
                }
            );
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 560)
            tweens.tween(this, {gameCameraZoom: 0.8}, conductor.beatLength * 0.5 * 0.001, {ease: FlxEase.backIn});

        if (step == 564)
        {
            gameCameraZoom = 0.65;

            tweens.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            adrenalineS.hall.animation.play("0", false, true);
            
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
            
            tweens.tween(player, {x: -1200.0}, conductor.beatLength * 2.0 * 0.001,
                {
                    ease: FlxEase.backIn
                }
            );

            tweens.tween(opponent, {x: -1500.0}, conductor.beatLength * 2.0 * 0.001,
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

            opponent.visible = false;

            adrenalineS.remove(players, true);
            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.closetInside_Overlay), players); 

            var plr:Character = getPlayer("bf-face-right");
            plr.scale.set(3.1, 3.1);
            plr.updateHitbox();
            plr.setPosition(1100.0, 110.0);
            plr.visible = true;
            player = plr;

            adrenalineS.remove(opponents, true);
            adrenalineS.insert(adrenalineS.members.indexOf(players), opponents);

            var opp:Character = getOpponent("gotta-sweep-face-front");
            opp.scale.set(3.1, 3.1);
            opp.updateHitbox();
            opp.setPosition(1200.0, -35.0);
            opp.visible = true;
            opponent = opp;

            tweens.tween(player, {x: 200.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            
            tweens.tween(opponent, {x: 275.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
         
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
            tweens.tween(player, {x: 1700.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartIn});
            
            tweens.tween(opponent, {x: 1700.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1213)
        {
            adrenalineS.closetInside.visible = false;
            
            adrenalineS.closetInside_Alt.visible = true;
            adrenalineS.closetInside_Overlay.visible = true;
        }
        
        if (step == 1216)
        {
            gameCameraZoom = 0.8;
            adrenalineS.closetInside_Alt.visible = false;
            adrenalineS.closetInside_Overlay.visible = false;
            
            adrenalineS.hall3_Alt.visible = true;
            adrenalineS.hall3_Overlay.visible = true;

            adrenalineS.remove(players, true);
            adrenalineS.insert(adrenalineS.members.indexOf(adrenalineS.hall3_Overlay), players);
            
            adrenalineS.remove(opponents, true);
            adrenalineS.insert(adrenalineS.members.indexOf(players), opponents);

            player.scale.set(0.35, 0.35);
            player.updateHitbox();
            player.setPosition(302.0, 330.0);
            
            opponent.scale.set(0.35, 0.35);
            opponent.updateHitbox();
            opponent.setPosition(300.0, 315.0);

            tweens.tween(opponent, {x: 545.0}, conductor.beatLength * 1.0 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        adrenalineS.hall3_Overlay.visible = false;

                        tweens.tween(opponent.scale, {x: 2.75, y: 2.75}, conductor.beatLength * 1.5 * 0.001, {ease: FlxEase.quadIn});

                        tweens.tween(opponent, {x: 275.0, y: 365.0}, conductor.beatLength * 1.5 * 0.001,
                            {
                                onComplete: (_tween:FlxTween) ->
                                {
                                    tweens.tween(opponent, {x: 2000.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quadIn});
                                } 
                            }
                        );
                    }
                }
            );

            tweens.tween(player, {x: 547.0}, conductor.beatLength * 1.0 * 0.001, 
                {
                    onComplete: (_tween:FlxTween) ->
                    {
                        tweens.tween(player.scale, {x: 2.75, y: 2.75}, conductor.beatLength * 1.5 * 0.001, {ease: FlxEase.quadIn});

                        tweens.tween(player, {x: 278.0, y: 430.0}, conductor.beatLength * 1.5 * 0.001,
                            {
                                onComplete: (_tween:FlxTween) ->
                                {
                                    tweens.tween(player, {x: 2050.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quadIn});
                                } 
                            }
                        );
                    }
                }
            );
        }
        
        if (step == 1232)
        {
            gameCameraZoom = 1.45;
            
            adrenalineS.hall3_Alt.visible = false;
            adrenalineS.hall3_Overlay.visible = false;

            adrenalineS.hall2.visible = true;

            opponent.scale.set(0.25, 0.25);
            opponent.updateHitbox();
            opponent.setPosition(600.0, 335.0);

            var plr2:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-front"));
            plr2.scale.set(0.8, 0.8);
            plr2.updateHitbox();
            plr2.setPosition(550.0, 280.0);
            players.add(plr2);
            player = plr2;
            
            tweens.tween(opponent.scale, {x: 1, y: 1}, conductor.beatLength * 2.0 * 0.001,
                {
                    ease: FlxEase.backOut
                }
            );

            tweens.tween(opponent, {x: 610.0, y: 335.0}, conductor.beatLength * 2.0 * 0.001,
                {
                    ease: FlxEase.backOut
                }
            );

            tweens.tween(player.scale, {x: 0.95, y: 0.95}, conductor.beatLength * 2.0 * 0.001,
                {
                    ease: FlxEase.backOut
                }
            );

            tweens.tween(player, {x: 550.0, y: 310.0}, conductor.beatLength * 2.0 * 0.001,
                {
                    ease: FlxEase.backOut
                }
            );

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 1488)
            tweens.tween(this, {gameCameraZoom: 1.5}, conductor.beatLength * 0.5 * 0.001, {ease: FlxEase.backOut});

        if (step == 1492)
        {
            gameCameraZoom = 1.2;
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 1744)
        {
            playField.setVisible(false);
            
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 1768)
        {
            tweens.tween(opponent.scale, {x: 3.0, y: 3.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.expoIn});

            tweens.tween(opponent, {x: 600.0, y: 335.0}, conductor.beatLength * 2.0 * 0.001,
                {
                    ease: FlxEase.expoIn
                }
            );

            tweens.tween(player.scale, {x: 2.9, y: 2.9}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.expoIn});

            tweens.tween(player, {x: 550.0, y: 400.0}, conductor.beatLength * 2.0 * 0.001,
                {
                    ease: FlxEase.expoIn
                }
            );
        }
        
        if (step == 1776)
        {
            gameCameraZoom = 0.65;

            plrStrumline.strums.x = plrStrumlineX;

            oppStrumline.strums.x = oppStrumlineX;
            oppStrumline.strums.alpha = 1.0;

            playField.setVisible(true);
            
            adrenalineS.hall2.visible = false;

            adrenalineS.hall.visible = true;
            adrenalineS.hall.animation.play("0", false, false);
            
            opponent.visible = false;

            player.visible = false;

            var plr:Character = getPlayer("bf-face-right");
            plr.scale.set(2.7, 2.7);
            plr.updateHitbox();
            plr.setPosition(-1200.0, 170.0);
            plr.visible = true;
            player = plr;

            var opp:Character = getOpponent("gotta-sweep");
            opp.setPosition(-1500.0, -25.0);
            opp.visible = true;
            opponent = opp;

            tweens.tween(player, {x: 300.0}, conductor.beatLength * 0.001,                 
                {
                    ease: FlxEase.backOut
                }
            );

            tweens.tween(opponent, {x: 100.0}, conductor.beatLength * 0.001,                 
                {
                    ease: FlxEase.backOut
                }
            );
            
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 2064)
        {
            gameCameraZoom = 0.6;

            playField.setVisible(false);
            
            adrenalineS.hall.animation.pause();

            tweens.tween(opponent, {x: -1500}, 0.75,                 
                {
                    ease: FlxEase.backIn,
                    onComplete: (_tween:FlxTween) -> 
                    {
                        opponent.visible = false;
                    }
                }
            );
        
            tweens.tween(player, {x: player.x + 100}, 0.5);
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 0 && beat < 4)
            gameCameraZoom += 0.05;
    
        if (beat >= 508 && beat < 516)
        {
            gameCameraZoom += 0.05;
        }
    }
}