package game.levels.classicw;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;
import core.Paths;

import game.events.SetCamFocusEvent;
import game.stages.classicw.PlaymateS;

using util.MathUtil;
using util.PlayFieldTools;

using StringTools;

class PlaymateL extends PlayState
{
    public var playmateS:PlaymateS;

    public var black:FlxSprite;

    public var opp:Character;

    public var tutorText:FlxText;

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

        plrStrumline.botplay = true;

        player.setPosition(700.0, 150.0);

        opponent.setPosition(-1500.0, 190.0);

        gameCamera.color = FlxColor.BLACK;

        playField.setVisible(false);

        playField.strumlines.visible = false;

        tutorText = new FlxText(0.0, 0.0, player.width * 2.0, "Time to jump rope!\nPress Left Mouse Button to jump!");

        tutorText.color = FlxColor.BLACK;

        tutorText.size = 42;

        tutorText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        tutorText.alignment = CENTER;

        tutorText.setBorderStyle(OUTLINE, FlxColor.WHITE, 2.0);

        tutorText.setPosition(tutorText.getCenterX(player), -tutorText.height * 3.0);

        add(tutorText);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (jumpMinigame?.failed)
        {
            getTransitionSprite(conductor.beatLength * 0.001, OUT, runItBack);

            FlxG.sound.play(AssetCache.getSound('shared/playmate-reverse'), 1.0);

            opponentVocals.volume = 0.0;

            player.animation.play("jump miss");

            jumpUI.kill();

            jumpMinigame.kill();

            jumpUI = null;

            jumpMinigame = null;
        }
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 32.0 * 0.001, true);

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 128)
        {
            opponent.skipDance = true;
            
            opponent.animation.play("play");

            tweens.tween(opponent, {x: -80.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 142)
            cameraLock = FOCUS_CAM_CHAR;

        if (step == 144 || step == 656)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            opponent.skipDance = false;

            playField.setVisible(true);

            playField.strumlines.visible = true;

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

        if (step == 920)
        {
            gameCameraZoom = 0.8;

            playField.setVisible(false);

            plrStrumline.botplay = true;

            plrStrumline.resetStrums();

            if (!Options.botplay)
            {
                tweens.tween(tutorText, {y: player.y - tutorText.height * 0.5}, conductor.beatLength * 2.0 * 0.001,
                    {ease: FlxEase.backOut});
            }
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

            jumpMinigame = new JumpRopeMinigame(jumpUI);

            add(jumpMinigame);

            player.visible = false;

            var plr:Character = getPlayer("bf-jump");

            if (plr == null)
            {
                var plr:Character = new Character(this, 0.0, 0.0, Character.getConfig("bf-jump"));

                plr.skipDance = true;

                plr.skipSing = true;

                plr.setPosition(player.x + 20.0, player.y - 20.0);

                player = plr;

                players.add(plr);
            }
            else
            {
                player = plr;

                player.visible = true;

                player.animation.play("jump");

                player.animation.finish();

                player.animation.curAnim.curFrame = 0;
            }

            jumpMinigame.sprite = player;
        }

        // So we don't cause a null object reference while resetting the scene.
        if (jumpUI != null && jumpMinigame != null)
        {
            if (step == 928 || step == 944 || step == 960 || step == 976 || step == 992)
                jumpMinigame.sendJump();

            if (step == 1008.0)
            {
                if (!Options.botplay)
                {
                    tweens.tween(tutorText, {y: -tutorText.height * 3.0}, conductor.beatLength * 2.0 * 0.001,
                        {ease: FlxEase.backOut});
                }
                
                jumpUI.kill();

                jumpMinigame.kill();
            }
        }

        if (step == 1044.0)
        {
            player.visible = false;

            player = getPlayer("bf-face-left");

            player.visible = true;

            plrStrumline.botplay = Options.botplay;

            tweens.tween(oppStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});

            tweens.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadOut});
        }

        if (step == 1168)
        {
            tweens.tween(this, {gameCameraZoom: 0.55}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1184)
        {
            playmateS.hall.color = playmateS.cafe.color = 0x777777;

            opp = new Character(this, 0.0, 0.0, Character.getConfig("baldi-mad-face-front"));
            opp.setPosition(650.0, 110.0);
            opp.scale.set(0.95, 0.95);
            opp.skipDance = true;
            opp.skipSing = true;
            opp.animation.play("slap");
            add(opp);

            remove(opp, true);
            playmateS.insert(playmateS.members.indexOf(playmateS.hall), opp);

            tweens.tween(opp, {x: 540.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom = 0.8;
        }

        if (step == 1200)
        {
            opp.animation.play("slap");

            tweens.tween(opp, {x: 400.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1216)
        {
            opp.animation.play("slap");

            tweens.tween(opp, {x: 260.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1232)
        {
            opp.animation.play("slap");

            tweens.tween(opp, {x: 120.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1188)
        {
            playmateS.hall.color = playmateS.cafe.color = 0xFFFFFF;

            gameCameraZoom = 0.7;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.setVisible(true);
        }

        if (step == 1440)
        {   
            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();

            gameCameraZoom = 0.6;
            
            opp = new Character(this, 0.0, 0.0, Character.getConfig("baldi-mad"));
            opp.setPosition(-700.0, 30.0);
            opp.scale.set(2.9, 2.9);
            opp.skipDance = true;
            opp.skipSing = true;
            opp.animation.play("slap");
            add(opp);

            tweens.tween(opp, {x: -300.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1456)
        {
            opp.animation.play("slap");

            tweens.tween(opp, {x: 0.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom += 0.05;
        }

        if (step == 1464)
            tweens.tween(player, {x: 1600.0}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartIn});

        if (step == 1472)
        {
            opp.animation.play("slap");

            tweens.tween(opp, {x: 400.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            playField.setVisible(false);

            tweens.tween(oppStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(plrStrumline.strums, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            gameCameraZoom = 0.7;
        }

        if (step == 1488)
        {
            plrStrumline.botplay = true;
        }

        if (step == 1488)
        {
            opp.animation.play("slap");

            tweens.tween(opp, {x: 800.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(opponent, {x: -1200.0}, conductor.beatLength * 8.0 * 0.001, {ease: FlxEase.quartIn});

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 8.0 * 0.001, false);
        }

        if (step == 1504)
        {
            opp.animation.play("slap");

            tweens.tween(opp, {x: 1300.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});
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

    public function runItBack():Void
    {
        changeTime(91999);

        getTransitionSprite(conductor.beatLength * 0.001, IN, null);

        playmateS.hall.color = playmateS.cafe.color = FlxColor.WHITE;

        opponentVocals.volume = 1.0;
        
        player.visible = false;

        player = getPlayer("bf-face-left");

        player.visible = true;

        SetCamFocusEvent.dispatch(this, 0.0, 0.0, "opponent", -1.0, "linear", true);

        tutorText.setPosition(tutorText.getCenterX(player), -tutorText.height * 3.0);
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

        waitJump.scale.set(2.0, 2.0);

        waitJump.updateHitbox();

        add(waitJump);

        nowJump = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/levels/classicw/PlaymateL/JumpRopeUI/now-jump"));

        nowJump.active = false;

        nowJump.visible = false;

        nowJump.scale.set(2.0, 2.0);

        nowJump.updateHitbox();

        add(nowJump);
    }
}

class JumpRopeMinigame extends FlxBasic
{
    public var ui:JumpRopeUI;

    public var sprite:FlxSprite;

    public var timesJumped:Int;

    public var jumpCount:Int;

    public var height:Float;

    public var velocity:Float;

    public var leniency:Float;

    public var failed:Bool;

    public var ropeDelay:Float;

    public var checkTime:Float;

    public function new(ui:JumpRopeUI):Void
    {
        super();

        visible = false;

        this.ui = ui;

        timesJumped = 0;

        jumpCount = 0;

        height = -1.0;

        velocity = -1.0;

        leniency = 0.2;

        failed = false;

        ropeDelay = -1.0;

        checkTime = 0.9;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.justPressed && !Options.botplay)
            jumpAction();

        if (height >= 0.0)
        {
            height += velocity * elapsed + 1.0 * -2.0 * elapsed * elapsed;

            velocity += -3.85 * elapsed;
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

                if (checkTime > 0.0)
                    checkTime -= elapsed;
                else
                    checkJump();

                if (Options.botplay)
                    jumpAction();
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
        if (timesJumped == jumpCount)
            return;

        sprite?.animation?.play("jump", true);

        timesJumped++;

        height = 0.0;

        velocity = 2.0;
    }

    public function checkJump():Void
    {
        velocity = -1.0;

        ropeDelay = -1.0;

        checkTime = 0.9;

        if (height > leniency)
            playCountAudio();
        else
        {
            sprite?.animation?.play("jump miss");

            failed = true;

            playOopsAudio();
        }
    }

    public function playCountAudio():Void
    {
        FlxG.sound.play(AssetCache.getSound('shared/pt-${jumpCount}'), 0.7);
    }

    public function playOopsAudio():Void
    {
        FlxG.sound.play(AssetCache.getSound("shared/pt-oops-short"), 0.7);
    }
}