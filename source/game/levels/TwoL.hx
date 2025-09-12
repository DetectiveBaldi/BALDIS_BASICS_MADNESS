package game.levels;

import flixel.FlxG;

import flixel.tweens.FlxEase;

import data.LevelData;

import extendable.CustomState;

import menus.TitleScreen;

import game.notes.Strum;
import game.notes.Strumline;

import game.stages.TwoS;

using util.MathUtil;

using StringTools;

class TwoL extends PlayState
{
    public var twoS:TwoS;

    override function create():Void
    {
        stage = new TwoS();

        twoS = cast (stage, TwoS);

        super.create();

        canPause = false;

        gameCamBopStrength = 0.0;

        hudCamBopStrength = 0.0;

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();
        oppStrumline.strums.alpha = 0.25;
        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

        countdown.skip();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        twoS.plus.visible = false;

        twoS.noise.visible = false;

        playField.visible = false;

        gameCameraZoom = 1.0;
        
        player.setPosition(700, 125);
        player.visible = false;

        opponent.setPosition(100.0, -148.0);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 256)
        {
            FlxG.camera.visible = false;
        }
    
        if (step == 260)
        {
            opponent.alpha = 1.0;

            playField.visible = true;

            FlxG.camera.visible = true;
        }

        if (step == 768)
        {
            twoS.plus.visible = true;
            twoS.plus.animation.play("0");
            tween.tween(twoS.plus, {alpha: 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            for (i in 0 ... 4)
                toggleStrumScroll(oppStrumline, i);

            for (i in 0 ... 2)
            {
                var strum:Strum = plrStrumline.strums.members[i];

                tween.tween(strum, {x: strum.x - 185.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
            }

            for (i in 2 ... 4)
            {
                var strum:Strum = plrStrumline.strums.members[i];

                tween.tween(strum, {x: strum.x + 185.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
            }
        }

        if (step == 1024)
        {
            tween.tween(twoS.plus, {alpha: 0.35}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            for (i in 0 ... 4)
                toggleStrumScroll(oppStrumline, i);

            for (i in 0 ... 2)
            {
                var strum:Strum = plrStrumline.strums.members[i];

                tween.tween(strum, {x: strum.x + 185.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
            }

            for (i in 2 ... 4)
            {
                var strum:Strum = plrStrumline.strums.members[i];

                tween.tween(strum, {x: strum.x - 185.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
            }
        }

        if (step == 1032)
            tween.tween(twoS.plus, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

        if (step == 1280.0)
        {
            twoS.noise.visible = true;
            twoS.noise.animation.play("1");
            tween.tween(twoS.noise, {alpha: 0.35}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            for (i in 0 ... 4)
            {
                var strum:Strum = oppStrumline.strums.members[i];

                tween.tween(strum, {alpha: 0.0}, conductor.beatLength * 2.0 * 0.001);
            }

            toggleStrumScroll(plrStrumline, 1);
        }

        if (step == 1344.0)
        {
            toggleStrumScroll(plrStrumline, 1);

            toggleStrumScroll(plrStrumline, 2);

            toggleStrumScroll(plrStrumline, 3);
        }

        if (step == 1408.0)
        {
            toggleStrumScroll(plrStrumline, 0);

            toggleStrumScroll(plrStrumline, 1);

            toggleStrumScroll(plrStrumline, 2);
        }

        if (step == 1528.0)
        {
            toggleStrumScroll(plrStrumline, 0);

            toggleStrumScroll(plrStrumline, 1);

            toggleStrumScroll(plrStrumline, 3);
        }
        
        if (step == 1536)
        {
            opponent.alpha = 0.0;

            playField.visible = false;

            FlxG.camera.visible = true;

            twoS.noise.alpha = 1.0;

            tween.tween(twoS.noise, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            FlxG.camera.alpha = 0.0;

            tween.tween(FlxG.camera, {alpha: 1.0}, conductor.beatLength * 16.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 1600)
            tween.tween(FlxG.camera, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 1616)
        {
            opponent.alpha = 1.0;

            tween.tween(FlxG.camera, {alpha: 1.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});
            
            twoS.noise.alpha = twoS.plus.alpha = 0.75;
        }
    }

    override function endSong():Void
    {
        var level:LevelData = PlayState.level;

        if (getClassFromNextState() == TitleScreen && HighScore.getLevelScore(level.name, level.difficulty).score != 0.0)
        {
            CustomState.cancelFadeIn = true;

            CustomState.cancelFadeOut = true;
        }

        super.endSong();
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
        

        super.startOutro(onOutroComplete);
    }

    public function toggleStrumScroll(strumline:Strumline, i:Int):Void
    {
        var strum:Strum = strumline.strums.members[i];

        strum.downscroll = !strum.downscroll;

        tween.tween(strum, {y: strum.downscroll ? FlxG.height - strum.height - 15.0 : 15.0},
            conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});
    }
}