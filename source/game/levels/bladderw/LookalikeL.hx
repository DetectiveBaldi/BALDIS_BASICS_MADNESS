package game.levels.bladderw;

import flixel.animation.FlxAnimation;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import core.AssetCache;

import core.Paths;

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

    public var smoke:FlxSprite;

    override function create():Void
    {
        stage = new LookalikeS();

        lookalikeS = cast (stage, LookalikeS);

        super.create();

        smoke = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/smoke"));
        smoke.scale.set(4, 4);
        smoke.camera = hudCamera;
        smoke.screenCenter();
        insert(0, smoke);

        gameCameraZoom = 0.8;

        lookalikeS.room3.visible = true;
        
        var anim:FlxAnimation = lookalikeS.bladderSchool1.animation.getByName("0");
        anim.frameRate = anim.numFrames / (conductor.beatLength * 0.002);
        
        player.setPosition(700, 125);
        player.color = 0xFF7F7F7F;

        opponent.setPosition(-200, -150);
        opponent.color = 0xFFAFAFAF;

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
        if (step == 246)
        {
            gameCameraZoom = 1;
            
            opponent.skipDance = true;

            opponent.animation.play("scary");

            opponent.animation.onFinish.addOnce((name:String) -> { opponent.skipDance = false; });
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
        }
    
        if (step == 512)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            lookalikeS.room3.visible = false;
           
            lookalikeS.bladderSchool0.visible = true;

            opponent.color = 0xFFFFFFFF;

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

            opponent.color = 0xB7B7A6;

            player.color = 0xFF7F7F7F;

            tween.tween(smoke.scale, {x: 4, y: 4}, 
                conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartOut});
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

            opponent.color = 0xFFFFFFFF;
        }

        if (step == 512 || step == 1024)
            tween.tween(smoke.scale, {x: 2.7, y: 2.7}, 
                conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartOut});
    }
}