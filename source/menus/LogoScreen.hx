package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.sound.FlxSound;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.Assets;
import core.Paths;

import effects.TransitionState;

class LogoScreen extends TransitionState
{
    public var splash:FlxSprite;

    public var logo:FlxSprite;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = false;

        splash = new FlxSprite();

        splash.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.png("assets/images/menus/LogoScreen/splash")), Paths.xml("assets/images/menus/LogoScreen/splash"));

        splash.animation.addByPrefix("this", "this", 11.0, false);

        splash.scale.set(1.5, 1.5);

        splash.updateHitbox();

        splash.screenCenter();

        add(splash);

        logo = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.png("assets/images/menus/LogoScreen/logo")));

        logo.active = false;

        logo.setPosition((FlxG.width - logo.width) * 0.5, -logo.height);

        add(logo);

        FlxTimer.wait(0.5, () ->
        {
            splash.animation.play("this");

            tune = FlxG.sound.load(Assets.getSound(Paths.ogg("assets/music/menus/LogoScreen/tune")));

            tune.play();

            FlxTimer.wait(2.65, () -> 
            {
                FlxTween.tween(splash, {y: splash.y + 150.0}, 0.55, {ease: FlxEase.smoothStepOut});

                FlxTween.tween(logo, {y: (FlxG.height - logo.height) * 0.5 - 125.0}, 0.5, {ease: FlxEase.smoothStepOut});
            });

            FlxTimer.wait(3.25, () -> FlxG.camera.fade(FlxColor.BLACK, 1.5, false, () -> FlxG.switchState(() -> new WarningScreen())));
        });
    }
}