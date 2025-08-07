package menus.options;

import openfl.geom.Rectangle;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.Assets;
import core.Paths;

import menus.options.items.BaseOptionItem;
import menus.options.pages.BaseOptionsPage;

using util.MathUtil;

class OptionsTooltip extends FlxSpriteGroup
{
    public var options:BaseOptionsPage;

    public var lastHover:BaseOptionItem;

    public var panel:FlxSprite;

    public var descText:FlxText;

    public function new(_options:BaseOptionsPage):Void
    {
        super();

        options = _options;

        panel = new FlxSprite(0.0, 0.0, Assets.getGraphic("menus/options/OptionsTooltip/panel"));

        add(panel);

        descText = new FlxText(0.0, 0.0, 0.0, "", 24);

        descText.color = FlxColor.BLACK;

        descText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        descText.textField.antiAliasType = ADVANCED;

        descText.textField.sharpness = 400.0;

        descText.alignment = CENTER;

        add(descText);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        for (i in 0 ... options.members.length)
        {
            var option:BaseOptionItem = options.members[i];

            if (FlxG.mouse.overlaps(option))
            {
                if (lastHover == option)
                    break;

                lastHover = option;

                updateTooltip(lastHover);

                break;
            }
        }
        
        visible = FlxG.mouse.overlaps(options);

        var newX:Float = FlxG.mouse.x + FlxG.mouse.cursor.width * 0.5 - width * 0.5;

        newX = FlxMath.bound(newX, InitState.mouseRectPlugin.left, InitState.mouseRectPlugin.right - width);

        var newY:Float = FlxG.mouse.y - height - 25.0;

        newY = FlxMath.bound(newY, InitState.mouseRectPlugin.top, InitState.mouseRectPlugin.bottom - height);

        setPosition(newX, newY);
    }

    public function updateTooltip(option:BaseOptionItem = null):Void
    {
        if (option == null)
            descText.text = "Unrecognized option.";
        else
            descText.text = option.description;

        var panelWidth:Int = Math.floor(descText.width) + 32;

        var panelHeight:Int = Math.floor(descText.height) + 8;

        var rectWidth:Int = panelWidth - 8;

        var rectHeight:Int = panelHeight - 8;

        panel.makeGraphic(panelWidth, panelHeight, 0xFFC80F10);

        panel.pixels.fillRect(new Rectangle(4, 4, rectWidth, rectHeight), 0xFFFFFFFF);

        descText.centerTo(panel);
    }
}