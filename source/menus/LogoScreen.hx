package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.sound.FlxSound;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.Assets;
import core.Paths;

import game.levels.Level1;

class LogoScreen extends FlxState
{
    public var haxeSplash:FlxSprite;

    public var logo:FlxSprite;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        haxeSplash = new FlxSprite();

        haxeSplash.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.png("assets/images/menus/LogoScreen/haxeSplash")), Paths.xml("assets/images/menus/LogoScreen/haxeSplash"));

        haxeSplash.animation.addByPrefix("this", "this", 11.0, false);

        haxeSplash.scale *= 1.5;

        haxeSplash.updateHitbox();

        haxeSplash.screenCenter();

        add(haxeSplash);

        logo = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.png("assets/images/menus/LogoScreen/logo")));

        logo.setPosition((FlxG.width - logo.width) * 0.5, -logo.height);

        add(logo);

        FlxTimer.wait(0.5, () ->
        {
            haxeSplash.animation.play("this");

            tune = FlxG.sound.load(Assets.getSound(Paths.ogg("assets/sounds/menus/LogoScreen/tune")));

            tune.play();

            FlxTimer.wait(2.65, () -> 
            {
                FlxTween.tween(haxeSplash, {y: haxeSplash.y + 150.0}, 0.5, {ease: FlxEase.smoothStepOut});

                FlxTween.tween(logo, {y: (FlxG.height - logo.height) * 0.5 - 150.0}, 0.5, {ease: FlxEase.smoothStepOut});
            });

            FlxTimer.wait(3.25, () -> FlxG.camera.fade(FlxColor.BLACK, 1.0, false, () -> FlxG.switchState(() -> new Level1())));
        });
    }
}