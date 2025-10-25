package game.levels;

import openfl.filters.BitmapFilter;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.Options;
import core.Paths;

import data.CharacterData;

import game.stages.SuperSS;

using StringTools;

using flixel.util.FlxColorTransformUtil;

import game.levels.ScribbleL.ScribbleUI;

using util.MathUtil;
using util.PlayFieldTools;

class SuperSL extends PlayState
{
    public var superSS:SuperSS;

    public var classicUI:ClassicUI;

    public var temperature:FlxSprite;

    override function create():Void
    {
        stage = new SuperSS();

        superSS = cast (stage, SuperSS);

        super.create();

        classicUI = new ClassicUI(this);

        classicUI.visible = false;

        add(classicUI);

        superSS.bg.visible = true;

        superSS.light.visible = false;

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCameraZoom = 0.6;
        
        player.setPosition(700.0, 155.0);

        opponent.scale.set(2.9, 2.9);

        opponent.setPosition(-20.0, 120.0);

        superSS.bg.color = 0x470000;

        opponent.color = 0x000000;

        player.color = 0x000000;

        gameCamera.color = 0x000000;

        playField.visible = false;

        temperature = new FlxSprite();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 32.0 * 0.001, true);
        }

        if (step == 128)
            gameCamera.color = 0x000000;

        if (step == 160)
        {
            gameCamera.color = 0xFFFFFF;

            superSS.bg.color = 0xFFFFFF;

            opponent.color = 0xFFFFFF;

            player.color = 0xFFFFFF;

            playField.visible = true;

            cameraLock = FOCUS_CAM_CHAR;

            gameCameraZoom = 0.8;
        }

        if (step == 672)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            tweens.color(temperature, conductor.beatLength * 4.0 * 0.001, temperature.color, 0xFFFF8A8A,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});

            superSS.bg.color = 0x5A5A5A;

            superSS.light.visible = true;

            tweens.tween(superSS.light, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 800)
        {
            superSS.light.alpha = 1.0;

            tweens.tween(superSS.light, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom += 0.05;
        }

        if (step == 928)
        {
            gameCamera.visible = false;

            playField.setVisible(false);

            classicUI.timeText.visible = false;

            classicUI.progressBar.visible = false;

            tweens.color(temperature, conductor.beatLength * 1.0 * 0.001, temperature.color, 0xFFFFFFFF,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 960)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.setVisible(true);

            playField.healthBar.visible = false;

            playField.scoreClip.visible = false;

            playField.timerNeedle.visible = false;

            classicUI.timeText.visible = true;

            classicUI.progressBar.visible = true;

            gameCameraZoom = 0.8;

            gameCamera.visible = true;

            superSS.bg.color = 0xFFFFFF;
        }

        if (step == 1216)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            gameCameraZoom = 0.6;

            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();

            playField.setVisible(false);

            classicUI.timeText.visible = false;

            classicUI.progressBar.visible = false;
        }

        if (step == 1280)
            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 16.0 * 0.001, false);

        if (step == 1344)
            playField.visible = false;
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 164 && beat <= 167)
            gameCameraZoom += 0.025;
    }
}

class ClassicUI extends ScribbleUI
{
    public function new(game:PlayState):Void
    {
        super(game);

        var playField:PlayField = game.playField;

        playField.scoreClip.visible = true;

        var scoreText:FlxText = game.playField.scoreText;

        scoreText.antialiasing = true;

        scoreText.color = 0xFFFFFF;

        timeText.antialiasing = true;

        playField.scoreClip.visible = false;
    }
}