package game.levels.week1;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import data.CharacterData;

import game.notes.Strumline;

import game.events.CameraFollowEvent;

import game.stages.School;

import core.Assets;
import core.Options;
import core.Paths;

using util.MathUtil;

using StringTools;

class Level1 extends PlayState
{
    public var castedStage(get, never):School;

    @:noCompletion
    function get_castedStage():School
    {
        return cast (stage, School);
    }

    public var temperature:FlxSprite;

    override function create():Void
    {
        stage = new School();

        super.create();

        gameCamera.alpha = 0.0;

        gameCameraTarget.centerTo();

        gameCameraZoom = 1.15;

        playField.visible = false;

        plrStrumline.removeEventListeners();

        plrStrumline.resetStrums();

        temperature = new FlxSprite();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0.0)
        {
            tween.tween(gameCamera, {alpha: 1.0}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            tween.tween(this, {gameCameraZoom: 0.75}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            opponents.visible = false;

            players.visible = false;
        }
        
        if (step == 136.0)
        {
            castedStage.hall0.visible = false;

            castedStage.hall1.visible = true;

            players.visible = true;

            var plr:Character = getPlayer("bf0");

            plr.skipDance = true;

            plr.animation.play("ay");

            plr.animation.onFinish.addOnce((name:String) -> plr.skipDance = false);

            plr.setPosition(685.0, 75.0);
        }

        if (step == 144.0)
        {
            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            castedStage.hall1.visible = false;

            castedStage.hall2.visible = true;

            castedStage.hall2.velocity.set(-2560.0, 0.0);

            opponents.visible = true;

            var opp:Character = getOpponent("baldi0");

            opp.skipDance = true;

            opp.setPosition(-845.0, 18.5);

            var plr:Character = getPlayer("bf0");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf1"));

            var anim:FlxAnimation = _plr.animation.getByName("dance");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            _plr.setPosition(798.5, 205.5);

            players.add(_plr);

            var __plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("run-legs"));

            anim = __plr.animation.getByName("legs");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            anim = __plr.animation.getByName("legs miss");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            __plr.animation.play("legs", true);

            __plr.skipDance = true;

            __plr.skipSing = true;

            __plr.setPosition(_plr.x, _plr.y);

            players.insert(players.members.indexOf(_plr), __plr);

            _plr.animation.onFrameChange.add(updateLegStatus);

            playField.visible = true;

            if (!plrStrumline.automated)
                plrStrumline.addEventListeners();
        }

        if (step == 464.0)
        {
            tween.color(temperature, conductor.beatLength * 16.0 * 0.001, FlxColor.WHITE, 0xFFFFD8D8,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 512.0)
        {
            var plr:Character = getPlayer("bf1");

            var _plr:Character = getPlayer("run-legs");

            tween.tween(plr, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.sineIn, 
                onUpdate: (tween:FlxTween) -> {_plr.x = plr.x;}});

            tween.tween(plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.sineIn});

            tween.tween(_plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001 * 0.001, {ease: FlxEase.sineIn});
        }

