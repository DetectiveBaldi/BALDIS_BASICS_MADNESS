package menus;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import flixel.addons.display.FlxBackdrop;

import core.AssetCache;
import core.Paths;

import extendable.CustomState;

using util.MathUtil;

class ModeSelectScreen extends CustomState
{
    public var background:FlxSprite;

    public var nameText:FlxText;

    public var iconText:FlxText;

    public var modeIcons:FlxTypedGroup<ModeSelectIcon>;

    public var exitButton:FlxSprite;

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        background = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.scale.set(960.0, FlxG.height);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        nameText = new FlxText(0.0, 0.0, FlxG.width, "");

        nameText.color = FlxColor.BLACK;

        nameText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        nameText.size = 36;

        nameText.alignment = CENTER;

        nameText.setBorderStyle(OUTLINE, FlxColor.BLACK, 0.5);

        nameText.textField.antiAliasType = ADVANCED;

        nameText.textField.sharpness = 400.0;

        nameText.setPosition(nameText.getCenterX(), nameText.getCenterY() + 150.0);

        add(nameText);

        iconText = new FlxText(0.0, 0.0, FlxG.width, "");

        iconText.color = FlxColor.BLACK;

        iconText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        iconText.size = 36;

        iconText.alignment = CENTER;

        iconText.textField.antiAliasType = ADVANCED;

        iconText.textField.sharpness = 400.0;

        iconText.setPosition(iconText.getCenterX(), nameText.y + nameText.height);

        add(iconText);

        modeIcons = new FlxTypedGroup<ModeSelectIcon>();

        add(modeIcons);

        var text:String = "Sing with Baldi and his";

        text += "\nfriends as you explore";

        text += "\nthe schoolhouse!";

        var storyIcon:ModeSelectIcon = createIcon("story-icon", "Story Mode", text, () -> FlxG.switchState(() -> new
            StoryMenuScreen()));

        storyIcon.onClick.remove(MainMenuScreen.fadeTune);

        storyIcon.setPosition(365.0, storyIcon.getCenterY() - 100.0);

        text = "Discover the rest of";

        text += "\nBaldi's schoolhouse";

        text += "\ncompanions!";

        var freeplayIcon:ModeSelectIcon = createIcon("freeplayIcon", "Freeplay Mode", text, () -> FlxG.switchState(() -> 
            new FreeplayScreen()));

        freeplayIcon.onClick.remove(MainMenuScreen.fadeTune);

        freeplayIcon.setPosition((FlxG.width - freeplayIcon.width) - 365.0 + 112.0, freeplayIcon.getCenterY() - 100.0);

        exitButton = new FlxSprite();

        exitButton.loadGraphic(AssetCache.getGraphic("menus/MainMenuScreen/exitButton"), true, 32, 32);

        exitButton.animation.add("0", [0], 0.0, false);

        exitButton.animation.add("1", [1], 0.0, false);

        exitButton.animation.play("0");

        exitButton.scale.set(2.0, 2.0);

        exitButton.updateHitbox();

        exitButton.setPosition(165.0, 5.0);

        add(exitButton);

        MainMenuScreen.playTune();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!FlxG.mouse.overlaps(modeIcons, camera))
        {
            nameText.text = "";

            iconText.text = "";
        }

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("1");

            if (FlxG.mouse.justPressed)
                FlxG.switchState(() -> new MainMenuScreen());
        }
        else
            exitButton.animation.play("0");
    }

    public function createIcon(path:String, name:String, text:String, onClick:()->Void):ModeSelectIcon
    {
        var icon:ModeSelectIcon = new ModeSelectIcon(0.0, 0.0, path);

        icon.onSelect.add(() ->
        {
            nameText.text = name;

            iconText.text = text;
        });

        icon.onClick.add(MainMenuScreen.fadeTune);

        icon.onClick.add(onClick);

        modeIcons.add(icon);

        return icon;
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }
}

class ModeSelectIcon extends FlxSprite
{
    public var selected:Bool;

    public var onSelect:FlxSignal;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, _path:String):Void
    {
        super(x, y);

        selected = false;

        onSelect = new FlxSignal();

        onClick = new FlxSignal();

        loadGraphic(AssetCache.getGraphic('menus/ModeSelectScreen/${_path}'), true, 128, 192);

        animation.add("0", [0], 0.0, false);

        animation.add("1", [1], 0.0, false);

        animation.play("0");

        scale.set(2.0, 2.0);

        updateHitbox();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            animation.play("1");

            if (!selected)
                onSelect.dispatch();

            selected = true;

            if (FlxG.mouse.justPressed)
                onClick.dispatch();
        }
        else
        {
            animation.play("0");

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