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

class Level0 extends PlayState
{
    public var castedStage(get, never):School;

    @:noCompletion
    function get_castedStage():School
    {
        return cast (stage, School);
    }

    override function create():Void
    {
        stage = new School();

        super.create();

        gameCameraTarget.centerTo();
    
        castedStage.entranceA0.visible = true;
        
        players.setPosition(215, 135);
        opponents.setPosition(345, 180);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 128)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCameraZoom = 0.8;
        }
    
        if (step == 1148)
        {
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 1152)
        {
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.001, true, null, true);
           
            gameCameraZoom = 1;
        
            var plr:Character = getPlayer("bf2");
            plr.visible = false;

            var opp:Character = getOpponent("baldi0");
            opp.visible = false;
        
            var plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf0"));
            plr.setPosition(400.0, 50.0);
            players.add(plr);

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("classic-remastered/baldi2"));
            opp.setPosition(-500.0, -150.0);
            opponents.add(opp);
        
            castedStage.entranceA0.visible = false;
            castedStage.entranceA1.visible = true;
        }

        if (step == 1408)
        {
            var plr:Character = getPlayer("bf0");
            plr.visible = false;

            var plrAnim:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("funkin/bf-anim-door"));
            plrAnim.setPosition(400.0, 50.0);
            plrAnim.skipDance = true;
            plrAnim.skipSing = true;
            plrAnim.animation.play("outro1");
            players.add(plrAnim);
        }
        
        if (step == 1416)
        {
            var plrAnim:Character = getPlayer("bf-anim-door");
            plrAnim.animation.play("outro2");
        }
    
        if (step == 1424)
        {            
            var plrAnim:Character = getPlayer("bf-anim-door");
            plrAnim.animation.play("outro3");
            
            castedStage.entranceA1.visible = false;
            castedStage.entranceA1_Alt0.visible = true;
        
            tween.tween(plrAnim, {x: plrAnim.x - 25.0}, 0.5,
                {
                    startDelay: 1,
                }
            );
            
            tween.tween(plrAnim, {y: plrAnim.y - 100.0}, 0.5);
            tween.tween(plrAnim.scale, {x: 0.5, y: 0.5}, 5);
        }
    
        if (step == 1434)
        {            
            var plrAnim:Character = getPlayer("bf-anim-door");
            
            castedStage.remove(players, true);
            castedStage.insert(castedStage.members.indexOf(castedStage.entranceA1_Overlay0), players);
            castedStage.entranceA1_Overlay0.visible = true;
        }
    }
}