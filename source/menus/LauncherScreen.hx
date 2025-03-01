package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.sound.FlxSound;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.Assets;
import core.Paths;

import effects.TransitionState;

class LauncherScreen extends TransitionState
{
    public var launcher:FlxSprite;

    public var playButton:LauncherButton;

    public var discordButton:LauncherButton;

    public var exitButton:LauncherButton;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic(Paths.png("assets/images/globals/retroCursor")).bitmap);

        launcher = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.png("assets/images/menus/LauncherScreen/launcher")));

        launcher.active = false;

        launcher.scale.set(1.5, 1.5);

        launcher.updateHitbox();

        launcher.screenCenter();

        add(launcher);

        playButton = new LauncherButton(0.0, 0.0, "playButton");

        playButton.onClick.add(() -> playSlapSound(clickPlayButton));

        playButton.onClick.add(clearClickSignals);

        playButton.setPosition(launcher.x + 15.0, launcher.y + launcher.height - playButton.height - 15.0);

        add(playButton);

        discordButton = new LauncherButton(0.0, 0.0, "discordButton");

        discordButton.onClick.add(() -> playSlapSound(clickDiscordButton));

        discordButton.setPosition(launcher.getMidpoint().x - discordButton.width * 0.5, launcher.y + launcher.height - discordButton.height - 15.0);

        add(discordButton);

        exitButton = new LauncherButton(0.0, 0.0, "exitButton");

        exitButton.onClick.add(() -> playSlapSound(clickExitButton));

        exitButton.onClick.add(clearClickSignals);

        exitButton.setPosition(launcher.x + launcher.width - exitButton.width - 15.0, launcher.y + launcher.height - exitButton.height - 15.0);

        add(exitButton);

        tune = FlxG.sound.load(Assets.getSound(Paths.ogg("assets/music/menus/LauncherScreen/tune")));

        tune.play();
    }

    public function playSlapSound(onComplete:()->Void):Void
    {
        FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/globals/slap")), 1.0, false, null, true, onComplete);
    }

    public function clickPlayButton():Void
    {
        FlxG.switchState(() -> new #if debug TitleScreen #else LogoScreen #end ());
    }

    public function clickDiscordButton():Void
    {
        FlxG.openURL("https://discord.gg/kxhTqTy2gU");
    }

    public function clickExitButton():Void
    {
        Sys.exit(0);
    }

    public function clearClickSignals():Void
    {
        playButton.onClick.removeAll();

        discordButton.onClick.removeAll();

        exitButton.onClick.removeAll();
    }
}

class LauncherButton extends FlxSprite
{
    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, _path:String):Void
    {
        super(x, y);

        onClick = new FlxSignal();

        loadGraphic(Assets.getGraphic(Paths.png('assets/images/menus/LauncherScreen/${_path}')), true, 83, 15);

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
            animation.play("1");

            if (FlxG.mouse.justPressed)
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