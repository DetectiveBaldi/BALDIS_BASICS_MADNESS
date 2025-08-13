package menus.options;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import flixel.util.typeLimit.NextState;

import core.AssetCache;
import core.Paths;

import extendable.CustomState;

import menus.options.pages.GeneralOptionsPage;
import menus.options.pages.BaseOptionsPage;
import menus.options.pages.ControlsPage;
import menus.options.pages.GameplayOptionsPage;

import ui.OrientedButton;

using util.ArrayUtil;
using util.MathUtil;

class OptionsMenu extends CustomState
{
    public var nextState:NextState;

    public var fadeTuneOnExit:Bool;

    public var background:FlxSprite;

    public var chalkboard:FlxSprite;

    public var optionPages:FlxTypedGroup<BaseOptionsPage>;

    public var pageIndex:Int;

    public var pageLabel:FlxText;

    public var goRightButton:FlxSprite;

    public var tooltip:OptionsTooltip;

    public var exitButton:FlxSprite;

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

        optionPages = new FlxTypedGroup<BaseOptionsPage>();

        add(optionPages);

        var optionPage:BaseOptionsPage = new GeneralOptionsPage();

        optionPages.add(optionPage);

        optionPage = new ControlsPage();
        
        optionPages.add(optionPage);

        optionPage = new GameplayOptionsPage();

        optionPages.add(optionPage);

        pageIndex = 0;

        pageLabel = new FlxText(0.0, 0.0, 0.0, "", 36);

        pageLabel.color = FlxColor.WHITE;

        pageLabel.font = Paths.font(Paths.ttf("Comic Sans MS"));

        pageLabel.textField.antiAliasType = ADVANCED;

        pageLabel.textField.sharpness = 400.0;

        pageLabel.alignment = LEFT;

        pageLabel.setPosition(chalkboard.x + 165.0, chalkboard.y + 150.0);

        add(pageLabel);

        goRightButton = addOrientedButton(RIGHT, () ->
        {
            setPage(pageIndex, pageIndex = FlxMath.wrap(pageIndex + 1, 0, optionPages.length - 1));
        });

        goRightButton.scale.set(2.0, 2.0);

        goRightButton.updateHitbox();

        goRightButton.setPosition(chalkboard.x + chalkboard.width - goRightButton.width - 150.0,
            chalkboard.y + chalkboard.height - goRightButton.height - 150.0);

        tooltip = new OptionsTooltip(null);

        add(tooltip);

        setPage(0, 0);

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

        if (FlxG.mouse.overlaps(exitButton, camera))
        {
            exitButton.animation.play("1");

            if (FlxG.mouse.justReleased)
            {
                FlxG.switchState(nextState);

                if (fadeTuneOnExit)
                    MainMenuScreen.fadeTune();
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

    public function setPage(oldIndex:Int, newIndex:Int):Void
    {
        var oldPage:BaseOptionsPage = optionPages.members[oldIndex];

        for (i in 0 ... oldPage.members.length)
            oldPage.members[i].cancelTouch();

        var newPage:BaseOptionsPage = optionPages.members[newIndex];

        for (i in 0 ... optionPages.members.length)
        {
            var page:BaseOptionsPage = optionPages.members[i];

            var enabled:Bool = newPage == page;

            page.active = enabled;

            page.visible = enabled;
        }

        pageLabel.text = newPage.name;

        tooltip.options = newPage;
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }
}