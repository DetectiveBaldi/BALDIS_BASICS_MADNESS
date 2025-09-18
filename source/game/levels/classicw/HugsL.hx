package game.levels.classicw;

import openfl.filters.BitmapFilter;

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

import data.LevelData;

import game.stages.classicw.HugsS;

using util.MathUtil;

using StringTools;

using util.ArrayUtil;

class HugsL extends PlayState
{
    public var sprite:FlxSprite;

    public var hugsS:HugsS;

    public var portalRect:FlxRect;

    override function create():Void
    {
        stage = new HugsS();

        hugsS = cast (stage, HugsS);

        super.create();

        hugsS.hallstill.visible = true;

        hugsS.doorStandard.visible = true;

        hugsS.doorStandard.x = 600.0;
    
        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCamera.color = 0x000000;

        gameCameraZoom = 0.6;

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

        oppStrumline.strums.alpha = 0.0;

        plrStrumline.botplay = true;

        plrStrumline.strums.alpha = 0.0;

        player.setPosition(-1000.0, 120.0);

        player.skipDance = true;

        player.animation.play("wright");

        opponent.setPosition(200.0, -145.0);

        var oppStrumlineX:Float = oppStrumline.strums.x;

        var plrStrumlineX:Float = plrStrumline.strums.x;

        oppStrumline.strums.x = plrStrumlineX;

        plrStrumline.strums.x = oppStrumlineX;

        AssetCache.getGraphic("game/Character/bf-face-right");
        AssetCache.getGraphic("game/Character/bf-intro-adrenaline");
        AssetCache.getGraphic("game/Character/bf-running");
        AssetCache.getGraphic("game/Character/run-legs");

        AssetCache.getGraphic("game/Character/1st-prize-90");
        AssetCache.getGraphic("game/Character/1st-prize-270");
    
        AssetCache.getGraphic("game/stages/shared/scrolling-hall0");

        portalRect = FlxRect.get();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (hugsS.hallend.visible || hugsS.hallendportal.visible && hugsS.hallend.velocity.x == 0.0)
        {
            if (FlxG.mouse.justPressed && FlxMath.pointInFlxRect(FlxG.mouse.x, FlxG.mouse.y, portalRect))
            {
                if ( #if debug false #else PlayState.isWeek #end )
                    FlxG.sound.play(AssetCache.getSound("shared/portal-poster-error"));
                else
                {
                    if (hugsS.hallend.visible)
                    {
                        hugsS.hallend.visible = false;

                        hugsS.hallendportal.visible = true;

                        FlxG.sound.play(AssetCache.getSound("shared/portal-poster-hit"));
                    }
                    else
                        PlayState.loadLevel(LevelData.list.first((lv:LevelData) -> lv.name == "Uncanon"));
                }
            }
        }
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 16.0 * 0.001, true);

            tween.tween(opponent, {x: 450.0}, conductor.beatLength * 8.0 * 0.001);
        }

        if (step == 16)
            tween.tween(player, {x: -260.0}, conductor.beatLength * 4.0 * 0.001);

        if (step == 32)
        {
            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.x += 250.0;

            tween.tween(this, {gameCameraZoom: gameCameraZoom + 0.35}, conductor.beatLength * 0.001);

            gameCameraZoom += 0.35;

            player.animation.play("sright");
        }

