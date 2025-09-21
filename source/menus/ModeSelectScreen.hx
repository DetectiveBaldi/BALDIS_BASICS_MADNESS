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

import data.WeekData;

import extendable.CustomState;

import game.HighScore;

import ui.BackOutButton;

import util.ClickSoundUtil;

using util.MathUtil;

class ModeSelectScreen extends CustomState
{
    public var background:FlxSprite;

    public var nameText:FlxText;

    public var iconText:FlxText;

    public var modeIcons:FlxTypedGroup<ModeSelectIcon>;

    public var backOutButton:BackOutButton;

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

        var storyIcon:ModeSelectIcon = createIcon("story-icon", "Story", text, () -> FlxG.switchState(() -> new
            StoryMenuScreen()));

        storyIcon.onClick.remove(MainMenuScreen.fadeTune);

        storyIcon.setPosition(285.0, storyIcon.getCenterY() - 100.0);

        text = "Discover the rest of";

        text += "\nBaldi's schoolhouse";

        text += "\ncompanions!";

        var freeplayIcon:ModeSelectIcon = createIcon("freeplayIcon", "Freeplay", text, () -> FlxG.switchState(() -> 
            new FreeplayScreen()));

        var scoresValidated:Bool = #if debug true #else HighScore.getWeekScore(WeekData.list[0].name, "Normal").score != 0.0 #end ;

        if (!scoresValidated)
            freeplayIcon.lock(true);

        freeplayIcon.onClick.remove(MainMenuScreen.fadeTune);

        freeplayIcon.setPosition(freeplayIcon.getCenterX() + 56.0, freeplayIcon.getCenterY() - 100.0);

        text = "Dig and discover the secrets";

        text += "\nthat lie within";

        text += "\nHere School...";

        var mysteryIcon:ModeSelectIcon = createIcon("mystery-icon", "Mystery", text, () -> FlxG.switchState(() -> 
            new MysteryScreen()));

        if (!scoresValidated)
            mysteryIcon.lock(true);

        mysteryIcon.setPosition(FlxG.width - mysteryIcon.width - 285.0 + 112.0, mysteryIcon.getCenterY() - 100.0);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(FlxG.switchState.bind(() -> new MainMenuScreen()));

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

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
    }

    public function createIcon(path:String, name:String, text:String, onClick:()->Void):ModeSelectIcon
    {
        var icon:ModeSelectIcon = new ModeSelectIcon(0.0, 0.0, path);

        icon.onSelect.add(() ->
        {
            nameText.text = '${icon.locked ? "???" : name} Mode';

            iconText.text = icon.locked ? "This mode is locked!" : text;
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
    public var file:String;

    public var locked:Bool;

    public var selected:Bool;

    public var onSelect:FlxSignal;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0, file:String):Void
    {
        super(x, y);

        this.file = file;

        lock(false);

        selected = false;

        onSelect = new FlxSignal();

        onClick = new FlxSignal();
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

            if (FlxG.mouse.justReleased)
            {
                if (locked)
                    FlxG.sound.play(AssetCache.getSound("shared/locked-door-rattle"));
                else
                {
                    ClickSoundUtil.play();

                    onClick.dispatch();
                }
            }
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

    public function lock(value:Bool):Void
    {
        locked = value;

        loadGraphic(AssetCache.getGraphic('menus/ModeSelectScreen/${locked ? "lockedIcon" : file}'), true, 128, 192);

        animation.add("0", [0], 0.0, false);

        animation.add("1", [1], 0.0, false);

        animation.play("0");

        scale.set(2.0, 2.0);

        updateHitbox();

        if (locked)
            FlxG.sound.play(AssetCache.getSound("shared/door-unlock"));
    }
}