package menus.options.items;

import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import core.Assets;

import ui.OrientedButton;

using util.MathUtil;

class IntOptionItem extends VariableOptionItem<Int>
{
    public var min:Int;

    public var max:Int;

    public var step:Int;

    public var leftButton:OrientedButton;

    public var cells:FlxSpriteGroup;

    public var rightButton:OrientedButton;

    public function new(_x:Float = 0.0, _y:Float = 0.0, _title:String, _description:String, _option:String,
        _min:Int, _max:Int, _step:Int, cellsToGenerate:Int):Void
    {
        super(_x, _y, _title, _description, _option);

        min = _min;

        max = _max;

        step = _step;

        leftButton = addOrientedButton(LEFT, () ->
        {
            value = Std.int(FlxMath.bound(value - step, min, max));

            powerCells();
        });

        leftButton.scale.set(1.85, 1.85);

        leftButton.updateHitbox();

        leftButton.setPosition(titleText.x + titleText.width + 5.0, leftButton.getCenterY(titleText));

        add(leftButton);

        cells = new FlxSpriteGroup();

        for (i in 0 ... cellsToGenerate)
        {
            var cell:FlxSprite = new FlxSprite().loadGraphic(Assets.getGraphic("menus/options/items/IntOptionItem/cells"), true,
                8, 32);

            cell.animation.add("off", [0], 0.0, false);

            cell.animation.add("on", [1], 0.0, false);

            cell.animation.play("off");

            cell.scale.set(1.75, 1.75);

            cell.updateHitbox();

            cell.x = 18 * i;

            cells.add(cell);
        }

        cells.setPosition(leftButton.x + leftButton.width, cells.getCenterY(titleText));

        add(cells);

        rightButton = addOrientedButton(RIGHT, () ->
        {
            value = Std.int(FlxMath.bound(value + step, min, max));

            powerCells();
        });

        rightButton.scale.set(1.85, 1.85);

        rightButton.updateHitbox();

        rightButton.setPosition(cells.x + cells.width, rightButton.getCenterY(titleText));

        add(rightButton);

        powerCells();
    }

    public function addOrientedButton(orientation:ButtonOrientation, onClick:()->Void):OrientedButton
    {
        var button:OrientedButton = new OrientedButton(0.0, 0.0, orientation);

        button.onClick.add(onClick);

        add(button);

        return button;
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
}