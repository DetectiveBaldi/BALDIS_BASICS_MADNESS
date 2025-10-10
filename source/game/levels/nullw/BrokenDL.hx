package game.levels.nullw;

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

import game.stages.nullw.BrokenDS;

using util.MathUtil;
using util.PlayFieldTools;

using StringTools;

class BrokenDL extends PlayState
{
    public var brokenDS:BrokenDS;

    override function create():Void
    {
        stage = new BrokenDS();

        brokenDS = cast (stage, BrokenDS);

        brokenDS.room.visible = true;

        brokenDS.desk.visible = true;

        super.create();

        gameCamera.color = FlxColor.BLACK;

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCameraZoom = 0.55;

        opponent.scale.set(1.6, 1.6);

        opponent.setPosition(160.0, -20.0);

        player.scale.set(6.4, 6.4);

        player.updateHitbox();

        player.setPosition(-720.0, 650.0);

        brokenDS.remove(opponents, true);

        brokenDS.insert(brokenDS.members.indexOf(brokenDS.desk), opponents);

        playField.visible = false;

        plrStrumline.botplay = true;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            gameCamera.color = FlxColor.WHITE;

            gameCamera.fade(FlxColor.BLACK, conductor.beatLength * 32.0 * 0.001, true);
        }

        if (step == 64)
        {
            // null anim 1
        }

        if (step == 72)
        {
            tweens.tween(player.scale, {x: 4.8, y: 4.8}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(player, {x: -355.0, y: -360.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartOut});
        }

        if (step == 128)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            plrStrumline.botplay = Options.botplay;

            playField.visible = true;
        }

        if (step == 640)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.7;

            plrStrumline.botplay = true;
            plrStrumline.resetStrums();

            playField.visible = false;

            // null anim 2
        }

        if (step == 768 || step == 912)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            plrStrumline.botplay = Options.botplay;

            playField.visible = true;

            gameCameraZoom = 0.55;
        }

        if (step == 896)
        {
            // null anim 3

            gameCameraZoom = 0.7;
        }

        if (step == 1424)
            gameCameraZoom = 0.7;

        if (step == 1680)
        {
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);

            gameCameraZoom = 0.55;

            playField.setVisible(false);
        }

        if (step == 1724)
        {
            gameCamera.visible = false;

            playField.visible = false;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
        
        if (beat >= 32.0 && beat < 431.0)
        {
            if (cameraCharTarget == "OPPONENT")
                tweens.tween(player, {alpha: 0.5}, conductor.beatLength * 0.5 * 0.001);
            else
                tweens.tween(player, {alpha: 1.0}, conductor.beatLength * 0.5 * 0.001);
        }
    }
}