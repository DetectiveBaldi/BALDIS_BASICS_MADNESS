package game.levels.classicw.diff_hard;

import flixel.animation.FlxAnimation;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;

import flixel.text.FlxText;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.diff_hard.FundamentalsS;

using util.MathUtil;

using StringTools;

class FundamentalsL extends PlayState
{
    public var fundamentalsS:FundamentalsS;

    public var principal:FlxSprite;

    public var jumpUI:JumpRopeUI;

    public var jumpMinigame:JumpRopeMinigame;

    override function create():Void
    {
        stage = new FundamentalsS();

        fundamentalsS = cast (stage, FundamentalsS);

        super.create();

        fundamentalsS.hall0.visible = true;

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCameraZoom = 0.65;

        opponent.setPosition(-650.0, -520.0);

        opponent.color = 0xA09A85;

        player.setPosition(720.0, 205.0);

        player.color = 0xB8B19C;

        gameCamera.alpha = 0.0;

        playField.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step >= 10.0 && step <= 15.0)
        {
            if (step % 2 == 0.0)
                gameCamera.alpha += 0.25;
        }

        if (step == 16)
        {
            gameCamera.alpha += 1.0;
            
            playField.visible = true;
        }

        if (step == 272)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.65;

            cameraLock = FOCUS_CAM_CHAR;
        }

        if (step == 784)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            cameraLock = FOCUS_CAM_POINT;

            cameraPoint.centerTo();
        }

        if (step == 790)
        {            
            principal = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/principal"));
            principal.scale.set(1.65, 1.65);
            principal.updateHitbox();
            principal.setPosition(-1200.0, 105.0);
            principal.color = 0xBBAC91;
            fundamentalsS.insert(fundamentalsS.members.indexOf(players), principal);

            tween.tween(principal, {x: 2000.0}, conductor.beatLength * 6.5 * 0.001);
        }

        if (step == 798)
            opponent.visible = false;

        if (step == 804)
        {
            player.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-anim-fundamentals"));
            plr.setPosition(player.x + 62.0, player.y + 62.0);
            plr.color = 0xB8B19C;
            plr.skipDance = true;
            plr.animation.play("happy");
            plr.visible = true;
            players.add(plr);
        }

        if (step == 816)
        {
            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.animation.play("run");
            tween.tween(plr, {x: 60.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quadIn});
        }

        if (step == 832)
        {
            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.animation.play("c0");
        }

        if (step == 840)
        {
           tween.tween(principal, {x: -1200.0}, conductor.beatLength * 4.0 * 0.001);
        }

        if (step == 848)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            fundamentalsS.hall0.visible = false;
            fundamentalsS.office.visible = true;

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = true;

            cameraLock = FOCUS_CAM_CHAR;

            opponent.visible = false;

            tween.cancelTweensOf(principal);
            principal.visible = false;

            var bul:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bully-spectator"));
            bul.setPosition(-50.0, 115.0);
            bul.scale.set(2.05, 2.05);
            bul.updateHitbox();
            bul.color = 0xADA493;
            spectators.add(bul);

            var _plr:Character = getPlayer("bf-anim-fundamentals");
            _plr.visible = false;
            
            var plr:Character = getPlayer("bf-face-left");
            plr.setPosition(720.0, 205.0);
            plr.visible = true;
            player = plr;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("principal"));
            opp.scale.set(1.35, 1.35);
            opp.updateHitbox();
            opp.setPosition(-60.0, 10.0);
            opp.color = 0xADA493;
            opponents.add(opp);
            opponent = opp;

            updateHealthBar("opponent");
        
            var timerText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "You get detention!\n30 seconds remain!", 48);

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
            }, 30);
        }

        if (step == 1232 || step == 1343)
            gameCameraZoom += 0.05;

        if (step == 1232)
        {
            var bul:Character = getSpectator("bully-spectator");
            bul.visible = false;
        }

        if (step == 1344)
            tween.tween(opponent, {x: 1500.0}, conductor.beatLength * 2.0 * 0.001);
       
        if (step == 1360)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            playField.visible = false;

            cameraLock = FOCUS_CAM_POINT;
            cameraPoint.centerTo();
            gameCamera.snapToTarget();

            fundamentalsS.office.visible = false;
            fundamentalsS.office2.visible = true;
            fundamentalsS.office2_Overlay.visible = true;

            principal.scale.set(0.75, 0.75);
            principal.updateHitbox();
            principal.setPosition(650.0, 250.0);
            principal.visible = true;
            
            fundamentalsS.remove(principal, true);
            fundamentalsS.insert(fundamentalsS.members.indexOf(fundamentalsS.office2_Overlay), principal);

            opponent.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("playtime-flipped"));
            opp.setPosition(1900.0, 110.0);
            opp.color = 0xBBAC91;
            opp.skipDance = true;
            opponents.add(opp);
            opponent = opp;

            player.visible = false;

            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.scale.set(4.5, 4.5);
            plr.updateHitbox();
            plr.setPosition(-150.0, -50.0);
            plr.animation.play("realize");
            plr.visible = true;
        
            tween.tween(principal, {x: -300.0}, conductor.beatLength * 4.0 * 0.001);
        }

        if (step == 1396)
        {
            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.animation.play("turn");
        }

        if (step == 1432)
        {
            fundamentalsS.office2.visible = false;
            fundamentalsS.office2_Overlay.visible = false;
            fundamentalsS.hall1.visible = true;

            principal.visible = false;

            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.scale.set(2.25, 2.25);
            plr.updateHitbox();
            plr.setPosition(-285.0, 160.0);
            plr.visible = false;
            plr.animation.play("d0");

            updateHealthBar("opponent");
        }

        if (step == 1438)
        {
            tween.tween(opponent, {x: 665.0}, conductor.beatLength * 5.0 * 0.001, {ease: FlxEase.quartOut});

            opponent.animation.play("play");

            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.visible = true;

            tween.tween(plr, {x: -315.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            fundamentalsS.hall1open.visible = true;
            fundamentalsS.hall1front.visible = true;

            remove(players);
            fundamentalsS.insert(fundamentalsS.members.indexOf(players), fundamentalsS.hall1front);
        }

        if (step == 1444)
        {
            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.animation.play("d1");
        }

        if (step == 1456)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            fundamentalsS.hall1open.visible = false;
            fundamentalsS.hall1front.visible = false;

            playField.visible = true;

            opponent.skipDance = false;

            var plr:Character = getPlayer("bf-anim-fundamentals");
            plr.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.setPosition(-105.0, 145.0);
            plr.color = 0xB8B19C;
            players.add(plr);
            player = plr;

            var oppStrumlineX:Float = oppStrumline.strums.x;
            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1660 || step == 1666)
            gameCameraZoom += 0.025;

        if (step == 1672)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.65;
        }

        if (step == 1864)
        {
            fundamentalsS.hall2.visible = true;
            fundamentalsS.hall1.visible = false;

            opponent.visible = false;
            player.visible = false;

            var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-face-left"));
            plr.setPosition(625.0, 125.0);
            plr.color = 0xB8B19C;
            players.add(plr);
            player = plr;
            
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("playtime"));
            opp.setPosition(-350.0, 180.0);
            opp.color = 0xBBAC91;
            opponents.add(opp);
            opponent = opp;

            var oppStrumlineX:Float = oppStrumline.strums.x;
            var plrStrumlineX:Float = plrStrumline.strums.x;

            tween.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
            tween.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 1876)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.725;

            cameraLock = FOCUS_CAM_CHAR;
        
            jumpUI = new JumpRopeUI();

            jumpUI.setPosition(player.x - jumpUI.width * 0.5, player.y + jumpUI.height * 0.5);

            add(jumpUI);

            jumpMinigame = new JumpRopeMinigame(jumpUI, playField);

            add(jumpMinigame);

                        player.visible = false;

            var plr:Character = getPlayer("bf-jump");

            if (plr == null)
            {
                var plr:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("bf-jump"));

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

        if (jumpUI != null && jumpMinigame != null)
        {
            if (step == 1882 || step == 1894 || step == 1906 || step == 1918 || step == 1930 || step == 1942 || step == 1954  
        || step == 1966 || step == 1978)
                jumpMinigame.sendJump();
        }

        if (step == 1984.0)
        {
            player.visible = false;

            player = getPlayer("bf-face-left");

            player.visible = true;
        }

        if (step == 2044)
        {
            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("baldi-mad"));
            opp.setPosition(-1500.0, 40.0);
            opp.color = 0xAFA38E;
            opp.scale.set(2.9, 2.9);
            opp.updateHitbox();
            opp.skipDance = true;
            opp.skipSing = true;
            opponents.add(opp);
        }

        if (step == 2056)
        {
            tween.tween(player, {x: 1800.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 2068)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            cameraLock = FOCUS_CAM_POINT;
            cameraPoint.centerTo();

            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
            playField.timerClock.visible = playField.timerNeedle.visible = false;

            tween.tween(opponent, {x: -2000.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 64.0 && beat <= 67.0)
        {
            gameCameraZoom += 0.025;
        }

        if (beat >= 511 && beat <= 532)
        {
            if (beat % 3 == 1.0)
            {
                var opp:Character = getOpponent("baldi-mad");

                tween.tween(opp, {x: opp.x + 350.0}, conductor.beatLength * 1.0 * 0.001, {ease: FlxEase.quartOut});

                opp.animation.play("slap");
            }
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
    public var playField:PlayField;
    
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

    public function new(ui:JumpRopeUI, playField:PlayField):Void
    {
        super();

        visible = false;

        this.ui = ui;
        
        this.playField = playField;

        timesJumped = 0;

        jumpCount = 0;

        height = -1.0;

        velocity = -1.0;

        leniency = 0.2;

        failed = false;

        ropeDelay = -1.0;

        checkTime = 0.5;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE && !Options.botplay)
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

        sprite?.animation?.play("jump");

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

            playField.healthBar.percent -= 25.0;

            playOopsAudio();
        }
    }

    public function playCountAudio():Void
    {
        FlxG.sound.play(AssetCache.getSound('shared/pt-${jumpCount}'), 0.2);
    }

    public function playOopsAudio():Void
    {
        FlxG.sound.play(AssetCache.getSound("shared/pt-oops-short"), 0.2);
    }
}