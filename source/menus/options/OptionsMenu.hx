package menus.options;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import flixel.util.typeLimit.NextState;

import api.DiscordHandler;

import core.AssetCache;
import core.Paths;
import core.SaveManager;

import extendable.TransitionState;

import menus.options.items.BaseOptionItem;
import menus.options.items.VariableOptionItem;
import menus.options.pages.GeneralOptionsPage;
import menus.options.pages.BaseOptionsPage;
import menus.options.pages.ControlsPage;
import menus.options.pages.GameplayOptionsPage;
import menus.options.pages.SavesOptionsPage;
import menus.options.pages.TestingOptionsPage;

import ui.BackOutButton;
import ui.OrientedButton;

using util.ArrayUtil;
using util.MathUtil;

class OptionsMenu extends TransitionState
{
    public static var pageIndex:Int = 0;

    public var nextState:NextState;

    public var fadeTuneOnExit:Bool;

    public var background:FlxSprite;

    public var chalkboard:FlxSprite;

    public var optionTools:OptionTools;

    public var optionPages:FlxTypedGroup<BaseOptionsPage>;

    public var pageLabel:FlxText;

    public var goLeftButton:OrientedButton;

    public var goRightButton:OrientedButton;

    public var tooltip:OptionsTooltip;

    public var backOutButton:BackOutButton;

    public function new(_nextState:NextState, _fadeTuneOnExit:Bool = true):Void
    {
        super();

        nextState = _nextState;

        fadeTuneOnExit = _fadeTuneOnExit;
    }

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        DiscordHandler.setState(null);

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        DiscordHandler.setImageTexts(null, null);

        background = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.scale.set(960.0, FlxG.height);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        chalkboard = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/chalkboard"));

        chalkboard.scale.set(2.25, 2.25);

        chalkboard.updateHitbox();

        chalkboard.screenCenter();

        add(chalkboard);

        optionTools = new OptionTools();

        optionTools.set("erase-options", eraseOptions);

        optionPages = new FlxTypedGroup<BaseOptionsPage>();

        add(optionPages);

        addPage(GeneralOptionsPage);

        addPage(ControlsPage);

        addPage(GameplayOptionsPage);

        addPage(SavesOptionsPage);

        addPage(TestingOptionsPage);
        
        pageLabel = new FlxText(0.0, 0.0, 0.0, "", 36);

        pageLabel.color = FlxColor.WHITE;

        pageLabel.font = Paths.font(Paths.ttf("Comic Sans MS"));

        pageLabel.alignment = LEFT;

        pageLabel.setPosition(chalkboard.x + 165.0, chalkboard.y + 150.0);

        add(pageLabel);

        goLeftButton = addOrientedButton(LEFT, () -> setPage(pageIndex - 1));

        goLeftButton.scale.set(2.0, 2.0);

        goLeftButton.updateHitbox();

        goLeftButton.setPosition(chalkboard.x + 150.0, chalkboard.y + chalkboard.height - goLeftButton.height - 150.0);

        goRightButton = addOrientedButton(RIGHT, () -> setPage(pageIndex + 1));

        goRightButton.scale.set(2.0, 2.0);

        goRightButton.updateHitbox();

        goRightButton.setPosition(chalkboard.x + chalkboard.width - goRightButton.width - 150.0,
            chalkboard.y + chalkboard.height - goRightButton.height - 150.0);

        tooltip = new OptionsTooltip(null);

        add(tooltip);

        setPage(pageIndex);

        backOutButton = new BackOutButton();

        backOutButton.onClick.add(clickBackOutButton);

        backOutButton.setPosition(165.0, 5.0);

        add(backOutButton);

        MainMenuScreen.playTune();
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function addPage<T:BaseOptionsPage>(cls:Class<T>, args:Array<Dynamic> = null):Void
    {
        args ??= [optionTools];

        var page:T = Type.createInstance(cls, args);

        optionPages.add(page);
    }

    public function setPage(newIndex:Int):Void
    {
        SaveManager.saveOptions();

        pageIndex = FlxMath.wrap(newIndex, 0, optionPages.members.length - 1);

        for (page in optionPages)
        {
            page.exists = false;

            page.cancelTouch();
        }

        var newPage:BaseOptionsPage = optionPages.members[pageIndex];

        newPage.exists = true;

        pageLabel.text = newPage.name;

        tooltip.options = newPage;
    }

    public function eraseOptions():Void
    {
        for (i in 0 ... optionPages.members.length)
        {
            var group:OptionsGroup = optionPages.members[i].optionsGroup;

            for (j in 0 ... group.members.length)
            {
                var option:BaseOptionItem = group.members[j];

                if (option is VariableOptionItem)
                {
                    var varOption:VariableOptionItem<Dynamic> = cast option;

                    varOption.setValue(varOption.getValue());
                }
            }
        }
    }

    public function clickBackOutButton():Void
    {
        FlxG.switchState(nextState);

        SaveManager.saveOptions();

        if (fadeTuneOnExit)
            MainMenuScreen.fadeTune();
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }
}

class OptionTools
{
    public var listeners:Map<String, ()->Void>;

    public function new():Void
    {
        listeners = new Map<String, ()->Void>();
    }

    public function has(key:String):Bool
    {
        return listeners.exists(key);
    }

    public function set(key:String, val:()->Void):Void
    {
        listeners[key] = val;
    }

    public function dispatch(key:String):Void
    {
        if (!has(key))
            return;

        listeners[key]();
    }
}