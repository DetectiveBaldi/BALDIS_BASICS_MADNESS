package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.FlxGraphic;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import extendable.CustomState;

import core.AssetCache;
import core.Paths;

import data.LevelData;

import game.PlayState;

import util.ClickSoundUtil;

using util.ArrayUtil;
using util.MathUtil;

class TitleScreen extends CustomState
{
    public var title:FlxSprite;

    public var rulerHitbox:FlxSprite;

    public var exitButton:TitleButton;

    public var playButton:TitleButton;

    public var studio:FlxText;

    public var introSound:FlxSound;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);
        
        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

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

        playButton.onClick.add(clickButton);

        playButton.setPosition(700.0, 500.0);

        add(playButton);

        exitButton = new TitleButton(0.0, 0.0, "exitButton");

        exitButton.onClick.add(clickExitButton);

        exitButton.onClick.add(clickButton);

        exitButton.setPosition(title.x, title.y + title.height - exitButton.height);

        add(exitButton);

        studio = new FlxText(0.0, 0.0, FlxG.width, "2025 MamaCita's");

        studio.color = FlxColor.BLACK;

        studio.font = Paths.font(Paths.ttf("Comic Sans MS"));

        studio.size = 42;

        studio.alignment = RIGHT;

        studio.textField.antiAliasType = ADVANCED;

        studio.textField.sharpness = 400.0;

        studio.setPosition(title.x + title.width - studio.width - 5.0, title.y + title.height - studio.height - 5.0);

        add(studio);

        introSound = FlxG.sound.load(AssetCache.getSound("menus/TitleScreen/introSound"));

        introSound.play();

        tune = FlxG.sound.load(AssetCache.getMusic("menus/TitleScreen/tune"));

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(rulerHitbox))
        {
            if (FlxG.mouse.justReleased)
            {
                CustomState.cancelNextTransition();

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
        FlxG.sound.play(AssetCache.getSound("menus/TitleScreen/exitSound"), 1.0, false, null, true, () -> Sys.exit(0));
    }

    public function clickButton():Void
    {
        playButton.onClick.removeAll();
        
        exitButton.onClick.removeAll();
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