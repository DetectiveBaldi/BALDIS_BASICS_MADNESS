package menus.options.items;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Paths;

import menus.options.OptionsMenu.OptionTools;

import util.ClickSoundUtil;

using util.MathUtil;

class BoolOptionItem extends VariableOptionItem<Bool>
{
    public var editable:Bool;

    public var checkContainer:FlxSprite;

    public var checkbox:FlxSprite;

    public var strikethrough:FlxSprite;

    public function new(x:Float = 0.0, y:Float = 0.0, title:String, tooltip:String, option:String, optionTools:OptionTools):Void
    {
        super(x, y, title, tooltip, option, optionTools);

        editable = true;

        checkContainer = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/options/items/BoolOptionItem/checkContainer"));

        checkContainer.active = false;

        checkContainer.scale.set(3.0, 3.0);

        checkContainer.updateHitbox();

        checkContainer.setPosition(titleText.x + titleText.width + 16.0, checkContainer.getCenterY(titleText));

        add(checkContainer);

        checkbox = new FlxSprite().loadGraphic(AssetCache.getGraphic("shared/numpad-indicators"), true, 24, 24);

        checkbox.active = false;

        checkbox.visible = value;

        checkbox.animation.add("check", [0], 0.0, true);

        checkbox.scale.set(2.5, 2.5);

        checkbox.updateHitbox();

        checkbox.offset.set(-22.0, -6.0);

        checkbox.centerTo(checkContainer);

        add(checkbox);

        strikethrough = new FlxSprite().makeGraphic(Math.floor(titleText.width), 3, FlxColor.WHITE);

        strikethrough.active = false;

        strikethrough.visible = false;

        strikethrough.centerTo(titleText);

        add(strikethrough);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(titleText, camera))
        {
            titleText.underline = true;

            strikethrough.visible = !editable;

            if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight) && editable)
            {
                ClickSoundUtil.play();
                
                setValue(!value);
            }
        }
        else
        {
            titleText.underline = false;

            strikethrough.visible = false;
        }
    }

    override function setValue(val:Bool):Void
    {
        super.setValue(val);

        checkbox.visible = value;
    }
}