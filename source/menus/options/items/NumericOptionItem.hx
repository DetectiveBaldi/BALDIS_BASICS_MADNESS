package menus.options.items;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import core.AssetCache;
import core.Paths;

import ui.OrientedButton;

using util.MathUtil;

class IntOptionItem extends VariableOptionItem<Int>
{
    public var min:Int;

    public var max:Int;

    public var step:Int;

    public var valueText:FlxText;

    public var cells:FlxSpriteGroup;

    public var leftButton:OrientedButton;

    public var rightButton:OrientedButton;

    public function new(_x:Float = 0.0, _y:Float = 0.0, _title:String, _tooltip:String, _option:String,
        _min:Int, _max:Int, _step:Int, cellsToGenerate:Int):Void
    {
        super(_x, _y, _title, _tooltip, _option);

        min = _min;

        max = _max;

        step = _step;

        valueText = new FlxText(0.0, 0.0, 0.0, "", 42);

        valueText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        add(valueText);

        updateValueText();

        cells = new FlxSpriteGroup();

        for (i in 0 ... cellsToGenerate)
        {
            var cell:FlxSprite = new FlxSprite().loadGraphic(AssetCache.getGraphic("menus/options/items/IntOptionItem/cells"), true,
                8, 32);

            cell.animation.add("off", [0], 0.0, false);

            cell.animation.add("on", [1], 0.0, false);

            cell.animation.play("off");

            cell.scale.set(1.75, 1.75);

            cell.updateHitbox();

            cell.x = 18 * i;

            cells.add(cell);
        }

        cells.setPosition(titleText.x + titleText.width + 60.0, cells.getCenterY(titleText));

        add(cells);

        powerCells();

        leftButton = addOrientedButton(LEFT, () ->
        {
            value = Std.int(FlxMath.bound(value - step, min, max));

            powerCells();

            updateValueText();
        });

        leftButton.scale.set(1.85, 1.85);

        leftButton.updateHitbox();

        leftButton.setPosition(cells.x - leftButton.width, leftButton.getCenterY(titleText));

        add(leftButton);

        rightButton = addOrientedButton(RIGHT, () ->
        {
            value = Std.int(FlxMath.bound(value + step, min, max));

            powerCells();

            updateValueText();
        });

        rightButton.scale.set(1.85, 1.85);

        rightButton.updateHitbox();

        rightButton.setPosition(cells.x + cells.width, rightButton.getCenterY(titleText));

        add(rightButton);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        titleText.underline = FlxG.mouse.overlaps(titleText, camera);
    }

    public function updateValueText():Void
    {
        valueText.text = '<- ${value}';

        valueText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        valueText.setPosition(titleText.x + titleText.width + 265.0, valueText.getCenterY(titleText));
    }

    public function powerCells():Void
    {
        for (i in 0 ... cells.members.length)
        {
            var cell:FlxSprite = cells.members[i];

            var stepMult:Int = step * (i + 1);

            cell.animation.play(stepMult <= value ? "on" : "off");
        }
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
    }
}

/**
 * Not implemented yet.
 */
typedef FloatOptionItem = IntOptionItem;