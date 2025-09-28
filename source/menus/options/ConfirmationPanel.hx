package menus.options;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

import core.AssetCache;
import core.Paths;

import util.ClickSoundUtil;

using util.MathUtil;

class ConfirmationPanel extends FlxSpriteGroup
{
    public var panel:FlxSprite;

    public var headerText:FlxText;

    public var bodyText:FlxText;

    public var confirmButton:FlxSprite;

    public var confirmText:FlxText;

    public var closeButton:FlxSprite;

    public var onClick:FlxSignal;

    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        panel = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("menus/options/ConfirmationPanel/panel"));

        add(panel);

        headerText = new FlxText(0.0, 0.0, panel.width);

        headerText.text = "Warning!";

        headerText.size = 12;

        headerText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        add(headerText);

        bodyText = new FlxText(0.0, 0.0, 192.0);

        var text:String = "The following action is IRREVERSIBLE.";

        text += " Any data tampered with here can never be recovered!";

        text += " Are you SURE you want to do this?";

        bodyText.text = text;

        bodyText.size = 12;

        bodyText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        bodyText.centerTo(panel);

        bodyText.x += 25.0;

        add(bodyText);

        confirmButton = new FlxSprite(0.0, 0.0);

        confirmButton.loadGraphic(AssetCache.getGraphic("menus/options/ConfirmationPanel/button-sheet"), true, 111, 33);

        confirmButton.animation.add("unselected", [0], 0.0, false);

        confirmButton.animation.add("selected", [1], 0.0, false);

        confirmButton.animation.play("unselected");

        confirmButton.scale.set(0.5, 0.5);

        confirmButton.updateHitbox();

        confirmButton.setPosition(panel.x + panel.width - confirmButton.width - 3.0,
            panel.y + panel.height - confirmButton.height - 3.0);

        add(confirmButton);

        confirmText = new FlxText();

        confirmText.text = "Confirm";

        confirmText.size = 12;

        confirmText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        confirmText.centerTo(confirmButton);

        add(confirmText);

        onClick = new FlxSignal();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(confirmButton, camera))
        {
            if (FlxG.mouse.pressed)
                confirmButton.animation.play("selected");
            else
                confirmButton.animation.play("unselected");

            if (FlxG.mouse.justReleased)
            {
                onClick.dispatch();

                FlxG.sound.play(AssetCache.getSound("shared/notebook-respawn"));

                ClickSoundUtil.play();
            }
        }
        else
            confirmButton.animation.play("unselected");
    }

    override function destroy():Void
    {
        onClick = cast FlxDestroyUtil.destroy(onClick);
    }
}