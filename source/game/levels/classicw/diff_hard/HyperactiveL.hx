package game.levels.classicw.diff_hard;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.diff_hard.HyperactiveS;

using util.MathUtil;

using StringTools;

class HyperactiveL extends PlayState
{
    public var hyperactiveS:HyperactiveS;

    public var book:FlxSprite;

    override function create():Void
    {
        stage = new HyperactiveS();

        hyperactiveS = cast (stage, HyperactiveS);

        super.create();

        gameCameraZoom = 0.6;

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        hyperactiveS.hall.visible = true;

        opponent.visible = false;

        opponent.setPosition(1600.0, -55.0);

        opponent.color = 0xC4B99B;

        player.setPosition(-1200.0, 155.0);

        player.skipDance = true;

        player.animation.play("wright");

        player.color = 0xB8B19C;

        gameCamera.color = FlxColor.BLACK;

        playField.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 8.0 * 0.001, true);
        }

        if (step == 16)
        {
            hyperactiveS.hall.animation.play("0");
            
            tween.tween(player, {x: 160.0}, conductor.beatLength * 16.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 136)
        {
            hyperactiveS.hall.animation.pause();

            player.animation.play("sright");

            opponent.visible = true;

            tween.tween(player, {x: 175.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 144 || step == 1472)
            gameCameraZoom += 0.05;

        if (step == 168)
        {
            tween.tween(opponent, {x: -1800.0}, conductor.beatLength * 2.0 * 0.001);

            opponent.visible = true;
        }

        if (step == 171)
        {
            tween.tween(player, {x: -1900.0}, conductor.beatLength * 1.25 * 0.001);
        }

        if (step == 176)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            hyperactiveS.hall.visible = false;
            hyperactiveS.hall2.visible = true;
            hyperactiveS.hall2.animation.play("0", false, true);

            tween.cancelTweensOf(opponent);
            tween.cancelTweensOf(player);

            opponent.x = 1800.0;
            player.x = 1780.0;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-left"));
            plr.setPosition(player.x, player.y);
            plr.color = 0xB8B19C;
            players.add(plr);
            player = plr;

            tween.tween(opponent, {x: 180.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(player, {x: 160.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});

            playField.visible = true;

            gameCameraZoom = 0.6;
        }

        if (step == 432 || step == 624)
            gameCameraZoom = 0.6;

        if (step == 688)
            gameCameraZoom += 0.1;

        if (step == 800)
        {
            gameCameraZoom = 0.6;

            tween.tween(opponent, {x: 1600.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player, {x: 130.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartInOut});
        }

        if (step == 816)
        {
            hyperactiveS.hall2.animation.pause();

            opponent.visible = false;
        }

        if (step == 824)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-270"));
            opp.setPosition(-1600.0, -145.0);
            opp.color = 0xC4B99B;
            opponents.add(opp);
            opponent = opp;

            tween.cancelTweensOf(player);

            tween.tween(opponent, {x: 1800.0}, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 827)
        {
            tween.tween(player, {x: 2700.0}, conductor.beatLength * 1.0 * 0.001);
        }

        if (step == 832)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            hyperactiveS.hall2.animation.play("0", false, false);

            tween.cancelTweensOf(opponent);
            tween.cancelTweensOf(player);

            opponent.x = -1800.0;
            player.x = -1780.0;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(player.x, player.y);
            plr.color = 0xB8B19C;
            players.add(plr);
            player = plr;

            updateHealthBar("opponent");

            tween.tween(opponent, {x: -120.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(player, {x: 470.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1088)
        {
            gameCameraZoom = 0.6;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 1344)
        {
            gameCameraZoom += 0.1;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 1372)
        {
            var opp:Character = getOpponent("gotta-sweep");
            opp.visible = true;
            opp.x = -1800.0;
            opponent = opp;
            tween.tween(opp, {x: 130.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            updateHealthBar("opponent");

            var _opp:Character = getOpponent("1st-prize-270");
            tween.tween(_opp, {x: -140.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartInOut});
        }

        if (step == 1440 || step == 1504)
        {
            var opp:Character = getOpponent("1st-prize-270");
            opponent = opp;

            updateHealthBar("opponent");
        }

        if (step == 1456 || step == 1820)
        {
            var opp:Character = getOpponent("gotta-sweep");
            opponent = opp;

            updateHealthBar("opponent");
        }

        if (step == 1600)
        {
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            gameCameraZoom = 0.6;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 1624)
        {
            var opp:Character = getOpponent("1st-prize-270");
            
            tween.tween(opp, {x: 1600.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player, {x: 1900.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});

            var _opp:Character = getOpponent("gotta-sweep");

            tween.tween(_opp, {x: 100.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartInOut});
        }

        if (step == 1632)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            var opp:Character = getOpponent("1st-prize-270");
            opponent = opp;

            var _opp:Character = getOpponent("gotta-sweep");
            _opp.setPosition(-1675.0, -55.0);

            tween.cancelTweensOf(opponent);
            tween.cancelTweensOf(_opp);
            tween.cancelTweensOf(player);

            opponent.x = -1800.0;
            player.x = -1780.0;

            updateHealthBar("opponent");

            tween.tween(opponent, {x: -120.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(player, {x: 470.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1690)
        {
            var opp:Character = getOpponent("gotta-sweep");
            opponent = opp;
            tween.tween(opponent, {x: 170.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1692)
        {
            var opp:Character = getOpponent("1st-prize-270");
            tween.tween(opp, {x: 1900.0}, conductor.beatLength * 3.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player, {x: 130.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartInOut});
        }

        if (step == 1696)
        {
            player.visible = false;

            hyperactiveS.hall2.animation.play("0", false, true);

            updateHealthBar("opponent");

            var plr:Character = getPlayer("bf-face-left");
            plr.visible = true;
            plr.setPosition(player.x, player.y);
            player = plr;

            tween.tween(player, {x: 125.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1758)
        {
            var _opp:Character = getOpponent("1st-prize-270");
            _opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-90"));
            opp.setPosition(_opp.x, _opp.y);
            opp.color = 0xC4B99B;
            opponents.add(opp);
            opponent = opp;

            tween.tween(opp, {x: 190.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1760)
        {
            var opp:Character = getOpponent("gotta-sweep");
            tween.tween(opp, {x: 140.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(player, {x: 95.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            updateHealthBar("opponent");
        }

        if (step == 1880)
        {
            var opp:Character = getOpponent("1st-prize-90");
            tween.tween(opp, {x: -1600.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});

            var opp:Character = getOpponent("gotta-sweep");
            tween.tween(opp, {x: 165.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartInOut});

            tween.tween(player, {x: -1850.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1888)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            hyperactiveS.hall2.animation.play("0", false, false);

            var _opp:Character = getOpponent("1st-prize-90");
            _opp.visible = false;

            var opp:Character = getOpponent("1st-prize-270");
            opp.visible = true;
            opp.setPosition(_opp.x, _opp.y);
            opponent = opp;

            var __opp:Character = getOpponent("gotta-sweep");
            __opp.setPosition(-1675.0, -55.0);

            var plr:Character = getPlayer("bf-face-right");
            plr.visible = true;
            plr.setPosition(player.x, player.y);
            player = plr;

            tween.cancelTweensOf(__opp);
            tween.cancelTweensOf(opponent);
            tween.cancelTweensOf(player);

            updateHealthBar("opponent");

            opponent.x = -1800.0;
            player.x = -1780.0;

            tween.tween(opponent, {x: -120.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(player, {x: 470.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 2008)
        {
            var opp:Character = getOpponent("gotta-sweep");
            opponent = opp;
            tween.tween(opponent, {x: 285.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartInOut});
        }

        if (step == 2016)
        {
            tween.tween(opponent, {x: 185.0}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(player, {x: 547.5}, conductor.beatLength * 6.0 * 0.001, {ease: FlxEase.quartOut});

            updateHealthBar("opponent");
        }

        if (step == 2152)
        {
            tween.tween(opponent, {x: 1860.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(player, {x: 2240.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            var opp:Character = getOpponent("1st-prize-270");
            tween.tween(opp, {x: 1700.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 2160)
        {
            if (Options.flashingLights)
                gameCamera.fade(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 2168)
        {
            if (Options.flashingLights)
                gameCamera.fade(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, true, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            hyperactiveS.hall2.visible = false;
            hyperactiveS.room.visible = true;
            hyperactiveS.roomback.visible = true;

            gameCamBopStrength = 0.0;
            hudCamBopStrength = 0.0;

            var opp:Character = getOpponent("1st-prize-270");
            opp.x = -140.0;

            var _opp:Character = getOpponent("gotta-sweep");
            _opp.x = 300.0;

            player.x = 160.0;

            book = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/notebook-cyan"));
            book.scale.set(0.3, 0.3);
            book.updateHitbox();
            book.setPosition(1063.0, 340.0);
            book.color = 0xA19686;

            tween.tween(book, {y: book.y - 25}, conductor.beatLength * 2.0 * 0.001, 
                {
                    ease: FlxEase.sineInOut, 
                    type: PINGPONG
                }
            );
            
            add(book);

            tween.cancelTweensOf(_opp);
            tween.cancelTweensOf(opp);
            tween.cancelTweensOf(player);

            tween.tween(opp, {x: -90.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(_opp, {x: -90.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(player, {x: 190.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 2176)
        {
            var opp:Character = getOpponent("1st-prize-270");
            var _opp:Character = getOpponent("gotta-sweep");

            tween.tween(_opp, {x: -1800.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
            tween.tween(opp, {x: -1800.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 2188)
        {
            hyperactiveS.remove(opponents, true);
            hyperactiveS.insert(hyperactiveS.members.indexOf(hyperactiveS.room), opponents);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 104 && beat <= 107 || beat >= 152 && beat <= 155 || beat >= 268 && beat <= 271)
            gameCameraZoom += 0.025;
    }
}