package menus.options;

import openfl.geom.Rectangle;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Paths;

import menus.options.items.BaseOptionItem;
import menus.options.pages.BaseOptionsPage;

using util.MathUtil;

class OptionsTooltip extends FlxSpriteGroup
{
    public var options:BaseOptionsPage;

    public var hover:BaseOptionItem;

    public var panel:FlxSprite;

    public var tooltipText:FlxText;

    public function new(options:BaseOptionsPage):Void
    {
        super();

        this.options = options;

        panel = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/options/OptionsTooltip/panel"));

        add(panel);

        tooltipText = new FlxText(0.0, 0.0, 0.0, "", 24);

        tooltipText.color = FlxColor.BLACK;

        tooltipText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        tooltipText.alignment = CENTER;

        add(tooltipText);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        for (option in options.optionsGroup)
        {
            if (FlxG.mouse.overlaps(option.titleText, camera))
            {
                visible = true;

                if (hover == option)
                    break;

                hover = option;

                updateTooltip(hover);

                break;
            }
            else
                visible = false;
        }

        var newX:Float = FlxG.mouse.x + FlxG.mouse.cursor.width * 0.5 - width * 0.5;

        newX = FlxMath.bound(newX, InitState.mouseRectPlugin.left, InitState.mouseRectPlugin.right - width);

        var newY:Float = FlxG.mouse.y - height - 25.0;

        newY = FlxMath.bound(newY, InitState.mouseRectPlugin.top, InitState.mouseRectPlugin.bottom - height);

        setPosition(newX, newY);
    }

    public function updateTooltip(tooltip:BaseOptionItem = null):Void
    {
        if (tooltip == null)
            tooltipText.text = "Unrecognized tooltip.";
        else
            tooltipText.text = tooltip.tooltip;

        var panelWidth:Int = Math.floor(tooltipText.width) + 32;

        var panelHeight:Int = Math.floor(tooltipText.height) + 8;

        var rectWidth:Int = panelWidth - 8;

        var rectHeight:Int = panelHeight - 8;

        panel.makeGraphic(panelWidth, panelHeight, 0xFFC80F10);

        panel.pixels.fillRect(new Rectangle(4, 4, rectWidth, rectHeight), 0xFFFFFFFF);

        tooltipText.centerTo(panel);
    }
}