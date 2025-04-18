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

class Level2 extends PlayState
{
    public var castedStage(get, never):School;

    @:noCompletion
    function get_castedStage():School
    {
        return cast (stage, School);
    }

    public var principal:FlxSprite;

    override function create():Void
    {
        stage = new School();

        super.create();

        gameCameraTarget.centerTo();

        gameCameraZoom = 0.8;

        castedStage.ggentranceBgAlt2.visible = true;

        players.setPosition(400, 35);
        
        castedStage.remove(opponents, true);
        castedStage.insert(castedStage.members.indexOf(castedStage.ggentranceBgOverlay), opponents);
        castedStage.ggentranceBgOverlay.visible = true;

        var opp:Character = getOpponent("baldi-angry1");
        opp.scale.set(0.35, 0.35);
        opp.setPosition(375.0, 100.0);
        opp.skipDance = true;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 128)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            castedStage.ggentranceBgAlt2.visible = false;
            castedStage.ggentranceBgOverlay.visible = false;

            castedStage.ggentranceBgAlt.visible = true;
        }

        if (step == 144)
        {
            castedStage.ggentranceBgAlt.visible = false;
            castedStage.ggentranceBg.visible = true;
        }
   
        if (step == 312)
        {
            gameCameraZoom = 1;
        }
        
        if (step == 320)
        {
            if (!Options.middlescroll)
                {
                    var oppStrumlineX:Float = oppStrumline.strums.x;
    
                    var plrStrumlineX:Float = plrStrumline.strums.x;
    
                    tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
    
                    tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
                }
            
            castedStage.ggentranceBg.visible = false;
            castedStage.ggcornerBg.visible = true;
        
            var plr:Character = getPlayer("bf2");
            plr.visible = false;
        
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf3"));
            plr.setPosition(-500.0, 0.0);
            players.add(plr);
            plr.visible = true;

            var opp:Character = getOpponent("baldi-angry1");
            opp.setPosition(385.0, 115.0);
            opp.scale.set(1.0, 1.0);
        }
    
        if (step == 416)
        {        
            if (!Options.middlescroll)
                {
                    var oppStrumlineX:Float = oppStrumline.strums.x;
    
                    var plrStrumlineX:Float = plrStrumline.strums.x;
    
                    tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
    
                    tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
                }
        
            gameCameraZoom = 0.6;
            
            castedStage.remove(players, true);

            castedStage.ggcornerBg.visible = false;
            castedStage.ggfacultyBg.visible = true;
            castedStage.insert(castedStage.members.indexOf(castedStage.ggfacultyBgOverlay), players);
            castedStage.ggfacultyBgOverlay.visible = true;

            var plr:Character = getPlayer("bf3");
            plr.visible = false;
           
            var opp:Character = getOpponent("baldi-angry1");
            opp.visible = false;
        
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf0"));
            plr.scale.set(1.75, 1.75);
            plr.setPosition(-100.0, 75.0);
            plr.visible = true;
            players.add(plr);
        }

        if (step == 438)
        {
            gameCameraZoom = 1.5;
        }
        
        if (step == 443)
        {
            CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5 - 500.0,
                (FlxG.height - gameCameraTarget.height) * 0.5, "", -1.0);
            
            gameCamera.snapToTarget();
        }
       
        if (step == 446)
        {
            castedStage.ggfacultyBg.visible = false;
            castedStage.ggfacultyBgAlt.visible = true;
            
            castedStage.remove(opponents, true);
            castedStage.add(opponents);

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("classic-remastered/baldi-angry0"));
            opp.scale.set(2.0, 2.0);
            opp.setPosition(-600.0, 0.0);
            opp.skipDance = true;
            opponents.add(opp);
        
            tween.tween(opp, {x: opp.x + 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});
            opp.animation.play("slap", true);
        }
    
        if (step == 456)
        {
            gameCameraZoom = 0.8;
            
            gameCameraTarget.centerTo();
        }
        
        if (step == 464)
        {                        
            castedStage.ggfacultyBgAlt.visible = false;
            castedStage.ggfacultyBg.visible = true;
        }
    
        if (step == 504 || step == 507 || step == 510)
        {                        
            gameCameraZoom += 0.25;
        }
    
        if (step == 512)
        {                        
            gameCameraZoom = 0.8;
        }
    
        if (step == 600)
        {                        
            var plr:Character = getPlayer("bf0");
            
            principal = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("globals/principal"))));
            principal.scale.set(1.15, 1.15);
            principal.updateHitbox();
            principal.setPosition(1500, 150.0);
            castedStage.insert(castedStage.members.indexOf(castedStage.ggfacultyBgOverlay), principal);
        
            tween.tween(principal, {x: plr.x + 200}, 1,                
                {
                    onComplete: (_tween:FlxTween) ->  
                    {
                        principal.visible = false;
                        plr.visible = false;
                    }
                });
        }
    }
    
    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 0.0 && beat < 34.0)
            {
                if (beat % 4.0 == 0.0)
                {
                    var opp:Character = getOpponent("baldi-angry1");
    
                    tween.tween(opp.scale, {x: opp.scale.x + 0.125, y: opp.scale.y + 0.125}, 
                        conductor.beatLength * 0.275 * 0.001);
    
                    tween.tween(opp, {y: opp.y + 2.5}, conductor.beatLength * 0.275 * 0.001);
    
                    opp.animation.play("slap", true);
                }
            }
    
        if (beat >= 80.0 && beat < 104.0)
            {
                if (beat % 4 == 0.0)
                {
                    var opp:Character = getOpponent("baldi-angry1");
        
                    tween.tween(opp.scale, {x: opp.scale.x + 0.2, y: opp.scale.y + 0.2}, 
                        conductor.beatLength * 0.275 * 0.001);
        
                    tween.tween(opp, {x: opp.x + 30, y: opp.y + 5}, conductor.beatLength * 0.275 * 0.001);
        
                    opp.animation.play("slap", true);
                }
            }
    }
}