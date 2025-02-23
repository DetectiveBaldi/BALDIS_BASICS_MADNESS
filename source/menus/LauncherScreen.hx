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
    public var background:FlxSprite;

    public var playButton:LauncherButton;

    public var discordButton:LauncherButton;

    public var exitButton:LauncherButton;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic(Paths.png("assets/images/globals/retroCursor")).bitmap);

        background = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.png("assets/images/menus/LauncherScreen/background")));

        background.active = false;

        background.scale.set(1.5, 1.5);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        playButton = new LauncherButton(0.0, 0.0, "playButton0");

        playButton.onClick.add(() -> playSlapSound(clickPlayButton));

        playButton.setPosition(background.x + 15.0, background.y + background.height - playButton.height - 15.0);

        add(playButton);

        discordButton = new LauncherButton(0.0, 0.0, "discordButton");

        discordButton.onClick.add(() -> playSlapSound(clickDiscordButton));

        discordButton.setPosition(background.getMidpoint().x - discordButton.width * 0.5, background.y + background.height - discordButton.height - 15.0);

        add(discordButton);

        exitButton = new LauncherButton(0.0, 0.0, "exitButton0");

        exitButton.onClick.add(() -> playSlapSound(clickExitButton));

        exitButton.setPosition(background.x + background.width - exitButton.width - 15.0, background.y + background.height - exitButton.height - 15.0);

        add(exitButton);

        tune = FlxG.sound.load(Assets.getSound(Paths.ogg("assets/music/menus/LauncherScreen/tune")));

        tune.play();
    }

    public function playSlapSound(onComplete:()->Void):Void
    {
        FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/globals/slap")), 1.0, false, null, true, onComplete);

        playButton.onClick.removeAll();

        discordButton.onClick.removeAll();

        exitButton.onClick.removeAll();
    }

    public function clickPlayButton():Void
    {
        FlxG.switchState(() -> new LogoScreen());
    }

    public function clickDiscordButton():Void
    {
        FlxG.openURL("https://discord.gg/kxhTqTy2gU");
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