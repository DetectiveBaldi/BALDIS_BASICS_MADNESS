package game.levels.baldiw;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;
import game.stages.baldiw.WarmWS;

using util.MathUtil;

using StringTools;

class WarmWL extends PlayState
{
    public var warmWS:WarmWS;

    override function create():Void
    {
        stage = new WarmWS();

        warmWS = cast (stage, WarmWS);

        super.create();

        gameCameraZoom = 0.6;

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
    
        warmWS.entranceA0.visible = true;

        var plr:Character = getPlayer("bf-face-back");
        plr.scale.set(5.0, 5.0);
        plr.updateHitbox();
        plr.setPosition(-350.0, -300.0);
        
        players.setPosition(215, 165);
        opponents.setPosition(345, 180);

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 128)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 5.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 384)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            warmWS.entranceA0.color = 0xFF999999;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
        }

        if (step == 640)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            warmWS.entranceA0.color = 0xFFFFFFFF;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;
        }
    
        if (step == 1148)
        {
            if (Options.flashingLights)
                gameCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 1152)
        {

            if (Options.flashingLights)
                gameCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.001, true, null, true);

            gameCameraZoom = 0.7;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            player.visible = false;
            
            var opp:Character = getOpponent("baldi-face-front");
            opp.visible = false;
        
            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-left"));
            plr.setPosition(400.0, 0.0);
            players.add(plr);

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-face-right"));
            opp.setPosition(-550.0, -150.0);
            opponents.add(opp);
        
            warmWS.entranceA0.visible = false;
            warmWS.entranceA1.visible = true;
            warmWS.entranceA1.color = 0xFF999999;
        }

        if (step == 1152)
        {
            SetCamFocusEvent.dispatch(this, cameraPoint.getCenterX() + 100.0, cameraPoint.getCenterY(), null, 0.0,
                "linear");
        }
    
        if (step == 1280)
        {
            SetCamFocusEvent.dispatch(this, cameraPoint.getCenterX() - 100.0, cameraPoint.getCenterY(), null, 0.0,
                "linear");
        }

        if (step == 1408)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            warmWS.entranceA1.color = 0xFFFFFFFF;

            SetCamFocusEvent.dispatch(this, cameraPoint.getCenterX(), cameraPoint.getCenterY(), null, 0.0,
                "linear");

            gameCamera.snapToTarget();

            var plr:Character = getPlayer("bf-face-left");
            plr.visible = false;

            var opp:Character = getOpponent("baldi-face-right");
            opp.skipDance = true;

            var plrAnim:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-anim-door"));
            plrAnim.setPosition(400.0, 0.0);
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
            
            warmWS.entranceA1.visible = false;
            warmWS.entranceA1_Alt0.visible = true;

            tween.tween(plrAnim, {x: plrAnim.x - 40.0}, 1.3,
                {
                    startDelay: 1,
                    ease: FlxEase.sineOut
                }
            );
            
            tween.tween(plrAnim, {y: plrAnim.y - 120.0}, 5, {ease: FlxEase.sineOut});
            tween.tween(plrAnim.scale, {x: 0.7, y: 0.7}, 5, {ease: FlxEase.sineOut});
        }
    
        if (step == 1434)
        {            
            var plrAnim:Character = getPlayer("bf-anim-door");
            
            warmWS.remove(players, true);
            warmWS.insert(warmWS.members.indexOf(warmWS.entranceA1_Overlay0), players);
            warmWS.entranceA1_Overlay0.visible = true;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
        
        if (beat >= 0.0 && beat < 288.0)
        {
            if (cameraCharTarget == "OPPONENT")
            {
                gameCameraZoom = 1.0;
            
                tween.tween(player, {alpha: 0.0}, conductor.beatLength * 0.001);
            }
            else
            {
                gameCameraZoom = 0.6;
                    
                tween.tween(player, {alpha: 1.0}, conductor.beatLength * 0.001);
            }
        }
    }
}