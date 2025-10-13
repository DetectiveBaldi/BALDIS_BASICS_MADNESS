package game.levels.classicw;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.WeekData;

import game.stages.classicw.DetentionS;

import util.MouseBitmaps;

using util.MathUtil;
using util.PlayFieldTools;

using StringTools;

using util.ArrayUtil;

class DetentionL extends PlayState
{
    public var detentionS:DetentionS;

    public var portalRect:FlxRect;
    
    public var principal:FlxSprite;

    override function create():Void
    {
        stage = new DetentionS();

        detentionS = cast (stage, DetentionS);

        super.create();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        detentionS.hall.visible = true;

        gameCamera.snapToTarget();

        gameCameraZoom = 0.65;

        gameCamera.color = FlxColor.BLACK;

        playField.setVisible(false);

        playField.strumlines.visible = false;

        plrStrumline.botplay = true;

        var __plr:Character = new Character(this, 0.0, 0.0, Character.getConfig("walk-legs"));

        var anim:FlxAnimation = __plr.animation.getByName("legs");

        anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);

        anim = __plr.animation.getByName("legs miss");

        anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);

        __plr.animation.play("legs", true);

        __plr.skipDance = true;

        __plr.skipSing = true;

        players.insert(players.members.indexOf(player), __plr);

        anim = player.animation.getByName("walk");

        anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);

        player.animation.play("walk");

        player.skipDance = true;

        player.skipSing = true;

        player.setPosition(340.0, 180.0);

        __plr.setPosition(player.x, player.y);

        player.animation.onFrameChange.add(updateLegStatus);

        opponent.setPosition(-1000.0, 35.0);

        detentionS.hall.animation.play("0");

        AssetCache.getGraphic("game/Character/bf-walk-detention");
        AssetCache.getGraphic("game/Character/walk-legs");
        AssetCache.getGraphic("game/Character/bf-face-left");
        AssetCache.getGraphic("game/Character/bf-face-back-left");
        AssetCache.getGraphic("game/Character/bf-detention-caught");

        AssetCache.getGraphic("game/Character/principal");
    
        AssetCache.getGraphic("game/stages/shared/scrolling-hall0");

        portalRect = FlxRect.get();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (detentionS.faculty0.visible || detentionS.faculty0portal.visible)
        {
            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight) &&
                FlxMath.pointInFlxRect(FlxG.mouse.x, FlxG.mouse.y, portalRect))
            {
                if ( #if debug false #else Options.botplay || PlayState.isWeek #end )
                    FlxG.sound.play(AssetCache.getSound("shared/portal-poster-error"));
                else
                {
                    if (detentionS.faculty0.visible)
                    {
                        detentionS.faculty0.visible = false;

                        detentionS.faculty0portal.visible = true;

                        FlxG.sound.play(AssetCache.getSound("shared/portal-poster-hit"));
                    }
                    else
                        PlayState.loadWeek(WeekData.list.first((week:WeekData) -> week.name == "Bladder"));
                }
            }
        }
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 16)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 4.0 * 0.001, true);
        }

        if (step == 128)
            player.animation.play("prise");
        
        if (step == 136)
            player.animation.play("t1");

        if (step == 140)
        {
            tweens.tween(opponent, {x: 385.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});

            tweens.tween(player, {x: 250.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});

            var __plr:Character = getPlayer("walk-legs");

            tweens.tween(__plr, {x: 250.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});
        }
        
        if (step == 144)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            gameCameraZoom = 0.65;

            playField.setVisible(true);

            playField.strumlines.visible = true;
        }

        if (step == 147)
        {
            player.animation.play("t2");

            player.animation.onFinish.addOnce((name:String) ->
            {
                plrStrumline.botplay = Options.botplay;

                player.skipDance = false;

                player.skipSing = false;
            });
        }

        if (step == 400)
        {
            gameCameraZoom = 0.75;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 528)
        {
            gameCameraZoom = 0.7;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 656)
        {
            gameCameraZoom = 0.6;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.setVisible(false);

            tweens.tween(opponent, {x: 2000.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 684)
        {
            tweens.tween(player, {x: player.getCenterX()}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});

            var __plr:Character = getPlayer("walk-legs");

            tweens.tween(__plr, {x: __plr.getCenterX()}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});
        }

        if (step == 688)
        {
            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 2.0 * 0.001);

            tweens.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 696)
        {
            plrStrumline.botplay = true;

            plrStrumline.resetStrums();
        }

        if (step == 736)
        {
            detentionS.hall.animation.pause();

            var _plr:Character = getPlayer("walk-legs");

            tweens.tween(player, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001, 
                {
                    ease: FlxEase.sineIn, 
                }
            );
        
            tweens.tween(_plr, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001, 
                {
                    ease: FlxEase.sineIn, 
                }
            );
        }
        
        if (step == 752)
        {
            tweens.tween(this, {gameCameraZoom: 0.8}, conductor.beatLength * 0.5 * 0.001);

            player.x = -300.0;

            tweens.cancelTweensOf(player);

            tweens.tween(player, {x: 680.0}, conductor.beatLength * 8.0 * 0.001);

            var __plr:Character = getPlayer("walk-legs");

            __plr.x = player.x;

            tweens.cancelTweensOf(__plr);
            
            tweens.tween(__plr, {x: 680.0}, conductor.beatLength * 8.0 * 0.001);

            detentionS.hall.visible = false;

            detentionS.hallstill.visible = true;

            detentionS.facultyStandard.visible = true;

            detentionS.facultyStandard.x = 600.0;
        }

        if (step == 768)
        {
            detentionS.facultyStandardOpen.visible = true;

            detentionS.facultyStandard.visible = false;

            detentionS.facultyStandardOpen.setPosition(detentionS.facultyStandard.x, detentionS.facultyStandard.y);

            plrStrumline.botplay = Options.botplay;

            plrStrumline.strums.x = plrStrumline.strums.getCenterX();

            tweens.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 776)
        {
            getTransitionSprite(conductor.beatLength * 1.0 * 0.001, OUT, null);
        }

        if (step == 780)
        {
            FlxG.mouse.visible = true;

            MouseBitmaps.setMouseBitmap(HAND);

            getTransitionSprite(conductor.beatLength * 1.0 * 0.001, IN, null);

            gameCameraZoom = 0.6;

            var plr:Character = getPlayer("bf-walk-detention");
            plr.visible = false;

            var _plr:Character = getPlayer("walk-legs");
            _plr.visible = false;

            var plr2:Character = new Character(this, 0.0, 0.0, Character.getConfig("bf-face-back-left"));
            plr2.scale.set(4.5, 4.5);
            plr2.setPosition(1000.0, 120.0);
            players.add(plr2);

            tweens.tween(plr2, {x: 650.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            detentionS.hall.visible = false;
            detentionS.facultyStandardOpen.visible = false;
            
            detentionS.faculty0.visible = true;

            portalRect.set(detentionS.faculty0portal.x + 671.0 * 2.0, detentionS.faculty0portal.y + 298.0 * 2.0,
                96 * 2.0, 172.0 * 2.0);
        }

        if (step == 896)
            gameCameraZoom += 0.1;

        if (step == 912)
        {
            FlxG.mouse.visible = false;

            gameCameraZoom = 0.6;

            plrStrumline.botplay = true;

            plrStrumline.resetStrums();

            plrStrumline.strums.alpha = 0.0;

            var plr:Character = getPlayer("bf-face-back-left");
            plr.visible = false;

            var plr2:Character = new Character(this, 0.0, 0.0, Character.getConfig("bf-anim-caught"));
            plr2.scale.set(4.6, 4.6);
            plr2.setPosition(580.0, 100.0);
            plr2.skipDance = true;
            plr2.skipSing = true;
            players.add(plr2);

            plr2.animation.play("caught");
            
            opponent.setPosition(90.0, -20.0);
            opponent.scale.set(0.4, 0.4);

            tweens.tween(opponent, {x: 105.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
            tweens.tween(opponent.scale, {x: 0.5, y: 0.5}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            detentionS.faculty0.visible = false;
            detentionS.faculty0portal.visible = false;
            detentionS.faculty2.visible = true;
        }

        if (step == 928)
        {
            detentionS.faculty1.visible = true;

            tweens.tween(opponent, {x: 250.0, y: 20.0}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(opponent.scale, {x: 1.7, y: 1.7}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            var plr2:Character = getPlayer("bf-anim-caught");

            plr2.animation.play("turn");
        }

        if (step == 944)
        {
            gameCameraZoom = 0.7;

            gameCamera.snapToTarget();

            cameraLock = FOCUS_CAM_CHAR;

            detentionS.office0.visible = true;
            detentionS.office2.visible = true;

            detentionS.faculty1.visible = false;
            detentionS.faculty2.visible = false;
            detentionS.faculty0.visible = false;

            oppStrumline.strums.alpha = 1.0;

            plrStrumline.botplay = Options.botplay;

            plrStrumline.strums.alpha = 1.0;

            plrStrumline.strums.x = FlxG.width - plrStrumline.strums.width - 45.0;

            var plr2:Character = getPlayer("bf-anim-caught");
            plr2.visible = false;

            var plr:Character = new Character(this, 0.0, 0.0, Character.getConfig("bf-face-left"));
            plr.scale.set(2.7, 2.7);
            plr.setPosition(840.0, 180.0);
            players.add(plr);
            player = plr;

            opponent.scale.set(1.2, 1.2);
            opponent.setPosition(170.0, 60.0);

            playField.setVisible(true);

            var timerText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "You get detention!\n30 seconds remain!", 48);

            timerText.camera = hudCamera;

            timerText.color = FlxColor.RED;
            
            timerText.font = Paths.font(Paths.ttf("Comic Sans MS"));

            timerText.alignment = CENTER;

            timerText.screenCenter();

            add(timerText);

            new FlxTimer(timers).start(1.0, (_timer:FlxTimer) ->
            {
                if (_timer.loopsLeft == 0.0)
                    timerText.active = timerText.visible = false;

                timerText.text = 'You get detention!\n${_timer.loopsLeft} seconds remain!';

                timerText.screenCenter();
            }, 30);

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 1200)
        {
            gameCameraZoom = 0.8;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 1456)
        {
            gameCameraZoom = 0.9;

            playField.setVisible(false);
        }

        if (step == 1472)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.7;

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1484)
        {
            opponent.visible = false;
            
            principal = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/principal"));
            principal.scale.set(1.45, 1.45);
            principal.updateHitbox();
            principal.setPosition(355.0, 155.0);
            detentionS.insert(detentionS.members.indexOf(players), principal);

            tweens.tween(principal, {x: 480.0, y: 64.0}, conductor.beatLength * 2.25 * 0.001, {ease: FlxEase.quadIn});

            tweens.tween(principal.scale, {x: 0.75, y: 0.75}, conductor.beatLength * 2.25 * 0.001, {ease: FlxEase.quadIn});
        }

        if (step == 1493)
        {
            detentionS.remove(principal, true);

            detentionS.insert(detentionS.members.indexOf(detentionS.office1), principal);

            detentionS.office0.visible = false;
            detentionS.office1.visible = true;

            if (FlxG.random.bool())
                tweens.tween(principal, {x: -principal.width / 0.75}, conductor.beatLength * 2.0 * 0.001);
            else
                tweens.tween(principal, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001);
        }

        if (step == 1504)
        {
            plrStrumline.botplay = true;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 32 && beat < 36 || beat >= 160 && beat < 164 || beat >= 232 && beat < 236)
        {
            if (beat % 1 == 0)
                gameCameraZoom += 0.05;
        }
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;

        portalRect.put();
    }

    public function updateLegStatus(name:String, frameNum:Int, frameIndex:Int):Void
    {
        var plr:Character = getPlayer("walk-legs");
    
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