package game.levels.classicw;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.PlaymateS;

using util.MathUtil;

using StringTools;

class PlaymateL extends PlayState
{
    public var playmateS:PlaymateS;

    public var black:FlxSprite;

    override function create():Void
    {
        stage = new PlaymateS();

        playmateS = cast (stage, PlaymateS);

        super.create();

        playmateS.cafe.visible = true;

        playmateS.hall.visible = true;

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        gameCamera.snapToTarget();

        gameCameraZoom = 0.75;

        player.setPosition(700.0, 150.0);

        opponent.setPosition(-1500.0, 190.0);

        black = new FlxSprite();

        black.color = 0x000000;
        gameCamera.color = 0x000000;

        add(black);

        playField.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            tween.color(black, conductor.beatLength * 32.0 * 0.001, black.color, 0xFFFFFFFF,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = black.color;}});
        }

        if (step == 128)
        {
            opponent.skipDance = true;
            
            opponent.animation.play("play");

            tween.tween(opponent, {x: -80.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 142)
            cameraLock = FOCUS_CAM_CHAR;

        if (step == 144 || step == 656)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            opponent.skipDance = false;

            playField.visible = true;

            gameCameraZoom = 0.6;
        }

        if (step == 392 || step == 520 || step == 648 || step == 1304)
            gameCameraZoom = 0.8;

        if (step == 400 || step == 528 || step == 1312)
        {
            gameCameraZoom -= 0.05;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 912)
        {
            gameCameraZoom = 0.8;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;
        }

        if (step == 928)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.7;

            oppStrumline.strums.alpha = 0.0;

            plrStrumline.strums.alpha = 0.0;

            playmateS.hall.color = playmateS.cafe.color = 0xADADAD;
        }
        
        if (step == 1040)
        {
            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});

            tween.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 1168)
        {
            tween.tween(this, {gameCameraZoom: 0.55}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1184)
        {
            playmateS.hall.color = playmateS.cafe.color = 0x777777;

            gameCameraZoom = 0.8;
        }

        if (step == 1188)
        {
            playmateS.hall.color = playmateS.cafe.color = 0xFFFFFF;

            gameCameraZoom = 0.7;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 1456)
        {
            
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 360 && beat < 368)
        {
            if (beat % 2 == 0)
                gameCameraZoom += 0.025;
        }
    }
}