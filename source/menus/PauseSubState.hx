package menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

import core.Assets;
import core.Paths;

import data.Chart;

import game.PlayState;

using util.ArrayUtil;

class PauseSubState extends FlxSubState
{
    public var chart:Chart;

    public var iconText:FlxText;

    public var pauseIcons:FlxTypedGroup<PauseMenuIcon>;

    public function new(_chart:Chart):Void
    {
        super();

        chart = _chart;
    }

    override function create():Void
    {
        super.create();

        camera = FlxG.cameras.list.newest();

        var background:FlxSprite = new FlxSprite();

        background.active = false;

        background.alpha = 0.0;

        background.makeGraphic(1, 1, FlxColor.BLACK);

        background.scale.set(FlxG.width, FlxG.height);

        background.updateHitbox();
        
        add(background);

        FlxTween.tween(background, {alpha: 0.65}, 0.6, {ease: FlxEase.quartIn});

        var separator:FlxSprite = new FlxSprite();

        separator.makeGraphic(1, 1, FlxColor.WHITE);

        separator.active = false;

        separator.alpha = 0.0;

        separator.scale.set(FlxG.width, 15.0);
        
        separator.updateHitbox();

        separator.screenCenter();

        add(separator);

        FlxTween.tween(separator, {alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var pausedText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "PAUSED?!");

        pausedText.font = Paths.ttf("assets/fonts/Comic Sans MS");

        pausedText.size = 48;

        pausedText.alignment = CENTER;

        pausedText.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.5);

        pausedText.textField.antiAliasType = ADVANCED;

        pausedText.textField.sharpness = 400.0;

        pausedText.setPosition((FlxG.width - pausedText.width) * 0.5, (FlxG.height - pausedText.height) * 0.5 - 250.0);

        add(pausedText);

        var nameText:FlxText = new FlxText(0.0, 0.0, FlxG.width, "");

        nameText.alpha = 0.5;

        nameText.text = chart.name;

        nameText.font = Paths.ttf("assets/fonts/Comic Sans MS");

        nameText.size = 42;

        nameText.alignment = CENTER;

        nameText.textField.antiAliasType = ADVANCED;

        nameText.textField.sharpness = 400.0;

        nameText.setPosition((FlxG.width - nameText.width) * 0.5, (FlxG.height - nameText.height) * 0.5 + 150.0);

        add(nameText);

        iconText = new FlxText(0.0, 0.0, FlxG.width, "");

        iconText.alpha = 0.5;

        iconText.text = chart.name;

        iconText.font = Paths.ttf("assets/fonts/Comic Sans MS");

        iconText.size = 42;

        iconText.alignment = CENTER;

        iconText.textField.antiAliasType = ADVANCED;

        iconText.textField.sharpness = 400.0;

        iconText.setPosition((FlxG.width - iconText.width) * 0.5, (FlxG.height - iconText.height) * 0.5 - 150.0);

        add(iconText);

        pauseIcons = new FlxTypedGroup<PauseMenuIcon>();

        add(pauseIcons);

        var resumeIcon:PauseMenuIcon = new PauseMenuIcon(0.0, 0.0, "resumeIcon");

        resumeIcon.camera = camera;

        resumeIcon.active = false;

        resumeIcon.alpha = 0.0;

        resumeIcon.onSelect.add(() -> iconText.text = "Resume");

        resumeIcon.onClick.add(close);

        resumeIcon.setPosition(-resumeIcon.width, (FlxG.height - resumeIcon.height) * 0.5);

        pauseIcons.add(resumeIcon);

        FlxTween.tween(resumeIcon, {x: 50.0, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var quitIcon:PauseMenuIcon = new PauseMenuIcon(0.0, 0.0, "quitIcon");

        quitIcon.camera = camera;

        quitIcon.active = false;

        quitIcon.alpha = 0.0;

        quitIcon.onSelect.add(() -> iconText.text = "Quit");

        quitIcon.onClick.add(() -> FlxG.switchState(() -> new TitleScreen()));

        quitIcon.setPosition(-quitIcon.width, (FlxG.height - quitIcon.height) * 0.5);

        pauseIcons.add(quitIcon);

        FlxTween.tween(quitIcon, {x: 1007.5, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var optionsIcon:PauseMenuIcon = new PauseMenuIcon(0.0, 0.0, "optionsIcon");

        optionsIcon.camera = camera;

        optionsIcon.active = false;

        optionsIcon.alpha = 0.0;

        optionsIcon.onSelect.add(() -> iconText.text = "Options");

        optionsIcon.onClick.add(() -> FlxG.switchState(() -> new OptionsMenu()));

        optionsIcon.setPosition(-optionsIcon.width, (FlxG.height - optionsIcon.height) * 0.5);

        pauseIcons.add(optionsIcon);

        FlxTween.tween(optionsIcon, {x: 347.5, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        var restartIcon:PauseMenuIcon = new PauseMenuIcon(0.0, 0.0, "restartIcon");

        restartIcon.camera = camera;

        restartIcon.active = false;

        restartIcon.alpha = 0.0;

        restartIcon.onSelect.add(() -> iconText.text = "Restart");

        restartIcon.onClick.add(PlayState.continueWeek);

        restartIcon.setPosition(-restartIcon.width, (FlxG.height - restartIcon.height) * 0.5);

        pauseIcons.add(restartIcon);

        FlxTween.tween(restartIcon, {x: 710.5, alpha: 1.0}, 1.0, {ease: FlxEase.quartOut});

        FlxTimer.wait(1.0, () ->
        {
            resumeIcon.active = true;

            quitIcon.active = true;

            optionsIcon.active = true;

            restartIcon.active = true;
        });
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!FlxG.mouse.overlaps(pauseIcons, camera))
            iconText.text = "";

        if (FlxG.keys.justPressed.ESCAPE)
            close();
    }
}

class PauseMenuIcon extends FlxSprite
{
    public var selected:Bool;

    public var onSelect:FlxSignal;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, _path:String):Void
    {
        super(x, y, Assets.getGraphic(Paths.png('assets/images/menus/PauseSubState/${_path}')));

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

        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}