package game.levels;

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

import game.events.FocusCamPointEvent;

import game.stages.RoughES;

import shaders.PixelChunks;

using util.MathUtil;

using StringTools;

class RoughEL extends PlayState
{
    public var roughES(get, never):RoughES;

    @:noCompletion
    function get_roughES():RoughES
    {
        return cast (stage, RoughES);
    }

    public var temperature:FlxSprite;
    
    public var checkLayer:Bool;
    public var timeInterval:Float;

    public var craftersSprite1:FlxSprite;

    public var vignette:FlxSprite;

    public var pxChunks:PixelChunks;

    public var pxContainer:ShaderFilter;

    override function create():Void
    {
        stage = new RoughES();

        super.create();

        gameCamera.alpha = 0.0;

        cameraPoint.centerTo();

        cameraLock = MANUAL;

        gameCameraZoom = 1.15;

        playField.visible = false;

        plrStrumline.clearKeys();

        plrStrumline.resetStrums();

        Assets.getGraphic("game/Character/1st-prize-anim-coming");

        Assets.getGraphic("game/Character/1st-prize-0");

        Assets.getGraphic("game/Character/baldi-mad");

        Assets.getGraphic("game/Character/baldi-mad-face-front");

        Assets.getGraphic("game/Character/baldi-furious");

        Assets.getGraphic("game/Character/bf-face-left");

        Assets.getGraphic("game/Character/bf-running");

        Assets.getGraphic("game/Character/bf-clutching-wall");

        Assets.getGraphic("game/Character/bully");

        Assets.getGraphic("game/Character/gotta-sweep");

        Assets.getGraphic("game/Character/playtime");

        Assets.getGraphic("game/Character/principal");

        Assets.getGraphic("game/Character/run-legs");

        temperature = new FlxSprite();
    
        checkLayer = true;
        timeInterval = 0.75;
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
            roughES.hall0.visible = false;

            roughES.hall1.visible = true;

            players.visible = true;

            var plr:Character = getPlayer("bf-face-left");

            plr.skipDance = true;

            plr.animation.play("ay");

            plr.animation.onFinish.addOnce((name:String) -> plr.skipDance = false);

            plr.setPosition(785.0, 170.0);
        }

        if (step == 144.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            roughES.hall1.visible = false;

            roughES.hall2.visible = true;

            roughES.hall2.velocity.set(-2560.0, 0.0);

            opponents.visible = true;

            var opp:Character = getOpponent("baldi-mad");

            opp.skipDance = true;

            opp.setPosition(-845.0, 18.5);

            var plr:Character = getPlayer("bf-face-left");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-running"));

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

            if (!Options.botplay)
                plrStrumline.getKeys();
        }

        if (step == 464.0)
        {
            tween.color(temperature, conductor.beatLength * 16.0 * 0.001, temperature.color, 0xFFFFD8D8,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 512.0)
        {
            var plr:Character = getPlayer("bf-running");

            var _plr:Character = getPlayer("run-legs");

            tween.tween(plr, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.sineIn, 
                onUpdate: (tween:FlxTween) -> {_plr.x = plr.x;}});

            tween.tween(plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.sineIn});

