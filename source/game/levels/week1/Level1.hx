package game.levels.week1;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;

import data.CharacterData;

import game.events.CameraFollowEvent;

import game.stages.School;

import core.Assets;
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
            tween.tween(gameCamera, {alpha: 1}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            tween.tween(this, {gameCameraZoom: 0.75}, conductor.beatLength * 4.0 * 8.5 * 0.001);

            hudCamera.alpha = 0.0;

            tween.tween(hudCamera, {alpha: 1}, conductor.beatLength * 4.0 * 8.5 * 0.001);

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

            _plr.setPosition(798.5, 205.5);

            players.add(_plr);

            var runLegs:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("run-legs"));

            runLegs.animation.play("legs", true);

            runLegs.skipDance = true;

            runLegs.skipSing = true;

            runLegs.setPosition(_plr.x, _plr.y);

            players.insert(players.members.indexOf(_plr), runLegs);

            _plr.animation.onFrameChange.add(updateLegStatus);

            plrStrumline.addKeyboardListeners();
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

        if (step == 584.0)
        {
            var plr:Character = getPlayer("bf1");

            var _plr:Character = getPlayer("run-legs");

            // TODO: Move this to the chart events list once we are out of the DEMO phase.

            CameraFollowEvent.dispatch(this, plr.getMidpoint().x, gameCamera.scroll.y + gameCamera.height * 0.5, "", 
                conductor.beatLength * 0.001);

            castedStage.hall2.velocity.set(castedStage.hall2.velocity.x *= 1.25, 0.0);

            tween.tween(castedStage.hall2.velocity, {x: castedStage.hall2.velocity.x / 1.25}, conductor.beatLength * 0.001,
                {ease: FlxEase.sineOut});

            tween.tween(plr.animation, {timeScale: 1.0}, conductor.beatLength * 0.001, {ease: FlxEase.sineOut});

            tween.tween(_plr.animation, {timeScale: 1.0}, conductor.beatLength * 0.001, {ease: FlxEase.sineOut});
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

                tween.tween(opp, {x: opp.x + 725.0}, conductor.beatLength * 0.35 * 0.001,
                {
                    ease: FlxEase.sineIn,

                    onComplete: (_tween:FlxTween) -> {tween.tween(opp, {x: opp.x - 725.0}, 0.5);}
                });

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