package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.sound.FlxSound;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import api.DiscordHandler;

import core.AssetCache;
import core.Paths;

import extendable.TransitionState;

import interfaces.ISequenceHandler;

using util.MathUtil;

class LogoScreen extends TransitionState implements ISequenceHandler
{
    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;

    public var splash:FlxSprite;

    public var logo:FlxSprite;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        DiscordHandler.setState(null);

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        DiscordHandler.setImageTexts(null, null);

        tweens = new FlxTweenManager();

        add(tweens);

        timers = new FlxTimerManager();

        add(timers);

        splash = new FlxSprite();

        splash.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("menus/LogoScreen/splash"), 
            Paths.image(Paths.xml("menus/LogoScreen/splash")));

        splash.animation.addByIndices("formation", "this",  [for (i in 0 ... 29) i ], "", 17.4, false);

        splash.animation.addByIndices("spin", "this",  [for (i in 29 ... 45) i ], "", 12.0, false);

        splash.scale.set(1.5, 1.5);

        splash.updateHitbox();

        splash.screenCenter();

        add(splash);

        logo = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/LogoScreen/logo"));

        logo.active = false;

        logo.scale.set(2.5, 2.5);

        logo.updateHitbox();

        logo.setPosition(logo.getCenterX(), -logo.height);

        add(logo);

        new FlxTimer(timers).start(0.5, (_:FlxTimer) ->
        {
            splash.animation.play("formation");

            new FlxTimer(timers).start(0.15, (_:FlxTimer) ->
            {
                tune = FlxG.sound.load(AssetCache.getMusic("menus/LogoScreen/tune"));

                tune.play();

                new FlxTimer(timers).start(2.65, (_:FlxTimer) -> 
                {
                    splash.animation.play("spin");

                    tweens.tween(splash, {y: splash.y + 150.0}, 0.55, {ease: FlxEase.smoothStepOut});

                    tweens.tween(logo, {y: logo.getCenterY() - 125.0}, 0.5, {ease: FlxEase.smoothStepOut});
                });

                 new FlxTimer(timers).start(3.25, (_:FlxTimer) ->
                    FlxG.camera.fade(FlxColor.BLACK, 1.5, false, () -> FlxG.switchState(() -> new WarningScreen())));
            });
        });
    }

    override function destroy():Void
    {
        super.destroy();
        
        FlxG.mouse.visible = false;
    }
}