        if (step == 56)
        {
            plrStrumline.botplay = Options.botplay;

            var _plr:Character = getPlayer("bf-intro-adrenaline");
            _plr.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-260.0, 175.0);
            plr.skipDance = false;
            players.add(plr);
            player = plr;

            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001);

            tween.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 64)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            cameraPoint.centerTo();

            gameCamera.snapToTarget();

            gameCamera.zoom = gameCameraZoom - 0.35;

            gameCameraZoom -= 0.35;

            var opp:Character = getOpponent("1st-prize-270");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-292-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 96)
        {
            var opp:Character = getOpponent("1st-prize-292-5");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-315"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 128)
        {
            var opp:Character = getOpponent("1st-prize-315");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-337-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 160)
        {
            var opp:Character = getOpponent("1st-prize-337-5");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-0"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 192)
        {
            var opp:Character = getOpponent("1st-prize-0");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-22-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 224)
        {
            var opp:Character = getOpponent("1st-prize-22-5");
            opp.visible = false;
      
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-45"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 256)
        {
            var opp:Character = getOpponent("1st-prize-45");
            opp.visible = false;
      
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-67-5"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 288)
        {
            var opp:Character = getOpponent("1st-prize-67-5");
            opp.visible = false;
     
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-90"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(450.0, -145.0);
            opponents.add(opp);
            opponent = opp;
        }

        if (step == 306)
            tween.tween(opponent, {x: -1500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 316)
            tween.tween(player, {x: -800.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 320)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            hugsS.hallcorner2.visible = false;

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;
            
            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            var opp:Character = getOpponent("1st-prize-90");
            opp.visible = false;

            var opp:Character = getOpponent("1st-prize-270");
            opp.x = -1500.0;
            opp.visible = true;
            opponent = opp;

            hugsS.hallstill.visible = false;
            hugsS.hall.visible = true;
            hugsS.hall.animation.play("0");
            hugsS.doorStandard.visible = false;

            player.x = -800.0;

            tween.tween(opponent, {x: -100.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(player, {x: 500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }
        
        if (step == 576)
            gameCameraZoom += 0.125;

        if (step == 697)
        {
            hugsS.hallcorner2.visible = true;

            hugsS.hallcorner2.velocity.x = -3840.0;

            hugsS.hallcorner2.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 704)
        {
            hugsS.hallcorner2.velocity.x = 0;

            playField.healthBar.percent -= 35;

            var opp:Character = getOpponent("1st-prize-270");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-225"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(-100.0, -145.0);
            opponents.add(opp);
            opponent = opp;

            hugsS.remove(players, true);
            hugsS.insert(hugsS.members.indexOf(opponents), players);

            tween.tween(player.scale, {x: 2.4, y: 2.4}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(player, {x: 190.0, y: 110.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 720)
        {
            var opp:Character = getOpponent("1st-prize-225");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-180"));
            opp.scale.set(3.0, 3.0);
            opp.setPosition(-100.0, -145.0);
            opponents.add(opp);
            opponent = opp;

            tween.tween(opponent.scale, {x: 2.0, y: 2.0}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player.scale, {x: 1.5, y: 1.5}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(opponent, {x: -97.0, y: -250.0}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player, {x: 192.0, y: 80.0}, conductor.beatLength * 3.9 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 736)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            hugsS.hallcorner2.visible = false;

            var opp:Character = getOpponent("1st-prize-180");
            opp.visible = false;

            player.y = 140.0;
            player.scale.set(2.7, 2.7);

            var opp:Character = getOpponent("1st-prize-270");
            opp.x = -1500.0;
            opp.visible = true;
            opponent = opp;

            hugsS.hall.visible = true;

            player.x = -800.0;

            hugsS.remove(opponents, true);
            hugsS.insert(hugsS.members.indexOf(players), opponents);

            tween.tween(opponent, {x: -100.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(player, {x: 500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 992 || step == 1440)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCameraZoom += 0.125;
        }

        if (step == 1110)
        {
            hugsS.hallcorner4.visible = true;

            hugsS.hallcorner4.velocity.x = -3840.0;

            hugsS.hallcorner4.x = gameCamera.viewX + gameCamera.viewWidth;   
        }

        if (step == 1116)
        {
            hugsS.hallcorner4.velocity.x = 0.0;

            playField.healthBar.percent -= 35;

            tween.tween(opponent, {x: -110.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1120)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            hugsS.hallcorner4.visible = false;
            hugsS.hallcorner1.visible = true;

            gameCameraZoom = 0.6;

            hugsS.hallcorner1.velocity.x = -3840.0;
            hugsS.hall.visible = true;

            var plr:Character = getPlayer("bf-face-right");
            plr.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-running"));
            var anim:FlxAnimation = plr.animation.getByName("dance");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);
            players.add(plr);
            player = plr;

            var __plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("run-legs"));

            var anim:FlxAnimation = __plr.animation.getByName("legs");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);
            anim = __plr.animation.getByName("legs miss");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);

            __plr.animation.play("legs", true);
            __plr.skipDance = true;
            __plr.skipSing = true;

            players.insert(players.members.indexOf(player), __plr);

            player.setPosition(340.0, 140.0);

            __plr.setPosition(player.x, player.y);

            player.animation.onFrameChange.add(updateLegStatus);

            var opp:Character = getOpponent("1st-prize-270");
            opp.visible = false;

            var opp:Character = getOpponent("1st-prize-337-5");
            opp.setPosition(-800.0, -180.0);
            opp.visible = true;
            opponent = opp;

            tween.tween(opponent, {x: -2000.0}, conductor.beatLength * 1.25 * 0.001);
        }

        if (step == 1178)
            tween.tween(opponent, {x: 3800.0}, conductor.beatLength * 2.0 * 0.001);

        if (step == 1180)
        {
            tween.tween(player, {x: 2100.0}, conductor.beatLength * 1.0 * 0.001);

            var _plr:Character = getPlayer("run-legs");
            tween.tween(_plr, {x: 2100.0}, conductor.beatLength * 1.0 * 0.001);

            hugsS.hall.animation.pause();
        }
        
        if (step == 1184)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            var opp:Character = getOpponent("1st-prize-337-5");
            opp.visible = false;

            var opp:Character = getOpponent("1st-prize-270");
            opp.x = -1500.0;
            opp.visible = true;
            opponent = opp;

            hugsS.hall.animation.resume();

            var plr:Character = getPlayer("bf-running");
            plr.visible = false;

            var plr:Character = getPlayer("run-legs");
            plr.visible = false;

            var plr:Character = getPlayer("bf-face-right");
            plr.visible = true;
            player = plr;

            player.x = -800.0;
            player.y = 140.0;
            player.scale.set(2.7, 2.7);

            hugsS.remove(opponents, true);
            hugsS.insert(hugsS.members.indexOf(players), opponents);

            tween.tween(opponent, {x: -100.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
            tween.tween(player, {x: 500.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1562)
        {
            hugsS.hallend.visible = true;

            hugsS.hallend.velocity.x = -3840.0;

            hugsS.hallend.x = gameCamera.viewX + gameCamera.viewWidth;   
        }

        if (step == 1568)
        {
            FlxG.mouse.visible = true;

            FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

            hugsS.hallend.velocity.x = 0.0;

            hugsS.hallendportal.x = hugsS.hallend.x;

            portalRect.set(hugsS.hallendportal.x + 752.0 * 1.15, hugsS.hallendportal.y + 289.0 * 1.15,
                310.0 * 1.15, 510.0 * 1.15);

            var plr:Character = getPlayer("bf-face-right");
            plr.visible = false;

            var plr:Character = getPlayer("bf-running");
            plr.x = 500.0;
            plr.visible = true;
            player = plr;

            tween.tween(player, {x: 2400.0}, conductor.beatLength * 4.0 * 0.001);

            var _plr:Character = getPlayer("run-legs");

            var anim:FlxAnimation = _plr.animation.getByName("legs");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);
            anim = _plr.animation.getByName("legs miss");
            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.0025);

            _plr.animation.play("legs", true);
            _plr.x = 500.0;
            _plr.skipDance = true;
            _plr.skipSing = true;

            players.insert(players.members.indexOf(player), _plr);

            tween.tween(_plr, {x: 2400.0}, conductor.beatLength * 4.0 * 0.001);
            _plr.visible = true;

            player.animation.onFrameChange.add(updateLegStatus);

            var opp:Character = getOpponent("1st-prize-270");
            opp.visible = false;

            var _opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-spin"));
            _opp.setPosition(120.0, 245.0);
            _opp.animation.play("spin");
            _opp.skipDance = true;
            _opp.skipSing = true;
            opponents.add(_opp);
            opponent = _opp;
        }

        if (step == 1584)
        {
            playField.visible = false;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 16.0 * 0.001, false);
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
        var plr:Character = getPlayer("run-legs");
    
        var curFrame:Int = plr.animation.curAnim.curFrame;
    
        if (name.contains("MISS"))
            plr.animation.play("legs miss", false, false, curFrame);
        else
            plr.animation.play("legs", false, false, curFrame);
    }
}