package menus.options;

import openfl.geom.Rectangle;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.util.FlxColor;

import core.Assets;
import core.Paths;

import menus.options.items.BaseOptionItem;
import menus.options.categories.BaseOptionsCat;

using util.MathUtil;

class OptionsTooltip extends FlxSpriteGroup
{
    public var options:BaseOptionsCat;

    public var lastHover:BaseOptionItem;

    public var panel:FlxSprite;

    public var descText:FlxText;

    public function new(_options:BaseOptionsCat):Void
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
        visible = FlxG.mouse.overlaps(options);

        setPosition(FlxG.mouse.x + FlxG.mouse.cursor.width * 0.5 - width * 0.5, FlxG.mouse.y - height - 25.0);

        for (i in 0 ... options.members.length)
        {
            var option:FlxBasic = options.members[i];

            if (!(option is BaseOptionItem))
                continue;

            if (FlxG.mouse.overlaps(option))
            {
                if (lastHover == option)
                    break;

                lastHover = cast option;

                updateTooltip(lastHover);

                break;
            }
        }
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