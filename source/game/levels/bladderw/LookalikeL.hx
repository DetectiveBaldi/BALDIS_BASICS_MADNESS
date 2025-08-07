package game.levels.bladderw;

import flixel.animation.FlxAnimation;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.bladderw.LookalikeS;

using util.MathUtil;

using StringTools;

class LookalikeL extends PlayState
{
    public var lookalikeS:LookalikeS;

    override function create():Void
    {
        stage = new LookalikeS();

        lookalikeS = cast (stage, LookalikeS);

        super.create();

        gameCameraZoom = 0.8;

        lookalikeS.room3.visible = true;
        
        var anim:FlxAnimation = lookalikeS.bladderSchool1.animation.getByName("0");
        anim.frameRate = anim.numFrames / (conductor.beatLength * 0.002);
        
        player.setPosition(700, 125);
        player.color = 0xFF7F7F7F;

        opponent.setPosition(-200, -150);

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 246)
        {
            gameCameraZoom = 1;
            
            opponent.skipDance == true;
            opponent.animation.play("scary");
        }
        
        if (step == 250 || step == 253 || step == 255)
        {
            lookalikeS.room3.visible = false;
            
            lookalikeS.room3_Alt0.visible = true;
        }
    
        if (step == 252 || step == 254)
        {
            lookalikeS.room3.visible = true;
            
            lookalikeS.room3_Alt0.visible = false;
        }

        if (step == 256)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 0.8;
            
            lookalikeS.room3.visible = false;
            
            lookalikeS.room3_Alt0.visible = true;
        
            opponent.skipDance == false;
        }
    
        if (step == 512)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            lookalikeS.room3.visible = false;
           
            lookalikeS.bladderSchool0.visible = true;
        
            player.color = 0xFFFFFFFF;
        }

        if (step == 768)
        {
            gameCameraZoom = 1;
        }
        
        if (step == 784 || step == 1280)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 0.8;

            lookalikeS.room3.visible = true;
           
            lookalikeS.bladderSchool0.visible = false;
            lookalikeS.bladderSchool1.visible = false;

            player.color = 0xFF7F7F7F;
        }
    
        if (step == 1024)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 0.6;

            tween.tween(this, {gameCameraZoom: 1.1}, 18);

            lookalikeS.room3.visible = false;
           
            lookalikeS.bladderSchool1.visible = true;
            lookalikeS.bladderSchool1.animation.play("0");

            player.color = 0xFFFFFFFF;
        }
    }
}