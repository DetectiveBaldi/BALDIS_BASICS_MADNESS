package game.levels.week1;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;

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

    override function create():Void
    {
        stage = new School();

        super.create();

        gameCamera.alpha = 0.0;

        gameCameraTarget.centerTo();

        gameCameraZoom = 1.15;

        plrStrumline.removeKeyboardListeners();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0.0)
        {
            tween.tween(gameCamera, {alpha: 1.0}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            tween.tween(this, {gameCameraZoom: 0.75}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            hudCamera.alpha = 0.0;

            tween.tween(hudCamera, {alpha: 1.0}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            opponents.visible = false;

            players.visible = false;
        }
        
        if (step == 136.0)
        {
            gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

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
            gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

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

            var runLegs:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("run-legs"));

            anim = runLegs.animation.getByName("legs");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            anim = runLegs.animation.getByName("legs miss");

            anim.frameRate = anim.numFrames / (conductor.beatLength * 0.001);

            runLegs.animation.play("legs", true);

            runLegs.skipDance = true;

            runLegs.skipSing = true;

            runLegs.setPosition(_plr.x, _plr.y);

            players.insert(players.members.indexOf(_plr), runLegs);

            _plr.animation.onFrameChange.add(updateLegStatus);

            plrStrumline.addKeyboardListeners();
        }

        if (step == 464.0)
        {
            var temp:FlxSprite = new FlxSprite();

            tween.color(temp, conductor.beatLength * 16.0 * 0.001, FlxColor.WHITE, 0xFFFFB2B2,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temp.color;}});
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
                {sodaSplash.active = false; sodaSplash.visible = false;}});
        }

        if (step == 528.0)
            gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

        if (step == 584.0)
        {
            gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var plr:Character = getPlayer("bf1");

            // TODO: Move this to the chart events list once we are out of the DEMO phase.

            CameraFollowEvent.dispatch(this, plr.getMidpoint().x - gameCameraTarget.width * 0.5, (FlxG.height - gameCameraTarget.height) * 0.5, "", 
                conductor.beatLength * 1.5 * 0.001, "quartOut");

            var _plr:Character = getPlayer("run-legs");

            castedStage.hall2.velocity.set(castedStage.hall2.velocity.x *= 1.25, 0.0);

            tween.tween(castedStage.hall2.velocity, {x: castedStage.hall2.velocity.x / 1.25}, conductor.beatLength * 0.001,
                {ease: FlxEase.sineOut});

            tween.tween(plr.animation, {timeScale: 1.0}, conductor.beatLength * 0.001, {ease: FlxEase.sineOut});

            tween.tween(_plr.animation, {timeScale: 1.0}, conductor.beatLength * 0.001, {ease: FlxEase.sineOut});
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
            gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

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
        }

        if (step == 720.0)
        {
            gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            var opp:Character = getOpponent("bully0");

            opp.visible = false;

            var _opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("bully1"));

            _opp.setPosition(-1085.0, -685.0);

            opponents.add(_opp);
        }

        if (step == 848.0)
        {
            gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 0.001, null, true);

            var opp:Character = getOpponent("bully1");

            tween.tween(opp, {y: -opp.height / 0.75}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.backIn});

            tween.tween(opp, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 36.0 && beat <= 132.0 || beat >= 220.0 && beat < 316.0)
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
                playField.statsText.visible = false;

                playField.healthBar.visible = false;

                playField.timeGauge.visible = false;

                playField.timeText.visible = false;

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