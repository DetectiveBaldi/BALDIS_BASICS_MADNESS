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

import extendable.ResourceState;

class LogoScreen extends ResourceState
{
    public var splash:FlxSprite;

    public var logo:FlxSprite;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = false;

        FlxG.mouse.load(Assets.getGraphic(Paths.image(Paths.png("globals/defaultCursor"))).bitmap);

        splash = new FlxSprite();

        splash.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.image(Paths.png("menus/LogoScreen/splash"))), Paths.image(Paths.xml("menus/LogoScreen/splash")));

        splash.animation.addByIndices("formation", "this",  [for (i in 0 ... 29) i ], "", 17.4, false);

        splash.animation.addByIndices("spin", "this",  [for (i in 29 ... 45) i ], "", 12.0, false);

        splash.animation.play("formation");

        splash.scale.set(1.5, 1.5);

        splash.updateHitbox();

        splash.screenCenter();

        add(splash);

        logo = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("menus/LogoScreen/logo"))));

        logo.active = false;

        logo.scale.set(2.5, 2.5);

        logo.updateHitbox();

        logo.setPosition((FlxG.width - logo.width) * 0.5, -logo.height);

        add(logo);

        FlxTimer.wait(0.65, () ->
        {
            tune = FlxG.sound.load(Assets.getSound(Paths.music(Paths.ogg("menus/LogoScreen/tune"))));

            tune.play();

            FlxTimer.wait(2.65, () -> 
            {
                splash.animation.play("spin");

                FlxTween.tween(splash, {y: splash.y + 150.0}, 0.55, {ease: FlxEase.smoothStepOut});

                FlxTween.tween(logo, {y: (FlxG.height - logo.height) * 0.5 - 125.0}, 0.5, {ease: FlxEase.smoothStepOut});
            });

            FlxTimer.wait(3.25, () -> FlxG.camera.fade(FlxColor.BLACK, 1.5, false, () -> FlxG.switchState(() -> new WarningScreen())));
        });
    }
}