        if (step == 524.0)
        {
            var plr:Character = getPlayer("bf1");

            var sodaSplash:FlxSprite = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("globals/sodaSplash"))));

            sodaSplash.scale.set(11.5, 11.5);

            sodaSplash.updateHitbox();

            sodaSplash.setPosition(plr.getMidpoint().x - sodaSplash.width * 0.5, (FlxG.height - sodaSplash.height) * 0.5);

            castedStage.insert(castedStage.members.indexOf(players), sodaSplash);

            tween.tween(sodaSplash, {x: -855.0}, conductor.beatLength * 2.15 * 0.001, {onComplete: (_tween:FlxTween) ->
                {sodaSplash.active = sodaSplash.visible = false;}});
        }

        if (step == 528.0)
        {
            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            if (!Options.middlescroll)
            {
                tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

                tween.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartOut});
            }
        }

        if (step == 580.0)
        {
            var plr:Character = getPlayer("bf1");

            // TODO: Move this to the chart events list once we are out of the DEMO phase.

            CameraFollowEvent.dispatch(this, plr.getMidpoint().x - gameCameraTarget.width * 0.5, (FlxG.height - gameCameraTarget.height) * 0.5, "", 
                conductor.beatLength * 2.5 * 0.001, "quartInOut");

            var _plr:Character = getPlayer("run-legs");

            castedStage.hall2.velocity.set(castedStage.hall2.velocity.x *= 1.25, 0.0);

            tween.tween(castedStage.hall2.velocity, {x: castedStage.hall2.velocity.x / 1.25}, conductor.beatLength * 2.5 * 0.001,
                {ease: FlxEase.sineOut});

            tween.tween(plr.animation, {timeScale: 1.0}, conductor.beatLength * 2.5 * 0.001, {ease: FlxEase.sineOut});

            tween.tween(_plr.animation, {timeScale: 1.0}, conductor.beatLength * 2.5 * 0.001, {ease: FlxEase.sineOut});
        }

        if (step == 590.0)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bully0"));

            opp.flipX = true;

            opp.setPosition(2085.0, -685.0);

            opponents.add(opp);

            tween.tween(opp, {x: 1685}, conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 592.0)
        {
            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            // TODO: Move this to the chart events list once we are out of the DEMO phase.

            CameraFollowEvent.dispatch(this, (FlxG.width - gameCameraTarget.width) * 0.5, (FlxG.height - gameCameraTarget.height) * 0.5, "", -1.0);

            gameCamera.snapToTarget();

            updateHealthBar("bully0", "opponent");

            castedStage.hall2.visible = false;

            castedStage.hall3.visible = true;

            var opp:Character = getOpponent("baldi0");

            opp.visible = false;

            var _opp:Character = getOpponent("bully0");

            _opp.flipX = false;

            tween.cancelTweensOf(_opp);

            _opp.setPosition(-1085.0, -685.0);

            var plr:Character = getPlayer("bf1");

            plr.visible = false;

            var _plr:Character = getPlayer("run-legs");

            _plr.visible = false;

            var __plr:Character = getPlayer("bf0");

            __plr.visible = true;

            __plr.setPosition(775.0, 75.0);

            if (!Options.middlescroll)
            {
                tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);

                plrStrumline.strums.x = FlxG.width - plrStrumline.strums.width - 45.0;
            }
        }

        if (step == 720.0)
        {
            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            var opp:Character = getOpponent("bully0");

            opp.visible = false;

            var _opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bully1"));

            _opp.setPosition(-1085.0, -685.0);

            opponents.add(_opp);

            playField.statsText.visible = playField.healthBar.visible = 
                    playField.timeGauge.visible = playField.timeText.visible = false;
        }

        if (step == 848.0)
        {
            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = getOpponent("bully1");

            tween.tween(opp, {y: -opp.height / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.backIn});

            tween.tween(opp, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001);

            playField.statsText.visible = playField.healthBar.visible = 
                    playField.timeGauge.visible = playField.timeText.visible = true;

            if (!Options.middlescroll)
            {
                tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

                tween.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartOut});
            }
        }

        if (step == 864.0)
        {
            gameCameraZoom += 0.25;

            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("baldi1"));

            opp.skipDance = true;

            opp.scale.set(0.8, 0.8);

            opp.setPosition(140.0, 120.0);

            opponents.add(opp);

            var plr:Character = getPlayer("bf0");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf2"));

            _plr.setPosition(-280.0, 100.0);

            players.add(_plr);

            updateHealthBar("baldi1", "opponent");

            oppStrumline.strums.x = (FlxG.width - oppStrumline.strums.width) * 0.5;

            if (!Options.middlescroll)
            {
                playField.statsText.visible = playField.healthBar.visible = 
                    playField.timeGauge.visible = playField.timeText.visible = false;
                
                oppStrumline.strums.alpha = 1.0;

                plrStrumline.visible = false;
            }

            castedStage.hall3.visible = false;

            castedStage.hall4.visible = true;

            temperature.color = gameCamera.color = 0xFFFFBFBF;
        }

        if (step == 878.0)
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.5 * 0.001);

        if (step == 880.0)
        {
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.001, true, null, true);

            var plr:Character = getPlayer("bf2");

            plr.visible = false;

            var opp:Character = getOpponent("baldi1");

            opp.setPosition(390.0, 135.0);

            if (!Options.middlescroll)
            {
                oppStrumline.downscroll = !oppStrumline.downscroll;

                tween.tween(oppStrumline.strums, {y: oppStrumline.downscroll ? FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, 
                    conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

                tween.tween(oppStrumline.strums, {alpha: 0.35}, conductor.beatLength * 0.001);

                plrStrumline.visible = true;
            }

            castedStage.hall4.visible = false;

            castedStage.hall5.visible = true;

            var anim:FlxAnimation = castedStage.hall5.animation.getByName("0");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 992.0)
        {
            gameCameraZoom -= 0.25;

            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = getOpponent("baldi0");

            opp.visible = true;

            opp.setPosition(-845.0, 18.5);

            var _opp:Character = getOpponent("baldi1");

            _opp.visible = false;

            var plr:Character = getPlayer("bf1");

            plr.visible = true;

            plr.setPosition(798.5, 205.5);

            var _plr:Character = getPlayer("run-legs");

            _plr.visible = true;

            _plr.setPosition(plr.x, plr.y);

            playField.statsText.visible = playField.healthBar.visible = 
                    playField.timeGauge.visible = playField.timeText.visible = true;

            if (!Options.middlescroll)
            {
                oppStrumline.downscroll = !oppStrumline.downscroll;

                tween.tween(oppStrumline.strums, {x: 45.0, y: oppStrumline.downscroll ? 
                    FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, conductor.beatLength * 0.001,
                        {ease: FlxEase.quartOut});

                tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);

                tween.tween(plrStrumline.strums, {x: FlxG.width - plrStrumline.strums.width - 45.0}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartOut});
            }

            castedStage.hall2.visible = true;

            castedStage.hall5.visible = false;

            castedStage.exit0.visible = true;

            castedStage.exit0.velocity.x = -2560.0;

            castedStage.exit0.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 1240.0)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("principal0"));

            opp.setPosition(-862.5, 22.5);

            opponents.add(opp);
        }

        if (step == 1248.0)
        {
            var opp:Character = getOpponent("baldi0");

            opp.skipSing = true;
        }

        if (step == 1256.0)
        {
            var opp:Character = getOpponent("principal0");

            var plr:Character = getPlayer("bf1");

            tween.tween(opp, {x: plr.x - 115.0}, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 1264.0)
        {
            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            var opp:Character = getOpponent("baldi0");

            opp.visible = false;

            var _opp:Character = getOpponent("principal0");

            _opp.scale.set(1.5, 1.5);

            tween.cancelTweensOf(_opp);

            _opp.setPosition(-500.0, 200.0);

            var plr:Character = getPlayer("bf1");

            plr.visible = false;

            var _plr:Character = getPlayer("run-legs");

            _plr.visible = false;

            var __plr:Character = getPlayer("bf0");

            __plr.visible = true;

            __plr.scale.set(2.0, 2.0);

            __plr.setPosition(375.0, 0.0);

            updateHealthBar("principal0", "opponent");

            castedStage.hall2.visible = false;

            castedStage.office0.visible = true;

            var timerText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "You get detention!\n45 seconds remain!", 48);

            timerText.camera = hudCamera;

            timerText.color = FlxColor.RED;
            
            timerText.font = Paths.font(Paths.ttf("Comic Sans MS"));

            timerText.alignment = CENTER;

            timerText.textField.antiAliasType = ADVANCED;

            timerText.textField.sharpness = 400.0;

            timerText.screenCenter();

            add(timerText);

            new FlxTimer(timer).start(1.0, (_timer:FlxTimer) ->
            {
                if (_timer.loopsLeft == 0.0)
                    timerText.active = timerText.visible = false;

                timerText.text = 'You get detention!\n${_timer.loopsLeft} seconds remain!';

                timerText.screenCenter();
            }, 45);
        }

        if (step == 1456.0)
        {
            var opp:Character = getOpponent("principal0");

            tween.tween(opp, {x: 60.0, y: -3.5}, conductor.beatLength * 2.5 * 0.001);

            tween.tween(opp.scale, {x: 0.515, y: 0.515}, conductor.beatLength * 2.5 * 0.001);

            if (!Options.middlescroll)
            {
                tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

                tween.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                    {ease: FlxEase.quartOut});
            }
        }

        if (step == 1466.0)
        {
            var opp:Character = getOpponent("principal0");

            if (FlxG.random.bool())
                tween.tween(opp, {x: -opp.width / 0.75}, conductor.beatLength * 2.0 * 0.001);
            else
                tween.tween(opp, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001);

            castedStage.remove(opponents, true);

            castedStage.insert(castedStage.members.indexOf(castedStage.office2), opponents);

            castedStage.office0.visible = false;

            castedStage.office1.visible = true;

            castedStage.office2.visible = true;
        }

        if (step == 1488.0)
        {
            hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
           
            gameCameraZoom -= 0.15;

            var opp:Character = getOpponent("baldi1");

            opp.visible = true;

            opp.scale.set(0.25, 0.25);

            opp.setPosition(385.0, 110.0);

            var _opp:Character = getOpponent("principal0");

            _opp.visible = false;

            castedStage.remove(opponents, true);

            castedStage.insert(castedStage.members.indexOf(castedStage.office4), opponents);

            var plr:Character = getPlayer("bf0");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-window"));

            _plr.skipDance = true;

            _plr.skipSing = true;

            _plr.animation.play("window1");

            _plr.setPosition(500.0, 0.0);

            players.add(_plr);

            updateHealthBar("baldi1", "opponent");

            playField.visible = false;

            plrStrumline.removeEventListeners();

            plrStrumline.resetStrums();

            castedStage.office1.visible = false;

            castedStage.office2.visible = false;

            castedStage.office3.visible = true;

            castedStage.office4.visible = true;
        }

        if (step == 1496.0)
        {
            castedStage.office3.visible = false;

            castedStage.office5.visible = true;
        }

        if (step == 1504.0)
        {
            var plr:Character = getPlayer("bf-window");

            plr.animation.play("window2");
        }

        if (step == 1520.0)
        {
            var plr:Character = getPlayer("bf-window");

            plr.animation.play("window3");
        }

        if (step == 1536.0)
        {
            var plr:Character = getPlayer("bf-window");

            plr.animation.play("window4");
        }

        if (step == 1544.0)
        {
            var plr:Character = getPlayer("bf-window");

            plr.animation.play("window5");

            tween.tween(plr, {x: gameCamera.viewLeft - plr.width}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.backIn});
        }

        if (step == 1548.0)
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.001, false);

        if (step == 1552.0)
        {
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.001, true, null, true);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 36.0 && beat <= 132.0 || beat >= 248.0 && beat < 316.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi0");

                if (beat == 132.0)
                {
                    tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineIn, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 725.0}, 0.35);}});  
                }
                else
                {
                    tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.35 * 0.001,
                        {ease: FlxEase.sineIn, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 725.0}, 0.5);}});
                }

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 180.0 && beat < 212.0)
        {
            for (i in 0 ... FlxG.cameras.list.length)
            {
                var camera:FlxCamera = FlxG.cameras.list[i];

                camera.angle = beat % 2.0 == 0.0 ? -1.5 : 1.5;

                tween.tween(camera, {angle: 0.0}, conductor.beatLength * 0.85 * 0.001);
            }

            if (beat % 4.0 == 0.0)
            {
                for (i in 0 ... playField.strumlines.members.length)
                {
                    var strumline:Strumline = playField.strumlines.members[i];

                    var upY:Float = 15.0;

                    var downY:Float = FlxG.height - strumline.strums.height - 15.0;

                    strumline.downscroll = !strumline.downscroll;

                    tween.tween(strumline.strums, {y: strumline.downscroll ? downY : upY}, conductor.beatLength * 0.001,
                        {ease: FlxEase.backOut});
                }
            }
        }

        if (beat >= 216.0 && beat <= 218.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi1");

                tween.tween(opp.scale, {x: opp.scale.x + 0.3, y: opp.scale.y + 0.3}, conductor.beatLength * 0.275 * 0.001);

                tween.tween(opp, {x: opp.x + 30.0}, conductor.beatLength * 0.275 * 0.001);

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 220.0 && beat < 248.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi1");

                tween.tween(opp.scale, {x: 2.0, y: 2.0}, conductor.beatLength * 0.25 * 0.001,
                    {ease: FlxEase.sineIn, onComplete: (_tween:FlxTween) -> {tween.tween(opp.scale, {x: 1.0,
                        y: 1.0}, 0.85);}});

                tween.tween(opp, {y: 150.0}, conductor.beatLength * 0.25 * 0.001,
                    {ease: FlxEase.sineIn, onComplete: (_tween:FlxTween) -> {tween.tween(opp, 
                        {y: 125.0}, 0.85);}});
                
                opp.animation.play("slap", true);
            }
        }

        if (beat >= 372.0 && beat <= 388.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi1");

                tween.tween(opp.scale, {x: opp.scale.x + 0.2, y: opp.scale.y + 0.2},
                    conductor.beatLength * 0.275 * 0.001);
                
                tween.tween(opp, {x: beat == 388.0 ? opp.x - 365.0 : opp.x + 1.0 * opp.scale.x}, conductor.beatLength * 0.275 * 0.001);

                tween.tween(opp, {y: opp.y + 5.0}, conductor.beatLength * 0.275 * 0.001);

                opp.animation.play("slap", true);
            }
        }
    }

    public function updateLegStatus(name:String, frameNum:Int, frameIndex):Void
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