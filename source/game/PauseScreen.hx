package game;

import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

import core.Assets;
import core.Options;
import core.Paths;

import extendable.CustomSubState;

import game.PlayState;

import menus.FreeplayScreen;
import menus.StoryMenuScreen;
import menus.options.OptionsMenu;

using util.ArrayUtil;
using util.MathUtil;

class PauseScreen extends CustomSubState
{
    public var game:PlayState;

    public var camLerp:Float;

    public var mouseVis:Bool;

    public static var blur:BlurFilter;

    public var iconText:FlxText;

    public var pauseIcons:FlxTypedGroup<PauseScreenIcon>;

    public var tune:FlxSound;

    public function new(_game:PlayState):Void
    {
        super();

        game = _game;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.last();

        FlxG.mouse.load(Assets.getGraphic("shared/cursor-default").bitmap);

        camLerp = FlxG.camera.followLerp;

        mouseVis = FlxG.mouse.visible;

        FlxG.camera.followLerp = 0.0;

        FlxG.mouse.visible = true;

        if (Options.shaders)
        {
            blur ??= new BlurFilter(0.0, 0.0, 0);

            blur.blurX = 0.0;

            blur.blurY = 0.0;

            blur.quality = 0;

            tween.tween(blur, {blurX: 5.0, blurY: 5.0, quality: 1}, 0.65, {ease: FlxEase.quartIn});

            game.gameCamera.filters ??= new Array<BitmapFilter>();

            game.hudCamera.filters ??= new Array<BitmapFilter>();

            game.gameCamera.filters.push(blur);

            game.hudCamera.filters.push(blur);
        }

        var background:FlxSprite = new FlxSprite();

        background.active = false;

        background.alpha = 0.0;

        background.makeGraphic(1, 1, FlxColor.BLACK);

        background.scale.set(FlxG.width, FlxG.height);

        background.updateHitbox();
        
        add(background);

        tween.tween(background, {alpha: 0.65}, 0.65, {ease: FlxEase.quartIn});

        var separator:FlxSprite = new FlxSprite();

        separator.makeGraphic(1, 1, FlxColor.WHITE);

        separator.active = false;

        separator.alpha = 0.0;

        separator.scale.set(FlxG.width, 15.0);
        
        separator.updateHitbox();

        separator.screenCenter();

        add(separator);

        tween.tween(separator, {alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var pausedText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "PAUSED?!");

        pausedText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        pausedText.size = 48;

        pausedText.alignment = CENTER;

        pausedText.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.5);

        pausedText.textField.antiAliasType = ADVANCED;

        pausedText.textField.sharpness = 400.0;

        pausedText.setPosition(pausedText.getCenterX(), pausedText.getCenterY() - 250.0);

        add(pausedText);

        var nameText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "");

        nameText.alpha = 0.5;

        nameText.text = game.chart.name;

        nameText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        nameText.size = 42;

        nameText.alignment = CENTER;

        nameText.textField.antiAliasType = ADVANCED;

        nameText.textField.sharpness = 400.0;

        nameText.setPosition(nameText.getCenterX(), nameText.getCenterY() + 150.0);

        add(nameText);

        iconText = new FlxText(0.0, 0.0, FlxG.width, "");

        iconText.alpha = 0.5;

        iconText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        iconText.size = 42;

        iconText.alignment = CENTER;

        iconText.textField.antiAliasType = ADVANCED;

        iconText.textField.sharpness = 400.0;

        iconText.setPosition(iconText.getCenterX(), iconText.getCenterY() - 150.0);

        add(iconText);

        pauseIcons = new FlxTypedGroup<PauseScreenIcon>();

        add(pauseIcons);

        var resumeIcon:PauseScreenIcon = createIcon("resumeIcon", "Resume", game.resume);

        tween.tween(resumeIcon, {x: 50.0, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var quitIcon:PauseScreenIcon = createIcon("quitIcon", "Quit", () -> 
        {
            if (PlayState.isWeek)
                FlxG.switchState(() -> new StoryMenuScreen());
            else
                FlxG.switchState(() -> new FreeplayScreen());
        });

        tween.tween(quitIcon, {x: 1007.5, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var optionsIcon:PauseScreenIcon = createIcon("optionsIcon", "Options", () -> FlxG.switchState(() -> new OptionsMenu(() -> PlayState.getLevelClass())));

        tween.tween(optionsIcon, {x: 347.5, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var restartIcon:PauseScreenIcon = createIcon("restartIcon", "Restart", () -> FlxG.switchState(() -> PlayState.getLevelClass()));

        tween.tween(restartIcon, {x: 710.5, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        FlxTimer.wait(1.0, () ->
        {
            resumeIcon.active = true;

            quitIcon.active = true;

            optionsIcon.active = true;

            restartIcon.active = true;
        });

        tune = FlxG.sound.load(Assets.getMusic("game/PauseScreen/tune"), 1.0, true);

        tune.volume = 0.0;

        tune.play();

        tune.fadeIn(1.0, 0.0, 0.5);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!FlxG.mouse.overlaps(pauseIcons, camera))
            iconText.text = "";

        if (FlxG.keys.justPressed.ESCAPE)
            close();
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.camera.followLerp = camLerp;

        FlxG.mouse.visible = mouseVis;

        if (Options.shaders)
        {
            blur.blurX = 0.0;

            blur.blurY = 0.0;

            blur.quality = 0;
        }

        tune.stop();
    }

    public function createIcon(path:String, text:String, onClick:()->Void):PauseScreenIcon
    {
        var icon:PauseScreenIcon = new PauseScreenIcon(path);

        icon.camera = camera;

        icon.active = false;

        icon.alpha = 0.0;

        icon.onSelect.add(() -> iconText.text = text);

        icon.onClick.add(close);

        icon.onClick.add(onClick);

        icon.setPosition(-icon.width, icon.getCenterY());

        pauseIcons.add(icon);

        return icon;
    }
}

class PauseScreenIcon extends FlxSprite
{
    public var selected:Bool;

    public var onSelect:FlxSignal;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, _path:String):Void
    {
        super(x, y, Assets.getGraphic('game/PauseScreen/${_path}'));

        selected = false;

        onSelect = new FlxSignal();

        onClick = new FlxSignal();

        scale.set(1.25, 1.25);

        updateHitbox();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            scale.x = FlxMath.lerp(scale.x, 1.5, FlxMath.getElapsedLerp(0.15, elapsed));

            scale.y = FlxMath.lerp(scale.y, 1.5, FlxMath.getElapsedLerp(0.15, elapsed));

            if (!selected)
                onSelect.dispatch();

            selected = true;

            if (FlxG.mouse.justPressed)
                onClick.dispatch();
        }
        else
        {
            scale.x = FlxMath.lerp(scale.x, 1.25, FlxMath.getElapsedLerp(0.15, elapsed));

            scale.y = FlxMath.lerp(scale.y, 1.25, FlxMath.getElapsedLerp(0.15, elapsed));

            selected = false;
        }
    }

    override function destroy():Void
    {
        super.destroy();

        onSelect = cast FlxDestroyUtil.destroy(onSelect);

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}