package game.levels;

import openfl.filters.BitmapFilter;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.CharacterData;
import data.PlayStats;

import game.stages.MishapS;

import util.ClickSoundUtil;

using util.MathUtil;
using util.PlayFieldTools;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class MishapL extends PlayState
{
    public var mishapS:MishapS;

    public var popups:FlxTypedGroup<MishapPopup>;

    override function create():Void
    {
        stage = new MishapS();

        mishapS = cast (stage, MishapS);

        super.create();
    
        setCamStartPos();

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        mishapS.breadySchool.visible = true;

        player.setPosition(840.0, 315.0);
    
        opponent.setPosition(-200.0, 125.0);

        playField.setVisible(false);

        playField.strumlines.visible = false;

        plrStrumline.botplay = true;

        popups = new FlxTypedGroup<MishapPopup>();

        popups.camera = hudCamera;
        
        add(popups);
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 16)
        {
            opponent.skipDance = true;

            opponent.animation.play("wave");
        }
        
        if (step == 64)
        {
            gameCameraZoom -= 0.2;
        
            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        
            opponent.skipDance = false;

            playField.setVisible(true);

            playField.strumlines.visible = true;

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 320.0)
        {
            FlxG.mouse.visible = true;

            FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-launcher").bitmap);
        }
        
        if (step == 320 || step == 452)
        {
            gameCameraZoom -= 0.1;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }
    
        if (step == 448)
            gameCameraZoom += 0.2;
    
        if (step == 576)
        {
            gameCameraZoom = 1;

            if (Options.flashingLights)
                gameCamera.flash(FlxColor.WHITE, conductor.beatLength * 2.0 * 0.001, null, true);
        }

        if (step == 704.0)
        {
            FlxG.mouse.visible = false;

            for (popup in popups)
                popup.kill();

            popups.members.resize(0);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 80.0 && beat < 176.0)
        {
            if (FlxG.random.bool(5.0))
                spawnPopup();
        }
    }

    public function spawnPopup():Void
    {
        var popup:MishapPopup = new MishapPopup();

        popup.camera = hudCamera;

        popup.setPosition(FlxG.random.int(0, FlxG.width - Std.int(popup.width)),
            FlxG.random.int(0, FlxG.height - Std.int(popup.height)));

        popups.add(popup);
    }
}

class MishapPopup extends FlxSpriteGroup
{
    public var base:FlxSprite;

    public var closeButton:FlxSprite;

    public function new():Void
    {
        super();

        base = new FlxSprite(0.0, 0.0, AssetCache.getGraphic('shared/mishap-popups/popup-${getRandomIndex()}'));

        base.active = false;

        base.scale.set(1.75, 1.75);

        base.updateHitbox();

        add(base);

        closeButton = new FlxSprite().loadGraphic(AssetCache.getGraphic("shared/mishap-popups/close-button-sheet"), true, 15, 15);

        closeButton.active = false;

        closeButton.animation.add("0", [0], 0.0, false);

        closeButton.animation.add("1", [1], 0.0, false);

        closeButton.animation.play("0");

        closeButton.scale.set(1.75, 1.75);

        closeButton.updateHitbox();

        closeButton.x = base.width - closeButton.width;

        add(closeButton);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(closeButton, camera))
        {
            closeButton.animation.play("1");
                        
            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
            {
                kill();

                ClickSoundUtil.play();
            }
        }
        else
            closeButton.animation.play("0");
    }

    public function getRandomIndex():Int
    {
        var result:Int = FlxG.random.int(0, 6);

        if (FlxG.random.int(0, 9) == 9)
            result = 99;

        return result;
    }
}