            tween.tween(_plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001 * 0.001, {ease: FlxEase.sineIn});
        }

        if (step == 524.0)
        {
            var plr:Character = getPlayer("bf-running");

            var sodaSplash:FlxSprite = new FlxSprite(0.0, 0.0, Assets.getGraphic("shared/sodaSplash"));

            sodaSplash.scale.set(11.5, 11.5);

            sodaSplash.updateHitbox();

            sodaSplash.setPosition(plr.getMidpoint().x - sodaSplash.width * 0.5, (FlxG.height - sodaSplash.height) * 0.5);

            roughES.insert(roughES.members.indexOf(players), sodaSplash);

            tween.tween(sodaSplash, {x: -855.0}, conductor.beatLength * 2.15 * 0.001, {onComplete: (_tween:FlxTween) ->
                {sodaSplash.active = sodaSplash.visible = false;}});
        }

        if (step == 528.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

            tween.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});
        }

        if (step == 580.0)
        {
            var plr:Character = getPlayer("bf-running");

            FocusCamPointEvent.dispatch(this, plr.getMidpoint().x - cameraPoint.width * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, conductor.beatLength * 2.5 * 0.001, "quartInOut");

            var _plr:Character = getPlayer("run-legs");

            roughES.hall2.velocity.set(roughES.hall2.velocity.x *= 1.25, 0.0);

            tween.tween(roughES.hall2.velocity, {x: roughES.hall2.velocity.x / 1.25}, conductor.beatLength * 2.5 * 0.001,
                {ease: FlxEase.sineOut});

            tween.tween(plr.animation, {timeScale: 1.0}, conductor.beatLength * 2.5 * 0.001, {ease: FlxEase.sineOut});

            tween.tween(_plr.animation, {timeScale: 1.0}, conductor.beatLength * 2.5 * 0.001, {ease: FlxEase.sineOut});
        }

        if (step == 590.0)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bully"));

            opp.flipX = true;

            opp.setPosition(2285.0, -555.0);

            opponents.add(opp);

            tween.tween(opp, {x: 1885}, conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 592.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, -1.0);

            gameCamera.snapToTarget();

            roughES.hall2.visible = false;

            roughES.hall3.visible = true;

            var opp:Character = getOpponent("baldi-mad");

            opp.visible = false;

            var _opp:Character = getOpponent("bully");

            _opp.flipX = false;

            tween.cancelTweensOf(_opp);

            _opp.setPosition(-685.0, -555.0);

            opponent = _opp;

            updateHealthBar("opponent");

            var plr:Character = getPlayer("bf-running");

            plr.visible = false;

            var _plr:Character = getPlayer("run-legs");

            _plr.visible = false;

            var __plr:Character = getPlayer("bf-face-left");

            __plr.visible = true;

            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);

            plrStrumline.strums.x = FlxG.width - plrStrumline.strums.width - 45.0;
        }

        if (step == 720.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 848.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = getOpponent("bully");

            opp.skipDance = true;

            opp.animation.play("spin");

            tween.tween(opp, {y: -opp.height / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.backIn});

            tween.tween(opp, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001);

            tween.tween(opp.animation, {timeScale: 2.5}, conductor.beatLength * 4.0 * 0.001,
                {ease: FlxEase.backIn});

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

            tween.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});
        }

        if (step == 864.0)
        {
            gameCameraZoom = 1.0;

            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("baldi-mad-face-front"));

            opp.skipDance = true;

            opp.scale.set(0.8, 0.8);

            opp.setPosition(140.0, 120.0);

            opponents.add(opp);

            var plr:Character = getPlayer("bf-face-left");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-clutching-wall"));

            _plr.setPosition(-280.0, 125.0);

            players.add(_plr);

            opponent = opp;

            updateHealthBar("opponent");

            oppStrumline.strums.x = (FlxG.width - oppStrumline.strums.width) * 0.5;

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
            
            oppStrumline.strums.alpha = 1.0;

            plrStrumline.visible = false;

            roughES.hall3.visible = false;

            roughES.hall4.visible = true;

            tween.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFFBFBF,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 878.0)
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.5 * 0.001);

        if (step == 880.0)
        {
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.001, true, null, true);

            var plr:Character = getPlayer("bf-clutching-wall");

            plr.visible = false;

            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.setPosition(390.0, 135.0);

            oppStrumline.downscroll = !oppStrumline.downscroll;

            tween.tween(oppStrumline.strums, {y: oppStrumline.downscroll ? FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, 
                conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tween.tween(oppStrumline.strums, {alpha: 0.35}, conductor.beatLength * 0.001);

            plrStrumline.visible = true;

            roughES.hall4.visible = false;

            roughES.hall5.visible = true;

            var anim:FlxAnimation = roughES.hall5.animation.getByName("0");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 992.0)
        {
            gameCameraZoom = 0.75;

            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = getOpponent("baldi-mad");

            opp.visible = true;

            opp.setPosition(-845.0, 18.5);

            var _opp:Character = getOpponent("baldi-mad-face-front");

            _opp.visible = false;

            var plr:Character = getPlayer("bf-running");

            plr.visible = true;

            plr.setPosition(798.5, 205.5);

            var _plr:Character = getPlayer("run-legs");

            _plr.visible = true;

            _plr.setPosition(plr.x, plr.y);

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            oppStrumline.downscroll = !oppStrumline.downscroll;

            tween.tween(oppStrumline.strums, {x: 45.0, y: oppStrumline.downscroll ? 
                FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, conductor.beatLength * 0.001,
                    {ease: FlxEase.quartOut});

            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);

            tween.tween(plrStrumline.strums, {x: FlxG.width - plrStrumline.strums.width - 45.0}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});

            roughES.hall2.visible = true;

            roughES.hall5.visible = false;

            roughES.exit0.visible = true;

            roughES.exit0.velocity.x = -2560.0;

            roughES.exit0.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 1240.0)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("principal"));

            opp.setPosition(-862.5, 22.5);

            opponents.add(opp);
        }

        if (step == 1248.0)
        {
            var opp:Character = getOpponent("baldi-mad");

            opp.skipSing = true;
        }

        if (step == 1256.0)
        {
            var opp:Character = getOpponent("principal");

            var plr:Character = getPlayer("bf-running");

            tween.tween(opp, {x: plr.x - 115.0}, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 1264.0)
        {
            gameCameraZoom = 0.75;

            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 - 225.0,
                (FlxG.height - cameraPoint.height) * 0.5 + 50.0, -1.0);

            gameCamera.snapToTarget();

            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            var opp:Character = getOpponent("baldi-mad");

            opp.visible = false;

            var _opp:Character = getOpponent("principal");

            _opp.scale.set(1.4, 1.4);

            tween.cancelTweensOf(_opp);

            _opp.setPosition(-350.0, 50.0);

            var plr:Character = getPlayer("bf-running");

            plr.visible = false;

            var _plr:Character = getPlayer("run-legs");

            _plr.visible = false;

            var __plr:Character = getPlayer("bf-face-left");

            __plr.visible = true;

            __plr.scale.set(2.7, 2.7);

            __plr.setPosition(425.0, 210.0);

            opponent = _opp;

            updateHealthBar("opponent");

            roughES.hall2.visible = false;

            roughES.office0.visible = true;

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

            tween.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFFA5A5,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1456.0)
        {
            var opp:Character = getOpponent("principal");

            tween.tween(opp, {x: 60.0, y: -3.5}, conductor.beatLength * 2.5 * 0.001);

            tween.tween(opp.scale, {x: 0.515, y: 0.515}, conductor.beatLength * 2.5 * 0.001);

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

            tween.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});
        }

        if (step == 1466.0)
        {
            var opp:Character = getOpponent("principal");

            if (FlxG.random.bool())
                tween.tween(opp, {x: -opp.width / 0.75}, conductor.beatLength * 2.0 * 0.001);
            else
                tween.tween(opp, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001);

            roughES.remove(opponents, true);

            roughES.insert(roughES.members.indexOf(roughES.office2), opponents);

            roughES.office0.visible = false;

            roughES.office1.visible = true;

            roughES.office2.visible = true;
        }

        if (step == 1488.0)
        {
            gameCameraZoom = 0.6;

            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, -1.0);

            gameCamera.snapToTarget();

            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.visible = true;

            opp.scale.set(0.25, 0.25);

            opp.setPosition(385.0, 110.0);

            var _opp:Character = getOpponent("principal");

            _opp.visible = false;

            roughES.remove(opponents, true);

            roughES.insert(roughES.members.indexOf(roughES.office4), opponents);

            var plr:Character = getPlayer("bf-face-left");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-anim-window"));

            _plr.skipDance = true;

            _plr.skipSing = true;

            _plr.animation.play("window1", true);

            _plr.setPosition(500.0, 0.0);

            players.add(_plr);

            opponent = opp;

            updateHealthBar("opponent");

            playField.visible = false;

            plrStrumline.clearKeys();

            plrStrumline.resetStrums();

            roughES.office1.visible = false;

            roughES.office2.visible = false;

            roughES.office3.visible = true;

            roughES.office4.visible = true;

            tween.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFF8C8C,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1496.0)
        {
            roughES.office3.visible = false;

            roughES.office5.visible = true;
        }

        if (step == 1504.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window2", true);
        }

        if (step == 1520.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window3", true);
        }

        if (step == 1536.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window4", true);
        }

        if (step == 1544.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window5", true);

            tween.tween(plr, {x: gameCamera.viewLeft - plr.width}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.backIn});
        }

        if (step == 1552.0)
        {
            gameCameraZoom = 0.58;

            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-anim-unlock"));

            _plr.skipDance = true;

            _plr.animation.play("unlock", true);

            _plr.setPosition(600.0, 150.0);

            players.add(_plr);

            roughES.office4.visible = false;

            roughES.office5.visible = false;

            roughES.office6.visible = true;

            roughES.office7.visible = true;
        }

        if (step == 1558.0)
        {
            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("check", true);
        }

        if (step == 1567.0)
        {
            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("unlockLoopBack", true);
        }

        if (step == 1574.0)
        {
            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("check", true);
        }

        if (step == 1583.0)
        {
            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("unlockLoopBack", true);
        }

        if (step == 1590.0)
        {
            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("checkScare", true);
        }

        if (step == 1599.0)
        {
            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("unlockScareLoopBack", true);
        }

        if (step == 1608.0)
        {
            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.animation.play("slap");

            opp.x = 1680.0;

            tween.tween(opp, {x: opp.x - 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("unlock", true);

            roughES.remove(opponents, true);

            roughES.insert(roughES.members.indexOf(roughES.office7), opponents);
        }

        if (step == 1612.0)
        {
            var plr:Character = getPlayer("bf-anim-unlock");

            plr.animation.play("unlock", true);
        }

        if (step == 1616.0)
        {
            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.visible = true;

            opp.animation.play("slap");

            opp.scale.set(1.75, 1.75);

            opp.setPosition(400.0, 155.0);

            tween.tween(opp.scale, {x: 2.5, y: 2.5}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

            var plr:Character = getPlayer("bf-anim-unlock");

            plr.visible = false;

            roughES.remove(opponents, true);

            roughES.add(opponents);

            roughES.office6.visible = false;

            roughES.office7.visible = false;

            roughES.officeHall0.visible = true;
        }

        if (step == 1624.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = true;

            plr.animation.timeScale = 1.15;

            plr.animation.play("window3", true);

            plr.scale.set(3.0, 3.0);

            plr.setPosition(790.0, -40.0);

            tween.tween(plr, {x: 590.0}, conductor.beatLength * 0.5 * 0.001);

            roughES.remove(players, true);

            roughES.insert(roughES.members.indexOf(roughES.officeHall3), players);

            roughES.officeHall0.visible = false;

            roughES.officeHall1.visible = true;

            roughES.officeHall2.visible = true;

            roughES.officeHall3.visible = true;
        }

        if (step == 1632.0)
        {
            gameCameraZoom = 1.0;

            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = false;

            var opp:Character = getOpponent("baldi-mad-face-front");
            
            opp.scale.set(1.4, 1.4);

            opp.setPosition(390.0, 135.0);

            oppStrumline.strums.x = (FlxG.width - oppStrumline.strums.width) * 0.5;

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
            
            oppStrumline.downscroll = !oppStrumline.downscroll;

            tween.tween(oppStrumline.strums, {y: oppStrumline.downscroll ? FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, 
                conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tween.tween(oppStrumline.strums, {alpha: 0.35}, conductor.beatLength * 0.001);

            plrStrumline.visible = true;

            playField.visible = true;

            if (!Options.botplay)
                plrStrumline.getKeys();

            roughES.remove(players, true);

            roughES.add(players);

            roughES.hall5.visible = true;

            roughES.officeHall1.visible = false;

            roughES.officeHall2.visible = false;

            roughES.officeHall3.visible = false;

            tween.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFF7F7F,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1888.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            gameCameraZoom = 0.8;

            playField.visible = false;

            plrStrumline.clearKeys();

            plrStrumline.resetStrums();

            roughES.hall5.visible = false;

            roughES.cafeteriaHall0.visible = true;
        }

        if (step == 1892.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = true;

            plr.animation.play("window3", true);

            plr.scale.set(2.35, 2.35);

            plr.setPosition(640.0, -125.0);

            tween.tween(plr, {x: 540.0}, conductor.beatLength * 0.5 * 0.001);

            roughES.remove(players, true);

            roughES.insert(roughES.members.indexOf(roughES.cafeteriaHall3), players);

            roughES.cafeteriaHall0.visible = false;
            
            roughES.cafeteriaHall1.visible = true;

            roughES.cafeteriaHall2.visible = true;

            roughES.cafeteriaHall3.visible = true;
        }

        if (step == 1902.0)
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.5 * 0.001, false, null, true);

        if (step == 1904.0)
        {
            gameCameraZoom = 0.7;

            hudCamera.stopFade();

            var opponent:Character = getOpponent("baldi-mad-face-front");

            opponent.scale.set(1.95, 1.95);

            opponent.setPosition(765.0, 165.0);

            tween.tween(opponent, {x: opponent.x - 275.0}, conductor.beatLength * 0.275 * 0.001);

            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-anim-lock"));

            _plr.skipDance = true;

            _plr.skipSing = true;

            _plr.animation.play("lock", true);

            _plr.animation.pause();

            _plr.setPosition(600.0, 200.0);

            players.add(_plr);

            roughES.remove(opponents, true);

            roughES.insert(roughES.members.indexOf(roughES.cafeteria1), opponents);

            roughES.remove(players, true);

            roughES.add(players);

            roughES.cafeteriaHall1.visible = false;

            roughES.cafeteriaHall2.visible = false;

            roughES.cafeteriaHall3.visible = false;

            roughES.cafeteria0.visible = true;

            roughES.cafeteria1.visible = true;
        }

        if (step == 1906.0)
        {
            var plr:Character = getPlayer("bf-anim-lock");
            
            plr.animation.resume();
        }

        if (step == 1908.0)
        {
            roughES.cafeteria1.visible = false;

            roughES.cafeteria2.visible = true;
        }

        if (step == 1912.0)
        {
            var plr:Character = getPlayer("bf-anim-lock");

            plr.animation.play("check", true);
        }

        if (step == 1916.0)
        {
            var opp:Character = getOpponent("baldi-mad-face-front");

            tween.tween(opp, {x: opp.x + 275.0}, conductor.beatLength * 0.275 * 0.001);
        }

        if (step == 1920.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            roughES.cafeteria0.visible = false;
            roughES.cafeteria2.visible = false;
            roughES.cafeteria3.visible = true;
            
            var _plr:Character = getPlayer("bf-anim-lock");
            _plr.visible = false;

            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("playtime"));
            opp.setPosition(-1100, 220.0);
            opp.scale.set(1, 1);
            opponents.add(opp);

            opponent = opp;
            
            updateHealthBar("opponent");

            tween.tween(opp, {x: -200}, 1, {ease: FlxEase.quartOut});

            roughES.remove(opponents, true);
            roughES.add(opponents);

            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            oppStrumline.downscroll = !oppStrumline.downscroll;

            oppStrumline.strums.setPosition(45.0, oppStrumline.downscroll ? 
                FlxG.height - oppStrumline.strums.height - 15.0 : 15.0);

            oppStrumline.strums.alpha = 1.0;

            plrStrumline.strums.x = FlxG.width - plrStrumline.strums.width - 45.0;

            playField.visible = true;

            if (!Options.botplay)
                plrStrumline.getKeys();
        
            var plr:Character = getPlayer("bf-face-left");
            plr.setPosition(785.0, 170.0);
            plr.visible = true;
        }

        if (step == 2048)
        {
            gameCameraZoom = 1;
        }
        
        if (step == 2052.0)
        {
            roughES.cafeteria3.visible = false;
            roughES.cafeteria4.visible = true;
        
            tween.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFD7312E,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }
    
        if (step == 2056)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
            gameCameraZoom = 0.6;
        }
    
        if (step == 2160)
        {
            var opp:Character = getOpponent("baldi-mad");
            opp.visible = true;
            opp.setPosition(-800, 0);
            opp.skipSing = true;
        }
    
        if (step == 2168)
        {
            var opp:Character = getOpponent("baldi-mad");
            opp.skipSing = false;
        }

        if (step == 2176)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("gotta-sweep"));
            opp.setPosition(1750, -100);
            opp.skipSing = true;
            opponents.add(opp);
            
            var plr:Character = getPlayer("bf-face-left");

            tween.tween(opp, {x: plr.x -50}, 0.5,                
                {
                    startDelay: 0.5,
                    ease: FlxEase.quartOut,
                    onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: 1750}, 0.5, {ease: FlxEase.quartIn});}
                });
                
            tween.tween(plr, {x: 1750}, 0.5,
                {
                    startDelay: 1,
                    ease: FlxEase.quartIn
                });
        }

        if (step == 2176)
        {
            var opp:Character = getOpponent("baldi-mad");
            opp.skipSing = true;
        }
        
        if (step == 2184)
        {
            var opp:Character = getOpponent("playtime");
            tween.tween(opp, {x: -1100}, 2, 
                {
                    ease: FlxEase.quartIn
                });

            opp.skipDance = true;
            opp.animation.play("sad");
        }
        
        if (step == 2192)
        {
            tween.tween(gameCamera, {alpha: 0}, 1);
            tween.tween(this, {gameCameraZoom: 1}, 1);
        }
        
        if (step == 2208)
        {
            gameCamera.alpha = 1;
            gameCameraZoom = 0.6;

            roughES.cafeteria4.visible = false;
            roughES.hall2.visible = true;
            roughES.hall2.velocity.set(-10560.0, 0.0);

            var opp:Character = getOpponent("playtime");
            opp.visible = false;

            var opp:Character = getOpponent("baldi-mad");
            opp.visible = false;

            var opp:Character = getOpponent("gotta-sweep");
            opp.setPosition(-1000, -100);
            opp.skipSing = false;

            opponent = opp;

            updateHealthBar("opponent");
            
            var plr:Character = getPlayer("bf-face-left");
            plr.setPosition(-1000.0, 170.0);

            tween.tween(opp, {x: 100}, 1,                 
                {
                    ease: FlxEase.backOut
                });
        
            tween.tween(plr, {x: 300}, 1,                 
                {
                    ease: FlxEase.backOut
                });
        }
    
        if (step == 2232)
        {
            gameCameraZoom = 1;
        }
    
        if (step == 2240)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
            gameCameraZoom = 0.6;
        }

        if (step == 2494)
        {
            roughES.facultyStandard.visible = true;
            roughES.facultyStandard.velocity.x = -2560.0;
            roughES.facultyStandard.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 2496)
        {
            gameCameraZoom = 1;

            roughES.hall2.velocity.set(0.0, 0.0);
        
            roughES.facultyStandard.velocity.x = 0.0;

            var plr:Character = getPlayer("bf-face-left");

            var opp:Character = getOpponent("gotta-sweep");

            tween.tween(opp, {x: -1500}, 0.75,                 
                {
                    ease: FlxEase.backIn,
                    onComplete: (_tween:FlxTween) -> {opp.visible = false;}
                });
        
            tween.tween(plr, {x: plr.x + 100}, 0.5);
        }
    
        if (step == 2512)
        {
            gameCameraZoom = 0.75;
            
            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 + 300.0,
                (FlxG.height - cameraPoint.height) * 0.5 + 0.0, -1.0);

            if (Options.shaders)
            {
                pxChunks = new PixelChunks();

                pxChunks.data.tileSize.value = [0.0];

                pxContainer = new ShaderFilter(pxChunks);

                gameCamera.filters ??= new Array<BitmapFilter>();

                gameCamera.filters.push(pxContainer);
            }
            
            var _opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-anim-coming"));
            _opp.skipDance = true;
            _opp.animation.play("coming");
            _opp.setPosition(950, -150);
            opponents.add(_opp);
            
            roughES.remove(opponents, true);
            roughES.insert(roughES.members.indexOf(players), opponents);

            opponent = _opp;

            updateHealthBar("opponent");

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 2528)
        {
            var _opp:Character = getOpponent("1st-prize-anim-coming");
            _opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-292-5"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }
        
        if (step == 2544)
        {
            var _opp:Character = getOpponent("1st-prize-292-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-315"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }
        
        if (step == 2560)
        {
            var _opp:Character = getOpponent("1st-prize-315");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-337-5"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }

        if (step == 2576)
        {
            var _opp:Character = getOpponent("1st-prize-337-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-0"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }
        
        if (step == 2592)
        {
            var _opp:Character = getOpponent("1st-prize-0");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-22-5"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }

        if (step == 2608)
        {
            var _opp:Character = getOpponent("1st-prize-22-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-45"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }
       
        if (step == 2624)
        {
            var _opp:Character = getOpponent("1st-prize-45");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-67-5"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }

        if (step == 2640)
        {
            var _opp:Character = getOpponent("1st-prize-67-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("1st-prize-90"));
            opp.setPosition(950, -150);
            opponents.add(opp);
        }

        if (Options.shaders)
        {
            if (step >= 2640.0 && step <= 2656.0)
            {
                if (step == 2648.0 || step == 2650.0)
                    tween.num(5.0, 0.0, conductor.beatLength * 0.5 * 0.001, {}, (num:Float) -> pxChunks.data.tileSize.value[0] = num);

                if (step == 2652.0 || step == 2653.0 || step == 2654.0 || step == 2655.0 || step == 2656.0)
                    tween.num(10.0, 0.0, conductor.stepLength * 0.001, {}, (num:Float) -> pxChunks.data.tileSize.value[0] = num);
            }
        }

        if (step == 2648)
            {
                var plr:Character = getPlayer("bf-face-left");
                var opp:Character = getOpponent("1st-prize-90");
                
                tween.tween(opp, {x: -1450}, 1,            
                    {
                        ease: FlxEase.quartIn,
                    });
                    
                tween.tween(plr, {x: -1300}, 0.75,            
                    {
                        startDelay: 0.65,
                        ease: FlxEase.quadOut,
                    });
            }
            
        if (step == 2656)
        {
            if (Options.shaders)
                gameCamera.filters.resize(0);

            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, -1.0);

            gameCamera.snapToTarget();
           
            gameCameraZoom = 0.7;
            roughES.hall2.velocity.set(5560.0, 0.0);
            roughES.facultyStandard.velocity.x = 5560.0;
        }
    
        if (step == 2660)
        {
            var plr:Character = getPlayer("bf-face-left");
            var opp:Character = getOpponent("1st-prize-90");

            tween.tween(opp, {x: 300}, 1, {ease: FlxEase.quartOut});
            
            tween.tween(plr, {x: 150}, 1, {ease: FlxEase.quartOut, onComplete: (_tween:FlxTween) -> {roughES.hall2.velocity.set(2560.0, 0.0);}});

        }
   
        if (step == 2768)
        {
            craftersSprite1 = new FlxSprite(0.0, 0.0, Assets.getGraphic("shared/craftersSprite1"));
            craftersSprite1.scale.set(1.35, 1.35);
            craftersSprite1.updateHitbox();
            craftersSprite1.setPosition(-1500, 100);
            roughES.add(craftersSprite1);

            tween.tween(craftersSprite1, {x: 50}, 0.5,                
                {
                    onComplete: (_tween:FlxTween) ->  
                    {
                        tween.tween(craftersSprite1, {x: 700}, timeInterval, 
                            {
                                ease: FlxEase.quadInOut, 
                                type: PINGPONG,
                                onComplete: (_tween:FlxTween) -> {_tween.duration = timeInterval; craftersLayerUpdate();}
                            });
                    
                        tween.tween(craftersSprite1.scale, {x: 1.7, y: 1.7}, timeInterval / 2, 
                            {
                                ease: FlxEase.smootherStepOut, 
                                type: PINGPONG,
                                loopDelay: timeInterval / 2,
                                onComplete: (_tween:FlxTween) -> {_tween.loopDelay = timeInterval * 0.5; _tween.duration = timeInterval * 0.5;}
                            });
                    }
                });
        }

        if (step == 2784)
        {
            tween.tween(this, {gameCameraZoom: 2}, conductor.beatLength * 8.0 * 0.001,
                {
                    ease: FlxEase.quartIn
                });

            if (Options.shaders)
            {
                var blur:BlurFilter = new BlurFilter(0.0, 0.0, 1);

                gameCamera.filters.push(blur);

                tween.tween(blur, {blurX: 15.0, blurY: 15.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});
            }
        }
        
        if (step == 2816)
        {
            tween.cancelTweensOf(this, ["gameCameraZoom"]);

            if (Options.shaders)
                gameCamera.filters.resize(0);

            remove(craftersSprite1, true);
            gameCameraZoom = 0.9;
            hudCamera.visible = false;

            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 + 200.0,
                (FlxG.height - cameraPoint.height) * 0.5 + 0.0, -1.0);

            gameCamera.snapToTarget();

            var plr:Character = getPlayer("bf-face-left");
            plr.visible = false;

            var opp:Character = getOpponent("1st-prize-90");
            opp.visible = false;
           
            roughES.hall2.visible = false;
            roughES.hall6.visible = true;
            roughES.hall7.visible = true;

            craftersSprite1.visible = false;
            tween.cancelTweensOf(craftersSprite1);

            var _plr:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bf-anim-teleported"));
            _plr.skipDance = true;
            _plr.skipSing = true;
            _plr.setPosition(550, 100);
            _plr.animation.play("shock");
            players.add(_plr);
       
            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.scale.set(0.7, 0.7);
            opp.updateHitbox();
            opp.setPosition(1100, 280);
            opp.visible = true;
            opp.animation.play("slap");
            tween.tween(opp, {x: opp.x + 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

            roughES.remove(opponents, true);
            roughES.insert(roughES.members.indexOf(roughES.hall7), opponents);
        }

        if (step == 2824)
        {
            var _plr:Character = getPlayer("bf-anim-teleported");
            _plr.animation.play("turn");
            
            gameCameraZoom = 1;
        }
        
        if (step == 2832)
        {
            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, -1.0);

            gameCamera.snapToTarget();

            gameCameraZoom = 0.75;

            hudCamera.visible = true;
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
        
            var _plr:Character = getPlayer("bf-anim-teleported");
            _plr.visible = false;
            
            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("baldi-furious"));
            opp.setPosition(-885.0, 18.5);
            opp.skipDance = true;
            opponents.add(opp);

            var plr:Character = getPlayer("bf-running");
            plr.visible = true;
            plr.setPosition(798.5, 205.5);

            var _plr:Character = getPlayer("run-legs");
            _plr.visible = true;
            _plr.setPosition(plr.x, plr.y);

            opponent = opp;

            updateHealthBar("opponent");

            roughES.hall6.visible = false;
            roughES.hall7.visible = false;
            roughES.hall2.visible = true;
            roughES.hall2.velocity.set(-2560.0, 0.0);

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 3218.0)
        {
            var opp:Character = getOpponent("baldi-furious");

            opp.animation.play("slap", true);

            tween.tween(opp, {x: opp.x + 325.0}, conductor.beatLength * 0.25 * 0.001,
                {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x + 725.0},
                    conductor.beatLength * 0.25 * 0.001, {ease: FlxEase.quadOut});}});
        }

        if (step == 3219.0)
        {
            var opp:Character = getOpponent("baldi-furious");

            opp.animation.play("slap", true);
        }

        if (step == 3220.0)
        {
            var opp:Character = getOpponent("baldi-furious");

            tween.completeTweensOf(opp);

            tween.tween(opp, {x: opp.x - 1050.0}, conductor.beatLength * 0.001, {ease: FlxEase.quadIn});
        }
    
        if (step == 3344)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
            gameCameraZoom = 0.9;
        
            playField.scoreClip.visible = playField.scoreTxt.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
        }
        
        if (step == 3464)
        {
            gameCameraZoom = 0.75;
            
            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, -1.0);

            gameCamera.snapToTarget();
        }
       
        if (step == 3469)
        {
            roughES.exit1.visible = true;
            roughES.exit1.velocity.x = -2560.0;
            roughES.exit1.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 3472)
        {
            gameCamera.color =  FlxColor.WHITE;
            if (Options.flashing)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
            oppStrumline.visible = false;
            plrStrumline.visible = false;

            roughES.hall2.visible = false;
            roughES.exit1.visible = false;
            roughES.baldiOffice.visible = true;

            gameCameraZoom = 1.0;
            
            tween.tween(this, {gameCameraZoom: 0.8}, 3.5, {ease:FlxEase.quartIn});
            tween.tween(gameCamera, {alpha: 0}, 3.5);
        
            var plr:Character = getPlayer("bf-running");
            plr.visible = false;
            
            var _plr:Character = getPlayer("run-legs");
            _plr.visible = false;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 36.0 && beat <= 132.0 || beat >= 248.0 && beat < 316.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                if (beat == 132.0)
                {
                    tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 725.0}, 0.35);}});
                }
                else
                {
                    tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.35 * 0.001,
                        {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 725.0}, 0.5);}});
                }

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 180.0 && beat < 212.0 || beat >= 440.0 && beat < 442.0)
        {
            for (i in 0 ... FlxG.cameras.list.length)
            {
                var camera:FlxCamera = FlxG.cameras.list[i];

                camera.angle = beat % 2.0 == 0.0 ? -1.5 : 1.5;

                tween.tween(camera, {angle: 0.0}, conductor.beatLength * 0.85 * 0.001, {ease:FlxEase.quartOut});
            }
        }

        if (beat >= 216.0 && beat <= 218.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad-face-front");

                tween.tween(opp.scale, {x: opp.scale.x + 0.3, y: opp.scale.y + 0.3}, conductor.beatLength * 0.275 * 0.001);

                tween.tween(opp, {x: opp.x + 30.0}, conductor.beatLength * 0.275 * 0.001);

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 220.0 && beat < 248.0 || beat >= 408.0 && beat < 472.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad-face-front");

                if (beat == 440.0)
                {
                    tween.tween(opp.scale, {x: 2.5, y: 2.5}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp.scale, {x: 0.9,
                            y: 0.9}, 0.85);}});

                    tween.tween(opp, {y: 150.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, 
                            {y: 125.0}, 0.85);}});
                }
                else
                {
                    tween.tween(opp.scale, {x: 2.0, y: 2.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp.scale, {x: 0.9,
                            y: 0.9}, 0.85);}});

                    tween.tween(opp, {y: 150.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, 
                            {y: 125.0}, 0.85);}});
                }
                
                opp.animation.play("slap", true);
            }
        }

        if (beat >= 372.0 && beat <= 388.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad-face-front");

                tween.tween(opp.scale, {x: opp.scale.x + 0.2, y: opp.scale.y + 0.2},
                    conductor.beatLength * 0.275 * 0.001);
                
                tween.tween(opp, {x: beat == 388.0 ? opp.x - 365.0 : opp.x + 1.0 * opp.scale.x}, conductor.beatLength * 0.275 * 0.001);

                tween.tween(opp, {y: opp.y + 5.0}, conductor.beatLength * 0.275 * 0.001);

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 472.0 && beat < 476.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad-face-front");

                tween.tween(opp.scale, {x: opp.scale.x + 0.325, y: opp.scale.y + 0.325}, 
                    conductor.beatLength * 0.275 * 0.001);

                tween.tween(opp, {y: opp.y + 5.0}, conductor.beatLength * 0.275 * 0.001);

                opp.animation.play("slap", true);
            }
        }
    
        if (beat >= 540.0 && beat <= 552.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad");
                
                tween.tween(opp, {x: opp.x + 300.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

                opp.animation.play("slap", true);
            }
        }

        if (Options.shaders)
        {
            if (beat >= 628 && beat <= 660.0)
            {
                if (beat % 2.0 == 1.0)
                    tween.num(5.0, 0.0, conductor.beatLength * 0.001, {}, (num:Float) -> pxChunks.data.tileSize.value[0] = num);
            }
        }
    
        if (beat >= 708.0 && beat < 804.0 || beat >= 806.0 && beat < 868.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-furious");

                tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.275 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 725.0}, 0.35);}});

                opp.animation.play("slap", true);
            }
        }

        if (beat == 772.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.fromRGB(255, 125, 125), conductor.beatLength * 2.0 * 0.001, null, true);

            vignette = new FlxSprite(0.0, 0.0, Assets.getGraphic("shared/vigenette"));
            vignette.scale.set(2.7, 2.7);
            vignette.camera = hudCamera;
            vignette.screenCenter();
            vignette.alpha = 0.0;
            insert(0, vignette);
            tween.tween(vignette, {alpha: 0.5}, 0.5);
        }

        if (beat == 776.0)
        {
            if (Options.flashing)
                hudCamera.flash(FlxColor.fromRGB(255, 125, 125), conductor.beatLength * 2.0 * 0.001, null, true);
            tween.tween(vignette, {alpha: 0.3}, 0.5);
        }

        if (beat == 805.0)
        {
            tween.color(temperature, conductor.beatLength * 12.0 * 0.001, temperature.color, 0xFFFF0000,
                    {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
            tween.tween(vignette, {alpha: 0.6}, 0.5);
        }

        if (beat == 836.0)
        {
            tween.tween(vignette, {alpha: 1}, 0.5);
        }
    
        if (beat == 836.0 || beat == 852.0)
        {
            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 - 140.0,
                (FlxG.height - cameraPoint.height) * 0.5 + 0.0, -1.0);
        }
    
        if (beat == 844.0 || beat == 860.0)
        {
            FocusCamPointEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 + 300.0,
                (FlxG.height - cameraPoint.height) * 0.5 + 0.0, -1.0);
        }

        if (beat == 868.0)
        {
            vignette.destroy();
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

    public function craftersLayerUpdate():Void
    {
        if (timeInterval > 0.3)
        {
            timeInterval = timeInterval - 0.15;
        }

        if (checkLayer == true)
        {
            checkLayer = false;        
            roughES.remove(craftersSprite1, true);
            roughES.insert(roughES.members.indexOf(players), craftersSprite1);
        }else
        {
            checkLayer = true;

            roughES.remove(craftersSprite1, true);
            roughES.add(craftersSprite1);
        }
    }
}