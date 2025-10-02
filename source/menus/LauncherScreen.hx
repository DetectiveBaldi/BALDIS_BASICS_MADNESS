package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.sound.FlxSound;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import api.DiscordHandler;

import core.AssetCache;
import core.Paths;

import extendable.TransitionState;

class LauncherScreen extends TransitionState
{
    public var launcher:FlxSprite;

    public var playButton:LauncherButton;

    public var twitterButton:LauncherButton;

    public var exitButton:LauncherButton;

    public var slapSound:FlxSound;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        DiscordHandler.setState(null);

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-launcher").bitmap);

        launcher = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/LauncherScreen/launcher"));

        launcher.active = false;

        launcher.scale.set(1.5, 1.5);

        launcher.updateHitbox();

        launcher.screenCenter();

        add(launcher);

        InitState.setMouseRect(launcher.x, launcher.x + launcher.width, launcher.y, launcher.y + launcher.height);

        playButton = new LauncherButton(0.0, 0.0, "playButton");

        playButton.onClick.add(playSlapSound.bind(clickPlayButton));

        playButton.setPosition(launcher.x + 15.0, launcher.y + launcher.height - playButton.height - 15.0);

        add(playButton);

        twitterButton = new LauncherButton(0.0, 0.0, "twitterButton");

        twitterButton.onClick.add(() -> {playSlapSound(null); clickTwitterButton();});

        twitterButton.setPosition(launcher.getMidpoint().x - twitterButton.width * 0.5, launcher.y + launcher.height - twitterButton.height - 15.0);

        add(twitterButton);

        exitButton = new LauncherButton(0.0, 0.0, "exitButton");

        exitButton.onClick.add(playSlapSound.bind(clickExitButton));

        exitButton.setPosition(launcher.x + launcher.width - exitButton.width - 15.0, launcher.y + launcher.height - exitButton.height - 15.0);

        add(exitButton);

        slapSound = FlxG.sound.load(AssetCache.getSound("shared/slap"));

        tune = FlxG.sound.load(AssetCache.getMusic("menus/LauncherScreen/tune"));

        tune.play();
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function playSlapSound(onComplete:()->Void):Void
    {
        slapSound.play(true);
        
        if (onComplete != null)
            slapSound.onComplete = onComplete;
    }

    public function clickPlayButton():Void
    {
        FlxG.switchState(() -> new #if debug TitleScreen #else LogoScreen #end ());
    }

    public function clickTwitterButton():Void
    {
        FlxG.openURL("https://x.com/BaldiMadness");
    }

    public function clickExitButton():Void
    {
        Sys.exit(0);
    }
}

class LauncherButton extends FlxSprite
{
    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, _path:String):Void
    {
        super(x, y);

        onClick = new FlxSignal();

        loadGraphic(AssetCache.getGraphic('menus/LauncherScreen/${_path}'), true, 83, 15);

        animation.add("0", [0], 0.0, false);

        animation.add("1", [1], 0.0, false);

        scale.set(1.5, 1.5);

        updateHitbox();

        animation.play("0");
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            if (FlxG.mouse.pressed)
                animation.play("1");
            else
                animation.play("0");

            if (FlxG.mouse.justReleased)
                onClick.dispatch();
        }
        else
            animation.play("0");
    }

    override function destroy():Void
    {
        super.destroy();

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}