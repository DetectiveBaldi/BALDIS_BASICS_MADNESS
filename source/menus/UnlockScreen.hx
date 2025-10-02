package menus;

import openfl.geom.Rectangle;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxPoint;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;

import flixel.addons.display.FlxBackdrop;

import api.DiscordHandler;

import core.AssetCache;
import core.Paths;

import data.LevelData;
import data.WeekData;

import extendable.TransitionState;

import interfaces.ISequenceHandler;

import ui.BaldiHeads;

using util.MathUtil;

class UnlockScreen extends TransitionState implements ISequenceHandler
{
    public var nextState:NextState;

    public var params:Array<UnlockScreenParams>;

    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;

    public var baldi:BaldiHeads;

    public function new(nextState:NextState, params:Array<UnlockScreenParams>):Void    
    {
        super();

        this.nextState = nextState;

        this.params = params;
    }

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);

        InitState.setMouseRect(160.0, FlxG.width - 160.0, 0.0, FlxG.height);

        DiscordHandler.setState("You got something special!");

        DiscordHandler.setDetails("In the menus...");

        DiscordHandler.setImageKeys(null, "in-menu-small-image-key");

        tweens = new FlxTweenManager();

        add(tweens);

        timers = new FlxTimerManager();

        add(timers);

        var background:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        background.active = false;

        background.scale.set(FlxG.width, FlxG.height);

        background.updateHitbox();

        background.centerTo();

        add(background);

        baldi = new BaldiHeads();

        baldi.screenCenter();

        add(baldi);

        var text:String = 'Wowee! You just unlocked\n${params[0].unlock}';

        var wowText:FlxText = new FlxText(0.0, 0.0, 0.0, text, 60);

        wowText.color = 0xFF0EF403;

        wowText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        wowText.bold = true;

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

        params.shift();

        new FlxTimer(timers).start(5.0, (_:FlxTimer) ->
        {
            if (params.length == 0.0)
            {
                FlxG.switchState(nextState);

                return;
            }

            FlxG.switchState(() -> new UnlockScreen(nextState, params));
        });
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }
}

typedef UnlockScreenParams =
{
    var unlock:String;
}