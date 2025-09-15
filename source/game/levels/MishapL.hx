package game.levels;

import util.ClickSoundUtil;
import data.PlayStats;
import core.AssetCache;
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

import game.stages.MishapS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class MishapL extends PlayState
{
    public var mishapS:MishapS;

    public var adChance:Int;

    public var ad:FlxSprite;

    public var close:FlxSprite;

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

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-launcher").bitmap);
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
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 80 && beat <= 175)
            adChance = FlxG.random.int(0, 25);

        if (adChance == 25)
            spawnAdPopup();
    }

    public function spawnAdPopup():Void
    {
        ad = new FlxSprite();

        ad.loadGraphic(AssetCache.getGraphic('shared/mishapAds/ad${FlxG.random.int(0, 6)}'));

        ad.scale.set(1.7, 1.7);

        ad.updateHitbox();

        ad.setPosition(FlxG.random.float(0, FlxG.width - ad.width), 
            FlxG.random.float(0, FlxG.height - ad.height));

        ad.camera = hudCamera;

        add(ad);

        close = new FlxSprite();

        close.loadGraphic(AssetCache.getGraphic("shared/mishapAds/close-sheet"), true, 15, 15);

        close.animation.add("0", [0], 0.0, false);

        close.animation.add("1", [1], 0.0, false);

        close.animation.play("0");

        close.scale.set(1.7, 1.7);

        close.updateHitbox();
        
        close.setPosition(ad.getMidpoint().x + 240.0, ad.y + 8.25);

        close.camera = hudCamera;

        add(close);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (close != null && ad != null)
        {
            if (FlxG.mouse.overlaps(close, hudCamera))
            {
                close.animation.play("1");

                if (FlxG.mouse.justReleased)
                {
                    ClickSoundUtil.play();

                    ad.destroy();
                    close.destroy();
                }
            }
            else
                close.animation.play("0");
        }
    }
}