package game.levels;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import game.stages.ScribbleS;

import ui.ProgressBar;

using StringTools;

using flixel.util.FlxColorTransformUtil;

using util.MathUtil;

class ScribbleL extends PlayState
{
    public var scribbleS:ScribbleS;

    override function create():Void
    {
        stage = new ScribbleS();

        scribbleS = cast (stage, ScribbleS);

        super.create();

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();

        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        player.scale.set(3.75, 3.75);
        player.setPosition(700, 100);

        opponent.setPosition(1070, 185);
        opponent.scale.set(0.85, 0.85);

        opponent.colorTransform.setOffsets(FlxColor.WHITE);

        player.colorTransform.setOffsets(FlxColor.WHITE);

        playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

        oppStrumline.strums.alpha = 0.0;

        plrStrumline.strums.alpha = 0.0;

        gameCameraZoom = 1.3;

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 132.0)
        {
            tween.tween(oppStrumline.strums, {alpha: 0.25}, conductor.beatLength * 0.001);

            tween.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);
        }

        if (step == 288.0)
        {
            playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            scribbleS.classicHall0.visible = true;

            tween.tween(opponent.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 0.0},
                conductor.beatLength * 2.0 * 0.001);

            tween.tween(player.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 0.0},
                conductor.beatLength * 2.0 * 0.001);

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);
        }

        if (step == 1072)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.healthBar.visible = playField.scoreText.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            scribbleS.classicHall0.colorTransform.setOffsets(20, 20, 20, 155);
        }

        if (step == 1312)
        {
            tween.tween(player.colorTransform, {redOffset: 255.0, greenOffset: 255.0, blueOffset: 255.0, alphaOffset: 0.0},
                conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(opponent.colorTransform, {redOffset: 204.0, greenOffset: 204.0, blueOffset: 204.0, alphaOffset: 0.0},
                conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(scribbleS.classicHall0.colorTransform, {redOffset: 255.0, greenOffset: 255.0, blueOffset: 255.0, alphaOffset: 0.0},
                conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1328)
        {
            opponent.visible = false;

            player.colorTransform.setOffsets(0xFFFFFF);

            tween.tween(player, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            scribbleS.classicHall0.visible = false;
        }

        // TODO: Look into this later, right now certain zooms cause clipping issues.
        /*
        if (step == 548.0 || step == 552 || step == 555  || step == 682 || step == 684 || step == 736 || step == 1062 || step == 1068)
            gameCameraZoom += 0.1;

        if (step == 558  || step == 686 || step == 740)
            gameCameraZoom -= 0.1;
        */
    }

    override function measureHit(measure:Int):Void
    {
        super.measureHit(measure);
    
        if (cameraCharTarget == "OPPONENT")
            gameCameraZoom = 1.3;
        else
            gameCameraZoom = 1;
    }
}

class ScribbleUI extends FlxGroup
{
    public var playField:PlayField;

    public var progressBar:ProgressBar;

    public function new(playField:PlayField):Void
    {
        super();

        this.playField = playField;

        playField.scoreClip.kill();

        var scoreText:FlxText = playField.scoreText;

        scoreText.textField.antiAliasType = NORMAL;

        scoreText.textField.sharpness = 100.0;

        scoreText.kill();

        var healthBar:HealthBar = playField.healthBar;

        healthBar.kill();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        var scoreText:FlxText = playField.scoreText;

        if (scoreText.active)
            scoreText.update(elapsed);
    }

    override function draw():Void
    {
        super.draw();

        var scoreText:FlxText = playField.scoreText;

        if (scoreText.visible)
            scoreText.draw();
    }
}