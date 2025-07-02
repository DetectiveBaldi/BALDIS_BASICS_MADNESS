package menus.options;

import core.Options;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import flixel.util.typeLimit.NextState;

import core.Assets;
import core.Paths;

import extendable.CustomState;

import menus.options.categories.BaseOptionsCat;
import menus.options.categories.WindowOptionsCat;

using util.ArrayUtil;
using util.MathUtil;

class OptionsMenu extends CustomState
{
    public var nextState:NextState;

    public var background:FlxSprite;

    public var clipboard:FlxSprite;

    public var optionCategories:FlxTypedGroup<BaseOptionsCat>;

    public var categoryIndex:Int;

    public var categoryLabel:FlxText;

    public var goLeftButton:FlxSprite;

    public var goRightButton:FlxSprite;

    public var tooltip:OptionsTooltip;

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

        background = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.scale.set(960.0, FlxG.height);

        background.updateHitbox();

        background.screenCenter();

        add(background);

        clipboard = new FlxSprite(0.0, 0.0, Assets.getGraphic("shared/clipboard"));

        clipboard.scale.set(3.5, 3.5);

        clipboard.updateHitbox();

        clipboard.x = clipboard.getCenterX();

        add(clipboard);

        optionCategories = new FlxTypedGroup<BaseOptionsCat>();

        add(optionCategories);

        var windowCat:WindowOptionsCat = new WindowOptionsCat();

        optionCategories.add(windowCat);

        categoryIndex = 0;

        categoryLabel = new FlxText(0.0, 0.0, "", 42);

        categoryLabel.color = FlxColor.BLACK;

        categoryLabel.font = Paths.font(Paths.ttf("Comic Sans MS"));

        categoryLabel.textField.antiAliasType = ADVANCED;

        categoryLabel.textField.sharpness = 400.0;

        categoryLabel.alignment = CENTER;

        add(categoryLabel);

        tooltip = new OptionsTooltip(null);

        add(tooltip);

        setCategory();
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function setCategory():Void
    {
        var newCategory:BaseOptionsCat = optionCategories.members[categoryIndex];

        for (i in 0 ... optionCategories.members.length)
        {
            var category:BaseOptionsCat = optionCategories.members[i];

            var enabled:Bool = newCategory == category;

            category.active = enabled;

            category.visible = enabled;
        }

        categoryLabel.text = newCategory.name;

        categoryLabel.setPosition(categoryLabel.getCenterX(clipboard), 160.0);

        tooltip.options = newCategory;
    }
}