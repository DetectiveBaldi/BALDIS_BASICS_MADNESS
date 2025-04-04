package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

import extendable.ResourceState;

import menus.options.OptionsMenu;

class MainMenuScreen extends ResourceState
{
    public var pattern:FlxBackdrop;

    public var chalkboard:FlxSprite;

    public var exitButton:FlxSprite;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic(Paths.image(Paths.png("globals/defaultCursor"))).bitmap);

        pattern = new FlxBackdrop(Assets.getGraphic(Paths.image(Paths.png("menus/MainMenuScreen/pattern"))));

        pattern.velocity.set(10.0, 10.0);

        add(pattern);

        chalkboard = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.image(Paths.png("menus/MainMenuScreen/chalkboard"))));

        chalkboard.scale.set(2.2, 2.2);

        chalkboard.updateHitbox();

        chalkboard.screenCenter();

        add(chalkboard);

        var playText:MenuText = createText("Play!", () -> FlxG.switchState(() -> new ModeSelectScreen()));

        playText.onClick.remove(fadeMusic);

        playText.setPosition((FlxG.width - playText.width) * 0.5, chalkboard.y + 185.0);

        var optionsText:MenuText = createText("Options", () -> FlxG.switchState(() -> new OptionsMenu(() -> new MainMenuScreen())));

        optionsText.setPosition((FlxG.width - optionsText.width) * 0.5, playText.y + playText.height + 50.0);

        var aboutText:MenuText = createText("About", () -> FlxG.switchState(() -> new AboutScreen()));

        aboutText.setPosition((FlxG.width - aboutText.width) * 0.5, optionsText.y + optionsText.height + 50.0);

        aboutText.onClick.remove(fadeMusic);

        var creditsText:MenuText = createText("Credits", () -> FlxG.switchState(() -> new CreditsScreen()));

        creditsText.setPosition((FlxG.width - creditsText.width) * 0.5, aboutText.y + aboutText.height + 50.0);

        exitButton = new FlxSprite();

        exitButton.loadGraphic(Assets.getGraphic(Paths.image(Paths.png("menus/MainMenuScreen/exitButton"))), true, 32, 32);

        exitButton.animation.add("0", [0], 0.0, false);

        exitButton.animation.add("1", [1], 0.0, false);

        exitButton.animation.play("0");

        exitButton.scale.set(2.0, 2.0);

        exitButton.updateHitbox();

        exitButton.setPosition(10.0, 10.0);

        add(exitButton);

        playMusic();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("1");

            if (FlxG.mouse.justPressed)
            {
                fadeMusic();

                FlxG.switchState(() -> new TitleScreen());
            }
        }
        else
            exitButton.animation.play("0");
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function createText(text:String, onClick:()->Void):MenuText
    {
        var text:MenuText = new MenuText(0.0, 0.0, text);

        text.onClick.add(fadeMusic);

        text.onClick.add(onClick);

        add(text);

        return text;
    }

    public static function playMusic():Void
    {
        if (FlxG.sound.music != null)
            return;

        FlxG.sound.playMusic(Assets.getSound(Paths.music(Paths.ogg("menus/MainMenuScreen/tune"))));
    }

    public static function fadeMusic():Void
    {
        FlxG.sound.music.fadeOut(0.25, 0.0, stopMusic);
    }

    public static function stopMusic(tween:FlxTween):Void
    {
        FlxG.sound.music.stop();

        FlxG.sound.music = null;
    }
}

class MenuText extends FlxText
{
    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, text:String):Void
    {
        super(x, y, 0.0, text);

        onClick = new FlxSignal();

        font = Paths.font(Paths.ttf("Comic Sans MS"));

        size = 42;

        alignment = CENTER;

        textField.antiAliasType = ADVANCED;

        textField.sharpness = 400.0;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            color = 0xFF00DC00;

            underline = true;

            if (FlxG.mouse.justPressed)
                onClick.dispatch();
        }
        else
        {
            color = FlxColor.WHITE;

            underline = false;
        }
    }

    override function destroy():Void
    {
        super.destroy();

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}