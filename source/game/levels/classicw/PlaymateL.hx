package game.levels.classicw;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.group.FlxSpriteGroup;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import game.stages.classicw.PlaymateS;

using util.MathUtil;

using StringTools;

class PlaymateL extends PlayState
{
    public var playmateS:PlaymateS;

    public var black:FlxSprite;

    public var opp:Character;

    public var jumpUI:JumpRopeUI;

    public var jumpMinigame:JumpRopeMinigame;

    override function create():Void
    {
        stage = new PlaymateS();

        playmateS = cast (stage, PlaymateS);

        super.create();

        playmateS.cafe.visible = true;

        playmateS.hall.visible = true;

        cameraPoint.centerTo();

        cameraLock = FOCUS_CAM_POINT;

        gameCamera.snapToTarget();

        gameCameraZoom = 0.75;

        player.setPosition(700.0, 150.0);

        opponent.setPosition(-1500.0, 190.0);

        gameCamera.color = FlxColor.BLACK;

        playField.visible = false;
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
        {
            opponent.skipDance = true;
            
            opponent.animation.play("play");

            tween.tween(opponent, {x: -80.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 142)
            cameraLock = FOCUS_CAM_CHAR;

        if (step == 144 || step == 656)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            opponent.skipDance = false;

            playField.visible = true;

            gameCameraZoom = 0.65;
        }

        if (step == 392 || step == 520 || step == 648 || step == 1304)
            gameCameraZoom = 0.8;

        if (step == 400 || step == 528 || step == 1312)
        {
            gameCameraZoom -= 0.05;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 912)
        {
            gameCameraZoom = 0.8;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;
        }

        if (step == 928)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.7;

            oppStrumline.strums.alpha = 0.0;

            plrStrumline.strums.alpha = 0.0;

            playmateS.hall.color = playmateS.cafe.color = 0xADADAD;

            jumpUI = new JumpRopeUI();

            jumpUI.setPosition(player.x - jumpUI.width * 0.5, player.y + jumpUI.height * 0.5);

            add(jumpUI);

            jumpMinigame = new JumpRopeMinigame(jumpUI, 5);

            add(jumpMinigame);
        }

        if (step == 928 || step == 944 || step == 960 || step == 976 || step == 992)
            jumpMinigame.sendJump();

        if (step == 1008.0)
        {
            jumpUI.kill();

            jumpMinigame.kill();
        }
        
        if (step == 1040)
        {
            tween.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});

            tween.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 1168)
        {
            tween.tween(this, {gameCameraZoom: 0.55}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1184)
        {
            playmateS.hall.color = playmateS.cafe.color = 0x777777;

            opp = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad-face-front"));
            opp.setPosition(650.0, 110.0);
            opp.scale.set(0.95, 0.95);
            opp.skipDance = true;
            opp.skipSing = true;
            opp.animation.play("slap");
            add(opp);

            remove(opp, true);
            playmateS.insert(playmateS.members.indexOf(playmateS.hall), opp);

            tween.tween(opp, {x: 540.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom = 0.8;
        }

        if (step == 1200)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 400.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1216)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 260.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1232)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 120.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1188)
        {
            playmateS.hall.color = playmateS.cafe.color = 0xFFFFFF;

            gameCameraZoom = 0.7;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;
        }

        if (step == 1440)
        {   
            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();

            gameCameraZoom = 0.6;
            
            opp = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad"));
            opp.setPosition(-700.0, 30.0);
            opp.scale.set(2.9, 2.9);
            opp.skipDance = true;
            opp.skipSing = true;
            opp.animation.play("slap");
            add(opp);

            tween.tween(opp, {x: -300.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1456)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 0.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom += 0.05;
        }

        if (step == 1464)
            tween.tween(player, {x: 1600.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 1472)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 400.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;

            tween.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tween.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            gameCameraZoom = 0.7;
        }

        if (step == 1488)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 800.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            tween.tween(opponent, {x: -1200.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 8.0 * 0.001, false);
        }

        if (step == 1504)
        {
            opp.animation.play("slap");

            tween.tween(opp, {x: 1300.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    
        if (beat >= 360 && beat < 368)
        {
            if (beat % 2 == 0)
                gameCameraZoom += 0.025;
        }
    }
}

class JumpRopeUI extends FlxSpriteGroup
{
    public var waitJump:FlxSprite;

    public var nowJump:FlxSprite;

    public function new():Void
    {
        super();

        waitJump = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/levels/classicw/PlaymateL/JumpRopeUI/wait-jump"));

        waitJump.active = false;

        waitJump.visible = false;

        waitJump.scale.set(1.5, 1.5);

        waitJump.updateHitbox();

        add(waitJump);

        nowJump = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/levels/classicw/PlaymateL/JumpRopeUI/now-jump"));

        nowJump.active = false;

        nowJump.visible = false;

        nowJump.scale.set(1.5, 1.5);

        nowJump.updateHitbox();

        add(nowJump);
    }
}

class JumpRopeMinigame extends FlxBasic
{
    public var ui:JumpRopeUI;

    public var maxJumps:Int;

    public var jumpCount:Int;

    public var height:Float;

    public var failed:Bool;

    public var ropeDelay:Float = -1.0;

    public var hitTime:Float = 0.9;

    public var jumpVelocity:Float = 2.0;

    public var jumpBuffer:Float = 0.2;

    public function new(ui:JumpRopeUI, maxJumps:Int):Void
    {
        super();

        visible = false;

        this.ui = ui;

        jumpCount = 0;

        this.maxJumps = maxJumps;

        height = -1.0;

        failed = false;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE && height <= 0.0)
            jumpAction();

        if (height >= 0.0)
        {
            height += jumpVelocity * elapsed + 1.0 * -2.0 * elapsed * elapsed;

            jumpVelocity += -3.85 * elapsed;
        }

        if (ropeDelay != -1.0)
        {
            if (ropeDelay > 0.0)
            {
                ropeDelay -= elapsed;

                ui.waitJump.visible = true;

                ui.nowJump.visible = false;
            }
            else
            {
                ui.waitJump.visible = false;

                ui.nowJump.visible = true;

                if (hitTime > 0.0)
                    hitTime -= elapsed;
                else
                    checkJump();
            }
        }
    }

    public function sendJump():Void
    {
        jumpCount++;

        ropeDelay = 0.5;
    }

    public function jumpAction():Void
    {
        height = 0.0;

        jumpVelocity = 2.0;
    }

    public function resetJumps():Void
    {
        jumpCount = 0;
    }

    public function checkJump():Void
    {
        ropeDelay = -1.0;

        hitTime = 0.9;

        if (height > jumpBuffer)
        {
            playCountAudio();
        }
        else
        {
            failed = true;

            playFailAudio();
        }
    }

    public function playCountAudio():Void
    {
        FlxG.sound.play(AssetCache.getSound('shared/pt-${jumpCount}'), 0.3);
    }

    public function playFailAudio():Void
    {
        FlxG.sound.play(AssetCache.getSound("shared/pt-oops"), 0.3);
    }
}