package menus;

import openfl.geom.Rectangle;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.text.FlxText;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

import flixel.addons.display.FlxBackdrop;

import core.AssetCache;
import core.Paths;

import data.LevelData;
import data.WeekData;

import extendable.CustomState;

using util.MathUtil;

class UnlockScreen extends CustomState
{
    public var nextState:NextState;

    public var week:WeekData;

    public var level:LevelData;

    public function new(nextState:NextState, week:WeekData, level:LevelData):Void    
    {
        super();

        this.nextState = nextState;

        this.week = week;

        this.level = level;
    }

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        var background:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.active = false;

        background.scale.set(FlxG.width, FlxG.height);

        background.updateHitbox();

        background.centerTo();

        add(background);

        var baldi:FlxBackdrop = new FlxBackdrop(AssetCache.getGraphic("menus/BaldiHeads"));

        baldi.active = true;

        baldi.velocity.set(100.0, 50.0);

        add(baldi);

        var text:String = "Wow! You just unlocked\n";

        if (week == null)
            text += level.name;
        else
            text += week.name + week.nameSuffix;

        text += ".";

        var wowText:FlxText = new FlxText(0.0, 0.0, 0.0, text, 60);

        wowText.color = 0xFF0EF403;

        wowText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        wowText.bold = true;

        wowText.textField.antiAliasType = ADVANCED;

        wowText.textField.sharpness = 400.0;

        wowText.alignment = CENTER;

        wowText.centerTo();

        add(wowText);

        var foreground:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

        foreground.active = false;

        var rectToFill:Rectangle = new Rectangle(0.0, 0.0, 160.0, FlxG.height);

        foreground.pixels.fillRect(rectToFill, 0xFF000000);

        rectToFill.setTo(FlxG.width - 160.0, 0.0, 160.0, FlxG.height);

        foreground.pixels.fillRect(rectToFill, 0xFF000000);

        foreground.centerTo();

        add(foreground);

        FlxG.sound.play(AssetCache.getSound("menus/baldi-wow"), 1.0, false);

        new FlxTimer(timer).start(5.0, (_:FlxTimer) -> FlxG.switchState(nextState));
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }
}