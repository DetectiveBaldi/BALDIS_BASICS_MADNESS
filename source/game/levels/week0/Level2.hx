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

        var plr:Character = getPlayer("bf5");
        plr.setPosition(700, 125);
        plr.visible = false;

        var opp:Character = getOpponent("baldi-angry1");
        opp.scale.set(0.35, 0.35);
        opp.setPosition(390.0, 100.0);
        opp.skipDance = true;
    
        castedStage.remove(opponents, true);
        castedStage.insert(castedStage.members.indexOf(castedStage.entranceA4_Overlay0), opponents);
        
        castedStage.entranceA4.visible = true;
        castedStage.entranceA4_Overlay0.visible = true;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
        trace(step);
        
        if (step == 56)
        {
            var plr:Character = getPlayer("bf5");
            plr.visible = true;
        
            castedStage.remove(players, true);
            castedStage.insert(castedStage.members.indexOf(castedStage.entranceA4_Overlay2), players);

            castedStage.entranceA4.visible = false;
            castedStage.entranceA4_Alt0.visible = true;
            castedStage.entranceA4_Overlay2.visible = true;
        }

        if (step == 124)
        {      
            castedStage.entranceA4_Overlay0.visible = false;
            castedStage.entranceA4_Overlay1.visible = true;
        }

        if (step == 144)
        {
            castedStage.remove(opponents, true);
            castedStage.insert(castedStage.members.indexOf(players), opponents);
            
            castedStage.entranceA4_Overlay1.visible = false;
            castedStage.entranceA4_Overlay0.visible = true;
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
        
            var plr:Character = getPlayer("bf5");
            plr.visible = false;
        
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf6"));
            plr.setPosition(-100.0, 125.0);
            players.add(plr);
            plr.visible = true;

            castedStage.remove(players, true);
            castedStage.add(players);

            var opp:Character = getOpponent("baldi-angry1");
            opp.setPosition(385.0, 115.0);
            opp.scale.set(1.0, 1.0);
        
            castedStage.remove(opponents, true);
            castedStage.add(opponents);

            castedStage.entranceA4.visible = false;
            castedStage.entranceA4_Overlay0.visible = false;
            castedStage.entranceA4_Overlay2.visible = false;
            castedStage.entranceA5.visible = true;
        }
        
        if (step == 440)
        {
            gameCameraZoom = 0.6;

            var plr:Character = getPlayer("bf6");
            tween.tween(plr, {x: -1500.0}, 0.75, {ease: FlxEase.quartIn});
        
            var opp:Character = getOpponent("baldi-angry1");
            opp.animation.play("slap");
            tween.tween(opp, {x: opp.x - 300.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});
        }
        
        if (step == 448)
        {
            if (!Options.middlescroll)
                {
                    var oppStrumlineX:Float = oppStrumline.strums.x;
    
                    var plrStrumlineX:Float = plrStrumline.strums.x;
    
                    tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
    
                    tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
                }          

            var plr:Character = getPlayer("bf6");
            plr.visible = false;
            
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf0"));
            plr.scale.set(1.75, 1.75);
            plr.setPosition(450.0, 100.0);
            plr.visible = true;
            players.add(plr);

            var opp:Character = getOpponent("baldi-angry1");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("classic-remastered/baldi-angry0"));
            opp.scale.set(2.0, 2.0);
            opp.setPosition(-600.0, 0.0);
            opp.skipDance = true;
            opponents.add(opp);
            
            castedStage.remove(players, true);
            castedStage.insert(castedStage.members.indexOf(castedStage.ggfaculty0_Overlay0), players);

            castedStage.entranceA5.visible = false;
            castedStage.ggfaculty0_Alt0.visible = true;
            castedStage.ggfaculty0_Overlay0.visible = true;

            tween.tween(opp, {x: opp.x + 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});
            opp.animation.play("slap", true);
        }
        
        if (step == 464)
        {                        
            castedStage.ggfaculty0_Alt0.visible = false;
            castedStage.ggfaculty0.visible = true;
        }
    
        if (step == 504 || step == 507 || step == 510)
        {                        
            gameCameraZoom += 0.25;
        }
    
        if (step == 512)
        {                        
            gameCameraZoom = 0.8;
           
            CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5 - 200.0,
                (FlxG.height - gameCameraTarget.height) * 0.5, "", -1.0);
        }
    
        if (step == 632)
        {                        
            gameCameraTarget.centerTo();

            var plr:Character = getPlayer("bf0");
            
            principal = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("globals/principal"))));
            principal.scale.set(1.15, 1.15);
            principal.updateHitbox();
            principal.setPosition(1500, 150.0);
            castedStage.insert(castedStage.members.indexOf(castedStage.ggfaculty0_Overlay0), principal);
        
            tween.tween(principal, {x: plr.x + 200}, 1,                
                {
                    onComplete: (_tween:FlxTween) ->  
                    {
                        principal.visible = false;
                        plr.visible = false;
                    }
                });
        }
    
        if (step == 648)
        {
            var opp:Character = getOpponent("baldi-angry0");
            
            tween.tween(opp, {x: opp.x + 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});
            opp.animation.play("slap", true);
        }
    
        if (step == 656)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 1;
            
            var opp:Character = getOpponent("baldi-angry0");
            opp.visible = false;

            var plr:Character = getPlayer("bf0");
            plr.visible = false;
        
            var opp:Character = getOpponent("baldi-angry1");
            //opp.visible = true;
            
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf3"));        
            plr.setPosition(600.0, 250.0);
            players.add(plr);
           
            castedStage.remove(opponents, true);
            castedStage.insert(castedStage.members.indexOf(castedStage.principalOffice0_Overlay0), opponents);

            castedStage.remove(players, true);
            castedStage.add(players);

            castedStage.ggfaculty0.visible = false;
            castedStage.ggfaculty0_Overlay0.visible = false;
            castedStage.principalOffice0.visible = true;
            castedStage.principalOffice0_Overlay0.visible = true;
        }
    
        if (step == 912)
        {
            gameCameraZoom = 0.2;

            var plr:Character = getPlayer("bf3");
            plr.visible = false;

            var opp:Character = getOpponent("baldi-angry1");
            opp.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf7"));
            plr.setPosition(798.5, 205.5);
            players.add(plr);

            var opp:Character = getOpponent("baldi-angry0");
            opp.setPosition(-845.0, 18.5);
            opp.visible = true;
            
            castedStage.remove(opponents, true);
            castedStage.add(opponents);

            castedStage.principalOffice0.visible = false;
            castedStage.principalOffice0_Overlay0.visible = false;
        
            castedStage.hall2.visible = true;
            castedStage.hall2.velocity.set(-1560.0, 0.0);
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
    
        if (beat >= 80.0 && beat < 112.0)
            {
                if (beat % 4 == 0.0)
                {
                    var opp:Character = getOpponent("baldi-angry1");
        
                    tween.tween(opp.scale, {x: opp.scale.x + 0.225, y: opp.scale.y + 0.225}, 
                        conductor.beatLength * 0.275 * 0.001);
        
                    tween.tween(opp, {x: opp.x + 40, y: opp.y + 5}, conductor.beatLength * 0.275 * 0.001);
        
                    opp.animation.play("slap", true);
                }
            }
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