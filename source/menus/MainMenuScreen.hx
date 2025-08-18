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

import core.AssetCache;
import core.Paths;

import extendable.CustomState;

import menus.options.OptionsMenu;

import ui.MenuText;

using util.MathUtil;

class MainMenuScreen extends CustomState
{
    public static var tune:FlxSound;

    public var background:FlxSprite;

    public var chalkboard:FlxSprite;

    public var exitButton:FlxSprite;

    override function create():Void
    {
        super.create();

        playTune();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        background = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.scale.set(960.0, FlxG.height);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        chalkboard = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/MainMenuScreen/chalkboard"));

        chalkboard.scale.set(2.2, 2.2);

        chalkboard.updateHitbox();

        chalkboard.screenCenter();

        add(chalkboard);

        var playText:MenuText = createText("Play!", () -> FlxG.switchState(() -> new ModeSelectScreen()));

        playText.onClick.remove(fadeTune);

        playText.setPosition(playText.getCenterX(), chalkboard.y + 185.0);

        var optionsText:MenuText = createText("Options", () -> FlxG.switchState(() -> new OptionsMenu(() -> new MainMenuScreen(), false)));

        optionsText.onClick.remove(fadeTune);

        optionsText.setPosition(optionsText.getCenterX(), playText.y + playText.height + 50.0);

        var aboutText:MenuText = createText("About", () -> FlxG.switchState(() -> new AboutScreen()));

        aboutText.setPosition(aboutText.getCenterX(), optionsText.y + optionsText.height + 50.0);

        aboutText.onClick.remove(fadeTune);

        var creditsText:MenuText = createText("Credits", () -> FlxG.switchState(() -> new CreditsScreen()));

        creditsText.setPosition(creditsText.getCenterX(), aboutText.y + aboutText.height + 50.0);

        exitButton = new FlxSprite();

        exitButton.loadGraphic(AssetCache.getGraphic("menus/MainMenuScreen/exitButton"), true, 32, 32);

        exitButton.animation.add("0", [0], 0.0, false);

        exitButton.animation.add("1", [1], 0.0, false);

        exitButton.animation.play("0");

        exitButton.scale.set(2.0, 2.0);

        exitButton.updateHitbox();

        exitButton.setPosition(165.0, 5.0);

        add(exitButton);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("1");

            if (FlxG.mouse.justReleased)
            {
                fadeTune();

                FlxG.switchState(() -> new TitleScreen());
            }
        }
        else
            exitButton.animation.play("0");

        #if debug
        if (FlxG.keys.justPressed.EIGHT)
        {
            fadeTune();
            
            FlxG.switchState(() -> new editors.CharacterEditorState(() -> new MainMenuScreen()));
        }
        #end
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function createText(text:String, onClick:()->Void):MenuText
    {
        var text:MenuText = new MenuText(0.0, 0.0, text);

        text.onClick.add(fadeTune);

        text.onClick.add(onClick);

        add(text);

        return text;
    }

    public static function playTune():Void
    {
        if (tune != null)
            return;

        tune = FlxG.sound.load(AssetCache.getMusic("menus/MainMenuScreen/tune"), 1.0, true);

        tune.persist = true;

        tune.play();
    }

    public static function fadeTune():Void
    {
        tune.fadeOut(0.25, 0.0, stopTune);
    }

    public static function stopTune(tween:FlxTween):Void
    {
        tune.stop();

        tune = null;
    }
}