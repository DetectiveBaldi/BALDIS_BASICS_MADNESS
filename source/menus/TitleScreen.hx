package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.FlxGraphic;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import effects.TransitionState;

import core.Assets;
import core.Paths;

import data.WeekData;

import game.PlayState;

class TitleScreen extends TransitionState
{
    public var title:FlxSprite;

    public var exitButton:TitleButton;

    public var playButton:TitleButton;

    public var studio:FlxText;

    public var introSound:FlxSound;

    public var tune:FlxSound;

    override function create():Void
    {
        super.create();

        title = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.png("assets/images/menus/TitleScreen/title")));

        title.active = false;

        title.scale.set(2.0, 2.0);

        title.updateHitbox();

        title.setPosition((FlxG.width - title.width) * 0.5, 0.0);

        add(title);

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

        studio = new FlxText(0.0, 0.0, FlxG.width, "©2025 MamaCita's");

        studio.color = FlxColor.BLACK;

        studio.font = Paths.ttf("assets/fonts/Comic Sans MS");

        studio.size = 42;

        studio.alignment = RIGHT;

        studio.textField.antiAliasType = ADVANCED;

        studio.textField.sharpness = 400;

        studio.setPosition(title.x + title.width - studio.width - 5.0, title.y + title.height - studio.height - 5.0);

        add(studio);

        introSound = FlxG.sound.load(Assets.getSound(Paths.ogg("assets/sounds/menus/TitleScreen/introSound")));

        introSound.play();

        tune = FlxG.sound.load(Assets.getSound(Paths.ogg("assets/music/menus/TitleScreen/tune")));

        tune.play();
    }

    public function clickPlayButton():Void
    {
        PlayState.loadWeek(WeekData.get("week1"));
    }

    public function clickExitButton():Void
    {
        FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/TitleScreen/exitSound")), 1.0, false, null, true, () -> Sys.exit(0));
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

        var _graphic:FlxGraphic = Assets.getGraphic(Paths.png('assets/images/menus/TitleScreen/${_path}'));

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