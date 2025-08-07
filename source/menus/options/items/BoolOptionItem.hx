package menus.options.items;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Paths;

using util.MathUtil;

class BoolOptionItem extends VariableOptionItem<Bool>
{
    public var checkContainer:FlxSprite;

    public var checkbox:FlxSprite;

    public function new(_x:Float = 0.0, _y:Float = 0.0, _title:String, _description:String, _option:String):Void
    {
        super(_x, _y, _title, _description, _option);

        checkContainer = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/options/items/BoolOptionItem/checkContainer"));

        checkContainer.scale.set(3.0, 3.0);

        checkContainer.updateHitbox();

        checkContainer.setPosition(titleText.x + titleText.width + 16.0, checkContainer.getCenterY(titleText));

        add(checkContainer);

        checkbox = new FlxSprite().loadGraphic(AssetCache.getGraphic("shared/numpad-indicators"), true, 24, 24);

        checkbox.visible = value;

        checkbox.animation.add("check", [0], 0.0, true);

        checkbox.scale.set(2.5, 2.5);

        checkbox.updateHitbox();

        checkbox.offset.set(-22.0, -6.0);

        checkbox.centerTo(checkContainer);

        add(checkbox);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this, camera))
        {
            titleText.underline = true;

            if (FlxG.mouse.justReleased)
            {
                value = !value;

                checkbox.visible = value;
            }
        }
        else
            titleText.underline = false;
    }
}