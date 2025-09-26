package game.levels.classicw.diff_hard;

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

import core.AssetCache;
import core.Options;
import core.Paths;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.diff_hard.RoughES;

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

    public var principal:FlxSprite;

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

        cameraLock = FOCUS_CAM_POINT;

        gameCameraZoom = 1.15;

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
            playField.timerNeedle.visible = false;

        playField.strumlines.visible = false;

        plrStrumline.botplay = true;

        AssetCache.getGraphic("game/Character/1st-prize-anim-coming");

        AssetCache.getGraphic("game/Character/1st-prize-0");

        AssetCache.getGraphic("game/Character/baldi-mad");

        AssetCache.getGraphic("game/Character/baldi-mad-face-front");

        AssetCache.getGraphic("game/Character/baldi-furious");

        AssetCache.getGraphic("game/Character/bf-face-left");

        AssetCache.getGraphic("game/Character/bf-running");

        AssetCache.getGraphic("game/Character/bf-clutching-wall");

        AssetCache.getGraphic("game/Character/bully");

        AssetCache.getGraphic("game/Character/gotta-sweep");

        AssetCache.getGraphic("game/Character/playtime");

        AssetCache.getGraphic("game/Character/principal");

        AssetCache.getGraphic("game/Character/run-legs");

        AssetCache.getGraphic("game/stages/shared/scrolling-hall3");

        AssetCache.getGraphic("game/stages/shared/scrolling-hall4");

        temperature = new FlxSprite();
    
        checkLayer = true;
        timeInterval = 0.75;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0.0)
        {
            tweens.tween(gameCamera, {alpha: 1.0}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            tweens.tween(this, {gameCameraZoom: 0.75}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            opponents.visible = false;

            players.visible = false;
        }
        
        if (step == 136.0)
        {
            roughES.hall0.visible = false;

            roughES.hall1.visible = true;

            players.visible = true;

            var plr:Character = getPlayer("bf-face-left");

            plr.color = 0xC7BEA7;

            plr.skipDance = true;

            plr.animation.play("ay");

            plr.animation.onFinish.addOnce((name:String) -> plr.skipDance = false);

            plr.setPosition(785.0, 170.0);
        }

        if (step == 144.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            roughES.hall1.visible = false;

            roughES.hall2.visible = true;

            opponents.visible = true;

            var opp:Character = getOpponent("baldi-mad");

            opp.skipDance = true;

            opp.setPosition(-845.0, 18.5);

            opp.color = 0xC2B499;

            var plr:Character = getPlayer("bf-face-left");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-running"));

            var anim:FlxAnimation = _plr.animation.getByName("dance");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            _plr.setPosition(798.5, 205.5);

            _plr.color = 0xC7BEA7;

            players.add(_plr);

            var __plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("run-legs"));

            anim = __plr.animation.getByName("legs");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            anim = __plr.animation.getByName("legs miss");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            __plr.animation.play("legs", true);

            __plr.skipDance = true;

            __plr.skipSing = true;

            __plr.color = 0xC7BEA7;

            __plr.setPosition(_plr.x, _plr.y);

            players.insert(players.members.indexOf(_plr), __plr);

            _plr.animation.onFrameChange.add(updateLegStatus);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = true;

            playField.strumlines.visible = true;

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 464.0)
        {
            tweens.color(temperature, conductor.beatLength * 16.0 * 0.001, temperature.color, 0xFFFFD8D8,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 512.0)
        {
            var plr:Character = getPlayer("bf-running");

            var _plr:Character = getPlayer("run-legs");

            tweens.tween(plr, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.sineIn, 
                onUpdate: (tweens:FlxTween) -> {_plr.x = plr.x;}});

            tweens.tween(plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.sineIn});

            tweens.tween(_plr.animation, {timeScale: 1.25}, conductor.beatLength * 4.0 * 0.001 * 0.001, {ease: FlxEase.sineIn});
        }

        if (step == 524.0)
        {
            var plr:Character = getPlayer("bf-running");

            var sodaSplash:FlxSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/sodaSplash"));

            sodaSplash.scale.set(11.5, 11.5);

            sodaSplash.color = 0xD3CDAB;

            sodaSplash.updateHitbox();

            sodaSplash.setPosition(plr.getMidpoint().x - sodaSplash.width * 0.5, (FlxG.height - sodaSplash.height) * 0.5);

            roughES.insert(roughES.members.indexOf(players), sodaSplash);

            tweens.tween(sodaSplash, {x: -855.0}, conductor.beatLength * 2.15 * 0.001, {onComplete: (_tween:FlxTween) ->
                {sodaSplash.active = sodaSplash.visible = false;}});
        }

        if (step == 528.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

            tweens.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});
        }

        if (step == 580.0)
        {
            var plr:Character = getPlayer("bf-running");

            SetCamFocusEvent.dispatch(this, plr.getMidpoint().x - cameraPoint.width * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, null, conductor.beatLength * 2.5 * 0.001, "quartInOut");

            var _plr:Character = getPlayer("run-legs");

            tweens.tween(roughES.hall2, {x: roughES.hall2.getCenterX(plr)}, conductor.beatLength * 2.5 * 0.001,
                {ease: FlxEase.quartInOut});

            tweens.tween(plr.animation, {timeScale: 1.0}, conductor.beatLength * 2.5 * 0.001, {ease: FlxEase.sineOut});

            tweens.tween(_plr.animation, {timeScale: 1.0}, conductor.beatLength * 2.5 * 0.001, {ease: FlxEase.sineOut});
        }

        if (step == 590.0)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bully"));

            opp.flipX = true;

            opp.color = 0xCCC0A9;

            opp.setPosition(2285.0, -555.0);

            opponents.add(opp);

            tweens.tween(opp, {x: 1885.0}, conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 592.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);

            gameCamera.snapToTarget();

            roughES.hall2.visible = false;

            roughES.hall2.x = roughES.hall2.getCenterX();

            roughES.hall3.visible = true;

            var opp:Character = getOpponent("baldi-mad");

            opp.visible = false;

            var _opp:Character = getOpponent("bully");

            _opp.flipX = false;

            tweens.cancelTweensOf(_opp);

            opp.color = 0xCCC0A9;

            _opp.setPosition(-685.0, -555.0);

            opponent = _opp;

            updateHealthBar("opponent");

            var plr:Character = getPlayer("bf-running");

            plr.visible = false;

            var _plr:Character = getPlayer("run-legs");

            _plr.visible = false;

            var __plr:Character = getPlayer("bf-face-left");

            __plr.visible = true;

            tweens.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);

            plrStrumline.strums.x = FlxG.width - plrStrumline.strums.width - 45.0;
        }

        if (step == 720.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 848.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = getOpponent("bully");

            opp.skipDance = true;

            opp.animation.play("spin");

            tweens.tween(opp, {y: -opp.height / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.backIn});

            tweens.tween(opp, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001);

            tweens.tween(opp.animation, {timeScale: 2.5}, conductor.beatLength * 4.0 * 0.001,
                {ease: FlxEase.backIn});

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

            tweens.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});
        }

        if (step == 864.0)
        {
            gameCameraZoom = 1.0;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad-face-front"));

            opp.skipDance = true;

            opp.color = 0x8A7D65;

            opp.scale.set(0.8, 0.8);

            opp.setPosition(140.0, 120.0);

            opponents.add(opp);

            var plr:Character = getPlayer("bf-face-left");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-clutching-wall"));

            _plr.setPosition(-280.0, 125.0);

            _plr.color = 0xC7BEA7;

            players.add(_plr);

            opponent = opp;

            updateHealthBar("opponent");

            oppStrumline.strums.x = (FlxG.width - oppStrumline.strums.width) * 0.5;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
            
            oppStrumline.strums.alpha = 1.0;

            plrStrumline.visible = false;

            roughES.hall3.visible = false;

            roughES.hall4.visible = true;

            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFFBFBF,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 872)
            opponent.color = 0xAA9C82;

        if (step == 878.0)
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.5 * 0.001);

        if (step == 880.0)
        {
            hudCamera.fade(FlxColor.WHITE, conductor.beatLength * 0.001, true, null, true);

            var plr:Character = getPlayer("bf-clutching-wall");

            plr.visible = false;

            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.setPosition(390.0, 135.0);

            opp.color = 0xC2B59D;

            oppStrumline.downscroll = !oppStrumline.downscroll;

            tweens.tween(oppStrumline.strums, {y: oppStrumline.downscroll ? FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, 
                conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(oppStrumline.strums, {alpha: 0.35}, conductor.beatLength * 0.001);

            plrStrumline.visible = true;

            roughES.hall4.visible = false;

            roughES.hall5.visible = true;

            var anim:FlxAnimation = roughES.hall5.animation.getByName("0");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.5 * 0.001);
        }

        if (step == 992.0)
        {
            gameCameraZoom = 0.75;

            if (Options.flashingLights)
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

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            oppStrumline.downscroll = !oppStrumline.downscroll;

            tweens.tween(oppStrumline.strums, {x: 45.0, y: oppStrumline.downscroll ? 
                FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, conductor.beatLength * 0.001,
                    {ease: FlxEase.quartOut});

            tweens.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);

            tweens.tween(plrStrumline.strums, {x: FlxG.width - plrStrumline.strums.width - 45.0}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});

            roughES.hall2.visible = true;

            roughES.hall5.visible = false;

            roughES.exit0.visible = true;

            roughES.exit0.velocity.x = -2560.0;

            roughES.exit0.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 1240.0)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("principal"));

            opp.setPosition(-862.5, 22.5);

            opp.color = 0xC4B7A0;

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

            tweens.tween(opp, {x: plr.x - 115.0}, conductor.beatLength * 2.0 * 0.001);
        }

        if (step == 1264.0)
        {
            gameCameraZoom = 0.75;

            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 - 225.0,
                (FlxG.height - cameraPoint.height) * 0.5 + 50.0, null, 0.0);

            gameCamera.snapToTarget();

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            
            var opp:Character = getOpponent("baldi-mad");

            opp.visible = false;

            var _opp:Character = getOpponent("principal");

            _opp.scale.set(1.4, 1.4);

            tweens.cancelTweensOf(_opp);

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

            new FlxTimer(timers).start(1.0, (_timer:FlxTimer) ->
            {
                if (_timer.loopsLeft == 0.0)
                    timerText.active = timerText.visible = false;

                timerText.text = 'You get detention!\n${_timer.loopsLeft} seconds remain!';

                timerText.screenCenter();
            }, 45);

            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFFA5A5,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1456.0)
        {
            var opp:Character = getOpponent("principal");
            opp.visible = false;

            principal = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/principal"));
            principal.scale.set(1.65, 1.65);
            principal.updateHitbox();
            principal.setPosition(-180.0, 110.0);
            principal.color = 0xC4B7A0;
            roughES.insert(roughES.members.indexOf(players), principal);

            tweens.tween(principal, {x: 215.0, y: 20.0}, conductor.beatLength * 2.25 * 0.001, {ease: FlxEase.quadIn});

            tweens.tween(principal.scale, {x: 0.65, y: 0.65}, conductor.beatLength * 2.25 * 0.001, {ease: FlxEase.quadIn});

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 0.001);

            tweens.tween(plrStrumline.strums, {x: (FlxG.width - plrStrumline.strums.width) * 0.5}, conductor.beatLength * 0.001, 
                {ease: FlxEase.quartOut});
        }

        if (step == 1465.0)
        {
            roughES.remove(principal, true);

            roughES.insert(roughES.members.indexOf(roughES.office2), principal);
            
            if (FlxG.random.bool())
                tweens.tween(principal, {x: -principal.width / 0.75}, conductor.beatLength * 2.0 * 0.001);
            else
                tweens.tween(principal, {x: FlxG.width / 0.75}, conductor.beatLength * 4.0 * 0.001);

            roughES.office0.visible = false;

            roughES.office1.visible = true;

            roughES.office2.visible = true;
        }

        if (step == 1488.0)
        {
            gameCameraZoom = 0.6;

            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);

            gameCamera.snapToTarget();

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            principal.visible = false;

            var opp:Character = getOpponent("baldi-mad-face-front");

            opp.visible = true;

            opp.scale.set(0.25, 0.25);

            opp.color = 0x000000;

            opp.setPosition(385.0, 110.0);

            roughES.remove(opponents, true);

            roughES.insert(roughES.members.indexOf(roughES.office4), opponents);

            var plr:Character = getPlayer("bf-face-left");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-anim-window"));

            _plr.skipDance = true;

            _plr.skipSing = true;

            _plr.animation.play("window1", true);

            _plr.setPosition(500.0, 0.0);

            _plr.color = 0xC7BEA7;

            players.add(_plr);

            opponent = opp;

            updateHealthBar("opponent");

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = false;

            playField.strumlines.visible = false;

            plrStrumline.botplay = true;

            plrStrumline.resetStrums();

            roughES.office1.visible = false;

            roughES.office2.visible = false;

            roughES.office3.visible = true;

            roughES.office4.visible = true;

            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFF8C8C,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1496.0)
        {
            roughES.office3.visible = false;

            roughES.office5.visible = true;

            opponent.color = 0x14120B;
        }

        if (step == 1504.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window2", true);

            opponent.color = 0x2B2619;
        }

        if (step == 1520.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window3", true);

            opponent.color = 0x4B432F;
        }

        if (step == 1536.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window4", true);

            opponent.color = 0x685E45;
        }

        if (step == 1544.0)
        {
            var plr:Character = getPlayer("bf-anim-window");

            plr.animation.play("window5", true);

            tweens.tween(plr, {x: gameCamera.viewLeft - plr.width}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.backIn});
        }

        if (step == 1552.0)
        {
            gameCameraZoom = 0.58;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-anim-unlock"));

            _plr.skipDance = true;

            _plr.color = 0xC7BEA7;

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

            tweens.tween(opp, {x: opp.x - 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

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

            opp.color = 0xC2B59D;

            tweens.tween(opp.scale, {x: 2.5, y: 2.5}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

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

            tweens.tween(plr, {x: 590.0}, conductor.beatLength * 0.5 * 0.001);

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

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = false;

            var opp:Character = getOpponent("baldi-mad-face-front");
            
            opp.scale.set(1.4, 1.4);

            opp.setPosition(390.0, 135.0);

            oppStrumline.strums.x = (FlxG.width - oppStrumline.strums.width) * 0.5;
            
            oppStrumline.downscroll = !oppStrumline.downscroll;

            tweens.tween(oppStrumline.strums, {y: oppStrumline.downscroll ? FlxG.height - oppStrumline.strums.height - 15.0 : 15.0}, 
                conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(oppStrumline.strums, {alpha: 0.35}, conductor.beatLength * 0.001);

            playField.strumlines.visible = true;

            plrStrumline.botplay = Options.botplay;

            roughES.remove(players, true);

            roughES.add(players);

            roughES.hall5.visible = true;

            roughES.officeHall1.visible = false;

            roughES.officeHall2.visible = false;

            roughES.officeHall3.visible = false;

            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFF7F7F,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 1888.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            gameCameraZoom = 0.8;

            playField.strumlines.visible = false;

            plrStrumline.botplay = true;

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

            tweens.tween(plr, {x: 480.0}, conductor.beatLength * 0.5 * 0.001);

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

            tweens.tween(opponent, {x: opponent.x - 275.0}, conductor.beatLength * 0.275 * 0.001);

            var plr:Character = getPlayer("bf-anim-window");

            plr.visible = false;

            var _plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-anim-lock"));

            _plr.skipDance = true;

            _plr.skipSing = true;

            _plr.color = 0xC7BEA7;

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

            tweens.tween(opp, {x: opp.x + 275.0}, conductor.beatLength * 0.275 * 0.001);
        }

        if (step == 1920.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
            roughES.cafeteria0.visible = false;
            roughES.cafeteria2.visible = false;
            roughES.cafeteria3.visible = true;
            
            var _plr:Character = getPlayer("bf-anim-lock");
            _plr.visible = false;

            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("playtime"));
            opp.color = 0xC7BDA6;
            opp.setPosition(-1100, 220.0);
            opp.scale.set(1, 1);
            opponents.add(opp);

            opponent = opp;
            
            updateHealthBar("opponent");

            tweens.tween(opp, {x: -200}, 1, {ease: FlxEase.quartOut});

            roughES.remove(opponents, true);
            roughES.add(opponents);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            oppStrumline.downscroll = !oppStrumline.downscroll;

            oppStrumline.strums.setPosition(45.0, oppStrumline.downscroll ? 
                FlxG.height - oppStrumline.strums.height - 15.0 : 15.0);

            oppStrumline.strums.alpha = 1.0;

            plrStrumline.strums.x = FlxG.width - plrStrumline.strums.width - 45.0;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = true;

            playField.strumlines.visible = true;

            plrStrumline.botplay = Options.botplay;
        
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
        
            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFE9221F,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }
    
        if (step == 2056)
        {
            if (Options.flashingLights)
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
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("gotta-sweep"));
            opp.color = 0xB4A88D;
            opp.setPosition(1750, -25);
            opp.skipSing = true;
            opponents.add(opp);
            
            var plr:Character = getPlayer("bf-face-left");

            tweens.tween(opp, {x: plr.x -50}, 0.5,                
                {
                    startDelay: 0.5,
                    ease: FlxEase.quartOut,
                    onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: 1750}, 0.5, {ease: FlxEase.quartIn});}
                });
                
            tweens.tween(plr, {x: 1750}, 0.5,
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
            tweens.tween(opp, {x: -1100}, 2, 
                {
                    ease: FlxEase.quartIn
                });

            opp.skipDance = true;
            opp.animation.play("sad");
        }
        
        if (step == 2192)
        {
            tweens.tween(gameCamera, {alpha: 0}, 1);
            tweens.tween(this, {gameCameraZoom: 1}, 1);
        }
        
        if (step == 2208)
        {
            gameCamera.alpha = 1;
            gameCameraZoom = 0.6;

            roughES.cafeteria4.visible = false;
            roughES.hall2.visible = true;

            var opp:Character = getOpponent("playtime");
            opp.visible = false;

            var opp:Character = getOpponent("baldi-mad");
            opp.visible = false;

            var opp:Character = getOpponent("gotta-sweep");
            opp.color = 0xBEB398;
            opp.setPosition(-1000, -25);
            opp.skipSing = false;

            opponent = opp;

            updateHealthBar("opponent");
            
            var plr:Character = getPlayer("bf-face-left");
            plr.visible = false;
            
            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-1200.0, 170.0);
            plr.color = 0xBEB398;
            players.add(plr);

            roughES.remove(opponents, true);
            roughES.insert(roughES.members.indexOf(players), opponents);

            tweens.tween(opp, {x: 100}, 1,                 
                {
                    ease: FlxEase.backOut
                });
        
            tweens.tween(plr, {x: 300}, 1,                 
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
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
            gameCameraZoom = 0.6;
        }

        if (step == 2494)
        {
            roughES.facultyStandard.visible = true;
            roughES.facultyStandard.velocity.x = -3119.5;
            roughES.facultyStandard.x = gameCamera.viewX + gameCamera.viewWidth;
        }

        if (step == 2496)
        {
            gameCameraZoom = 1;

            roughES.hall2.animation.pause();

            roughES.facultyStandard.velocity.x = 0.0;

            var plr:Character = getPlayer("bf-face-right");

            var opp:Character = getOpponent("gotta-sweep");

            tweens.tween(opp, {x: -1500}, 0.75,                 
                {
                    ease: FlxEase.backIn,
                    onComplete: (_tween:FlxTween) -> {opp.visible = false;}
                });
        
            tweens.tween(plr, {x: plr.x + 100}, 0.5);
        }
    
        if (step == 2512)
        {
            gameCameraZoom = 0.75;
            
            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 + 180.0,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);

            if (Options.shaders)
            {
                pxChunks = new PixelChunks();

                pxChunks.data.tileSize.value = [0.0];

                pxContainer = new ShaderFilter(pxChunks);

                gameCamera.filters.push(pxContainer);
            }
            
            var _opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-anim-coming"));
            _opp.skipDance = true;
            _opp.animation.play("coming");
            _opp.color = 0xAFA487;
            _opp.setPosition(950, -150);
            opponents.add(_opp);

            opponent = _opp;

            updateHealthBar("opponent");

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tweens.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 2528)
        {
            var _opp:Character = getOpponent("1st-prize-anim-coming");
            _opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-292-5"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }
        
        if (step == 2544)
        {
            var _opp:Character = getOpponent("1st-prize-292-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-315"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }
        
        if (step == 2560)
        {
            var _opp:Character = getOpponent("1st-prize-315");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-337-5"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }

        if (step == 2576)
        {
            var _opp:Character = getOpponent("1st-prize-337-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-0"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }
        
        if (step == 2592)
        {
            var _opp:Character = getOpponent("1st-prize-0");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-22-5"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }

        if (step == 2608)
        {
            var _opp:Character = getOpponent("1st-prize-22-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-45"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }
       
        if (step == 2624)
        {
            var _opp:Character = getOpponent("1st-prize-45");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-67-5"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }

        if (step == 2640)
        {
            var _opp:Character = getOpponent("1st-prize-67-5");
            _opp.visible = false;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("1st-prize-90"));
            opp.setPosition(950, -150);
            opp.color = 0xAFA487;
            opponents.add(opp);
        }

        if (Options.shaders)
        {
            if (step >= 2640.0 && step <= 2656.0)
            {
                if (step == 2648.0 || step == 2650.0)
                    tweens.num(5.0, 0.0, conductor.beatLength * 0.5 * 0.001, {}, (num:Float) -> pxChunks.data.tileSize.value[0] = num);

                if (step == 2652.0 || step == 2653.0 || step == 2654.0 || step == 2655.0 || step == 2656.0)
                    tweens.num(10.0, 0.0, conductor.beatLength * 0.25 * 0.001, {}, (num:Float) -> pxChunks.data.tileSize.value[0] = num);
            }
        }

        if (step == 2648)
            {
                var plr:Character = getPlayer("bf-face-right");
                var opp:Character = getOpponent("1st-prize-90");
                
                tweens.tween(opp, {x: -1450}, 1,            
                    {
                        ease: FlxEase.quartIn,
                    });
                    
                tweens.tween(plr, {x: -1350}, 0.75,            
                    {
                        startDelay: 0.65,
                        ease: FlxEase.quadOut,
                    });
            }
            
        if (step == 2656)
        {
            if (Options.shaders)
                gameCamera.filters.resize(0);

            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);

            gameCamera.snapToTarget();

            opponent.color = 0xC7BEA7;
           
            gameCameraZoom = 0.7;
            roughES.hall2.animation.play("0", false, true);
            roughES.facultyStandard.velocity.x = 5560.0;
        }
    
        if (step == 2660)
        {
            var plr:Character = getPlayer("bf-face-right");
            plr.visible = false;

            var plr:Character = getPlayer("bf-face-left");
            plr.setPosition(-1350, 170);
            plr.visible = true;

            var opp:Character = getOpponent("1st-prize-90");

            tweens.tween(opp, {x: 300}, 1, {ease: FlxEase.quartOut});
            
            tweens.tween(plr, {x: 150}, 1, {ease: FlxEase.quartOut});

        }
   
        if (step == 2768)
        {
            craftersSprite1 = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/craftersSprite1"));
            craftersSprite1.scale.set(1.35, 1.35);
            craftersSprite1.updateHitbox();
            craftersSprite1.setPosition(-1500, 100);
            craftersSprite1.color = 0xC2B8A1;
            roughES.add(craftersSprite1);

            tweens.tween(craftersSprite1, {x: 50}, 0.5,                
                {
                    onComplete: (_tween:FlxTween) ->  
                    {
                        tweens.tween(craftersSprite1, {x: 700}, timeInterval, 
                            {
                                ease: FlxEase.quadInOut, 
                                type: PINGPONG,
                                onComplete: (_tween:FlxTween) -> {_tween.duration = timeInterval; craftersLayerUpdate();}
                            });
                    
                        tweens.tween(craftersSprite1.scale, {x: 1.7, y: 1.7}, timeInterval / 2, 
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
            tweens.tween(this, {gameCameraZoom: 2}, conductor.beatLength * 8.0 * 0.001,
                {
                    ease: FlxEase.quartIn
                });

            if (Options.shaders)
            {
                var blur:BlurFilter = new BlurFilter(0.0, 0.0, 1);

                gameCamera.filters.push(blur);

                tweens.tween(blur, {blurX: 15.0, blurY: 15.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});
            }
        }
        
        if (step == 2816)
        {
            tweens.cancelTweensOf(this, ["gameCameraZoom"]);

            if (Options.shaders)
                gameCamera.filters.resize(0);

            remove(craftersSprite1, true);
            gameCameraZoom = 0.9;

             playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = false;

            playField.strumlines.visible = false;

            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 + 200.0,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);

            gameCamera.snapToTarget();

            var plr:Character = getPlayer("bf-face-left");
            plr.visible = false;

            var opp:Character = getOpponent("1st-prize-90");
            opp.visible = false;
           
            roughES.hall2.visible = false;
            roughES.hall6.visible = true;
            roughES.hall7.visible = true;

            craftersSprite1.visible = false;
            tweens.cancelTweensOf(craftersSprite1);

            var _plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-anim-teleported"));
            _plr.skipDance = true;
            _plr.skipSing = true;
            _plr.color = 0xC7BEA7;
            _plr.setPosition(550, 100);
            _plr.animation.play("shock");
            players.add(_plr);
       
            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.scale.set(0.7, 0.7);
            opp.updateHitbox();
            opp.setPosition(1100, 280);
            opp.color = 0x5C574A;
            opp.visible = true;
            opp.animation.play("slap");
            tweens.tween(opp, {x: opp.x + 200.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

            roughES.remove(opponents, true);
            roughES.insert(roughES.members.indexOf(roughES.hall7), opponents);

            plrStrumline.botplay = true;

            plrStrumline.resetStrums();
        }

        if (step == 2824)
        {
            var _plr:Character = getPlayer("bf-anim-teleported");
            _plr.animation.play("turn");
            
            gameCameraZoom = 1;
        }
        
        if (step == 2832)
        {
            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);

            gameCamera.snapToTarget();

            gameCameraZoom = 0.75;

            roughES.hall2.animation.play("0", false, false);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = playField.timerClock.visible =
                playField.timerNeedle.visible = true;

            playField.strumlines.visible = true;

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
        
            var _plr:Character = getPlayer("bf-anim-teleported");
            _plr.visible = false;
            
            var opp:Character = getOpponent("baldi-mad-face-front");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-furious"));
            opp.setPosition(-900.0, 18.5);
            opp.color = 0xC2B499;
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

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tweens.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 3218.0)
        {
            var opp:Character = getOpponent("baldi-furious");

            opp.animation.play("slap", true);

            tweens.tween(opp, {x: opp.x + 330.0}, conductor.beatLength * 0.25 * 0.001,
                {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x + 730.0},
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

            tweens.completeTweensOf(opp);

            tweens.tween(opp, {x: opp.x - 1060.0}, conductor.beatLength * 0.001, {ease: FlxEase.quadIn});
        }
    
        if (step == 3344)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
            gameCameraZoom = 0.9;
        
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;
        }
        
        if (step == 3464)
        {
            gameCameraZoom = 0.75;
            
            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);

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
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);
            oppStrumline.visible = false;
            plrStrumline.visible = false;

            roughES.hall2.visible = false;
            roughES.exit1.visible = false;
            roughES.baldiOffice.visible = true;

            gameCameraZoom = 1.0;
            
            tweens.tween(this, {gameCameraZoom: 0.8}, 3.5, {ease:FlxEase.quartIn});
            tweens.tween(gameCamera, {alpha: 0}, 3.5);
        
            var plr:Character = getPlayer("bf-running");
            plr.visible = false;
            
            var _plr:Character = getPlayer("run-legs");
            _plr.visible = false;

            plrStrumline.botplay = true;
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
                    tweens.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 725.0}, 0.35);}});
                }
                else
                {
                    tweens.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.35 * 0.001,
                        {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 725.0}, 0.5);}});
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

                tweens.tween(camera, {angle: 0.0}, conductor.beatLength * 0.85 * 0.001, {ease:FlxEase.quartOut});
            }
        }

        if (beat >= 216.0 && beat <= 218.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad-face-front");

                tweens.tween(opp.scale, {x: opp.scale.x + 0.3, y: opp.scale.y + 0.3}, conductor.beatLength * 0.275 * 0.001);

                tweens.tween(opp, {x: opp.x + 30.0}, conductor.beatLength * 0.275 * 0.001);

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
                    tweens.tween(opp.scale, {x: 2.5, y: 2.5}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp.scale, {x: 0.9,
                            y: 0.9}, 0.85);}});

                    tweens.tween(opp, {y: 150.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, 
                            {y: 125.0}, 0.85);}});
                }
                else
                {
                    tweens.tween(opp.scale, {x: 2.0, y: 2.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp.scale, {x: 0.9,
                            y: 0.9}, 0.85);}});

                    tweens.tween(opp, {y: 150.0}, conductor.beatLength * 0.275 * 0.001,
                        {ease: FlxEase.sineOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, 
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

                tweens.tween(opp.scale, {x: opp.scale.x + 0.2, y: opp.scale.y + 0.2},
                    conductor.beatLength * 0.275 * 0.001);
                
                tweens.tween(opp, {x: beat == 388.0 ? opp.x - 365.0 : opp.x + 1.0 * opp.scale.x}, conductor.beatLength * 0.275 * 0.001);

                tweens.tween(opp, {y: opp.y + 5.0}, conductor.beatLength * 0.275 * 0.001);

                opp.animation.play("slap", true);
            }
        }

        if (beat >= 472.0 && beat < 476.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad-face-front");

                tweens.tween(opp.scale, {x: opp.scale.x + 0.325, y: opp.scale.y + 0.325}, 
                    conductor.beatLength * 0.275 * 0.001);

                tweens.tween(opp, {y: opp.y + 5.0}, conductor.beatLength * 0.275 * 0.001);

                opp.animation.play("slap", true);
            }
        }
    
        if (beat >= 540.0 && beat <= 552.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-mad");
                
                tweens.tween(opp, {x: opp.x + 300.0}, conductor.beatLength * 0.275 * 0.001, {ease: FlxEase.sineIn});

                opp.animation.play("slap", true);
            }
        }

        if (Options.shaders)
        {
            if (beat >= 628 && beat <= 660.0)
            {
                if (beat % 2.0 == 1.0)
                    tweens.num(5.0, 0.0, conductor.beatLength * 0.001, {}, (num:Float) -> pxChunks.data.tileSize.value[0] = num);
            }
        }
    
        if (beat >= 708.0 && beat < 804.0 || beat >= 806.0 && beat < 868.0)
        {
            if (beat % 2.0 == 0.0)
            {
                var opp:Character = getOpponent("baldi-furious");

                tweens.tween(opp, {x: opp.x + 765.0}, conductor.beatLength * 0.275 * 0.001,
                    {ease: FlxEase.quadOut, onComplete: (_tween:FlxTween) -> {tweens.tween(opp, {x: opp.x - 765.0}, 0.35);}});

                opp.animation.play("slap", true);
            }
        }

        if (beat == 772.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.fromRGB(255, 125, 125), conductor.beatLength * 2.0 * 0.001, null, true);

            vignette = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/vigenette"));
            vignette.scale.set(2.7, 2.7);
            vignette.camera = hudCamera;
            vignette.screenCenter();
            vignette.alpha = 0.0;
            insert(0, vignette);
            tweens.tween(vignette, {alpha: 0.5}, 0.5);
        }

        if (beat == 776.0)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.fromRGB(255, 125, 125), conductor.beatLength * 2.0 * 0.001, null, true);
            tweens.tween(vignette, {alpha: 0.3}, 0.5);
        }

        if (beat == 805.0)
        {
            tweens.color(temperature, conductor.beatLength * 12.0 * 0.001, temperature.color, 0xFFFF0000,
                    {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
            tweens.tween(vignette, {alpha: 0.6}, 0.5);
        }

        if (beat == 836.0)
        {
            tweens.tween(vignette, {alpha: 1}, 0.5);
        }
    
        if (beat == 836.0 || beat == 852.0)
        {
            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 - 125.0,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);
        }
    
        if (beat == 844.0 || beat == 860.0)
        {
            SetCamFocusEvent.dispatch(this, (FlxG.width - cameraPoint.width) * 0.5 + 300.0,
                (FlxG.height - cameraPoint.height) * 0.5, null, 0.0);
        }

        if (beat == 868.0)
        {
            vignette.kill();
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
            timeInterval = timeInterval - 0.15;

        if (checkLayer)
        {      
            roughES.remove(craftersSprite1, true);

            roughES.insert(roughES.members.indexOf(players), craftersSprite1);
        }
        else
        {
            roughES.remove(craftersSprite1, true);

            roughES.insert(roughES.members.indexOf(players) + 1, craftersSprite1);
        }

        checkLayer = !checkLayer;
    }
}