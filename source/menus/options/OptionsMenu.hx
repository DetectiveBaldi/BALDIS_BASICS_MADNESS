package menus.options;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import flixel.util.typeLimit.NextState;

import core.Assets;
import core.Paths;

import extendable.CustomState;

import menus.FreeplayScreen.ButtonOrientation;
import menus.FreeplayScreen.OrientedButton;
import menus.options.categories.GeneralOptionsCat;
import menus.options.categories.BaseOptionsCat;
import menus.options.categories.ControlsCat;
import menus.options.categories.GameplayOptionsCat;

using util.ArrayUtil;
using util.MathUtil;

class OptionsMenu extends CustomState
{
    public var nextState:NextState;

    public var background:FlxSprite;

    public var chalkboard:FlxSprite;

    public var optionCategories:FlxTypedGroup<BaseOptionsCat>;

    public var categoryIndex:Int;

    public var categoryLabel:FlxText;

    public var goRightButton:FlxSprite;

    public var tooltip:OptionsTooltip;

    public var exitButton:FlxSprite;

    public function new(_nextState:NextState):Void
    {
        super();

        nextState = _nextState;
    }

    override function create():Void
    {
        super.create();

        FlxG.camera.bgColor = FlxColor.BLACK;

        FlxG.mouse.visible = true;

        FlxG.mouse.load(Assets.getGraphic("shared/cursor-default").bitmap);

        mouseRect = FlxRect.get(160.0, 0.0, FlxG.width - FlxG.mouse.cursorContainer.width - 160.0, FlxG.height);

        background = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.scale.set(960.0, FlxG.height);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        chalkboard = new FlxSprite(0.0, 0.0, Assets.getGraphic("shared/chalkboard"));

        chalkboard.scale.set(2.25, 2.25);

        chalkboard.updateHitbox();

        chalkboard.screenCenter();

        add(chalkboard);

        optionCategories = new FlxTypedGroup<BaseOptionsCat>();

        add(optionCategories);

        var optCat:BaseOptionsCat = new GeneralOptionsCat();

        optionCategories.add(optCat);

        optCat = new ControlsCat();
        
        optionCategories.add(optCat);

        optCat = new GameplayOptionsCat();

        optionCategories.add(optCat);

        categoryIndex = 0;

        categoryLabel = new FlxText(0.0, 0.0, 0.0, "", 36);

        categoryLabel.color = FlxColor.WHITE;

        categoryLabel.font = Paths.font(Paths.ttf("Comic Sans MS"));

        categoryLabel.textField.antiAliasType = ADVANCED;

        categoryLabel.textField.sharpness = 400.0;

        categoryLabel.alignment = LEFT;

        categoryLabel.setPosition(chalkboard.x + 165.0, chalkboard.y + 150.0);

        add(categoryLabel);

        goRightButton = addOrientedButton(RIGHT, () ->
        {
            setCategory(categoryIndex, categoryIndex = FlxMath.wrap(categoryIndex + 1, 0, optionCategories.length - 1));
        });

        goRightButton.scale.set(2.0, 2.0);

        goRightButton.updateHitbox();

        goRightButton.setPosition(chalkboard.x + chalkboard.width - goRightButton.width - 150.0,
            chalkboard.y + chalkboard.height - goRightButton.height - 150.0);

        tooltip = new OptionsTooltip(null);

        add(tooltip);

        setCategory(0, 0);

        exitButton = new FlxSprite();

        exitButton.loadGraphic(Assets.getGraphic("menus/MainMenuScreen/exitButton"), true, 32, 32);

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

            if (FlxG.mouse.justPressed)
                FlxG.switchState(nextState);
        }
        else
            exitButton.animation.play("0");
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function setCategory(oldIndex:Int, newIndex:Int):Void
    {
        var oldCategory:BaseOptionsCat = optionCategories.members[oldIndex];

        for (i in 0 ... oldCategory.members.length)
            oldCategory.members[i].cancelTouch();

        var newCategory:BaseOptionsCat = optionCategories.members[newIndex];

        for (i in 0 ... optionCategories.members.length)
        {
            var category:BaseOptionsCat = optionCategories.members[i];

            var enabled:Bool = newCategory == category;

            category.active = enabled;

            category.visible = enabled;
        }

        categoryLabel.text = newCategory.name;

        tooltip.options = newCategory;
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }
}