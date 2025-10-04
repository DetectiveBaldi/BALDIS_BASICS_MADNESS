package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.FlxGraphic;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import api.DiscordHandler;

import extendable.TransitionState;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.LevelData;
import data.WeekData;

import game.HighScore;
import game.PlayState;

import util.ClickSoundUtil;

using util.ArrayUtil;
using util.MathUtil;

class TitleScreen extends TransitionState
{
    public var title:FlxSprite;

    public var rulerHitbox:FlxSprite;

    public var exitButton:TitleButton;

    public var playButton:TitleButton;

    public var studioText:FlxText;

    public var versionText:FlxText;

    public var introSound:FlxSound;

    public var exitSound:FlxSound;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);
        
        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        DiscordHandler.setState(null);

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        DiscordHandler.setImageTexts(null, null);

        title = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/TitleScreen/title"));

        title.active = false;

        title.scale.set(2.0, 2.0);

        title.updateHitbox();

        title.setPosition(title.getCenterX(), 0.0);

        add(title);

        rulerHitbox = new FlxSprite(0.0, 0.0).makeGraphic(1, 1, FlxColor.TRANSPARENT);

        rulerHitbox.active = false;

        rulerHitbox.visible = false;

        rulerHitbox.scale.set(22.0, 21.0);

        rulerHitbox.updateHitbox();

        rulerHitbox.setPosition(544.0, 238.0);

        add(rulerHitbox);

        playButton = new TitleButton(0.0, 0.0, "playButton");

        playButton.onClick.add(clickPlayButton);

        playButton.setPosition(700.0, 500.0);

        add(playButton);

        exitButton = new TitleButton(0.0, 0.0, "exitButton");

        exitButton.onClick.add(clickExitButton);

        exitButton.setPosition(title.x, title.y + title.height - exitButton.height);

        add(exitButton);

        studioText = new FlxText(0.0, 0.0, FlxG.width, "2025 MamaCita's");

        studioText.color = FlxColor.BLACK;

        studioText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        studioText.size = 42;

        studioText.alignment = RIGHT;

        studioText.setPosition(title.x + title.width - studioText.width - 5.0, title.y + title.height - studioText.height - 5.0);

        add(studioText);

        versionText = new FlxText(0.0, 0.0, FlxG.width, 'Version ${FlxG.stage.application.meta["version"]}');

        versionText.color = 0xCECECE;

        versionText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        versionText.size = 24;

        versionText.alignment = LEFT;

        versionText.setPosition(165.0, 5.0);

        add(versionText);

        introSound = FlxG.sound.load(AssetCache.getSound("menus/TitleScreen/introSound"));

        introSound.play();

        exitSound = FlxG.sound.load(AssetCache.getSound("menus/TitleScreen/exitSound"));

        exitSound.onComplete = getTransitionSprite.bind(0.5, OUT, () -> Sys.exit(0));

        tune = FlxG.sound.load(AssetCache.getMusic("menus/TitleScreen/tune"));

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.visible && FlxG.mouse.overlaps(rulerHitbox) && #if debug true #else
            !Options.botplay && HighScore.getWeekScore(WeekData.list[0].name, "Normal").score != 0.0 &&
                HighScore.getLevelScore("Two", "Normal").score == 0.0 #end )
        {
            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
            {
                TransitionState.cancelNextTransition();

                var levelToLoad:LevelData = LevelData.list.first((lv:LevelData) -> lv.name == "Two");

                PlayState.loadLevel(levelToLoad, {nextState: () -> new TitleScreen()});
            }
        }
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function clickPlayButton():Void
    {
        FlxG.switchState(() -> new MainMenuScreen());
    }

    public function clickExitButton():Void
    {
        FlxG.mouse.visible = false;

        exitButton.active = false;

        playButton.active = false;
        
        exitSound.play();
    }
}

class TitleButton extends FlxSprite
{
    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, _path:String):Void
    {
        super(x, y);

        onClick = new FlxSignal();

        var _graphic:FlxGraphic = AssetCache.getGraphic('menus/TitleScreen/${_path}');

        loadGraphic(_graphic, true, Math.floor(_graphic.width * 0.5), 64);

        animation.add("0", [0], 0.0, false);

        animation.add("1", [1], 0.0, false);

        scale.set(2.0, 2.0);

        updateHitbox();

        animation.play("0");
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            animation.play("1");

            if (FlxG.mouse.justReleased)
            {
                ClickSoundUtil.play();

                onClick.dispatch();
            }
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