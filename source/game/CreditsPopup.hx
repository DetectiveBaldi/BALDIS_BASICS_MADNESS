package game;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxTimer;

import core.Assets;
import core.Options;
import core.Paths;

import data.Chart.CreditsData;

using util.MathUtil;

class CreditsPopup extends FlxSpriteGroup
{
    public var tween:FlxTweenManager;

    public var timer:FlxTimerManager;

    public var credits:CreditsData;

    public var screen:FlxSprite;

    public var label:FlxText;

    public function new(x:Float = 0.0, y:Float = 0.0, ?tween:FlxTweenManager, ?timer:FlxTimerManager, credits:CreditsData):Void
    {
        super(x, y);

        this.tween = tween ?? FlxTween.globalManager;

        this.timer = timer ?? FlxTimer.globalManager;

        this.credits = credits;

        screen = new FlxSprite(0.0, 0.0, Assets.getGraphic("game/CreditsPopup/screen"));
        
        screen.active = false;

        add(screen);

        label = new FlxText(0.0, 0.0, screen.width);

        label.visible = false;

        label.size = 24;

        label.font = Paths.font(Paths.ttf("Comic Sans MS"));

        label.alignment = CENTER;

        label.textField.antiAliasType = ADVANCED;

        label.textField.sharpness = 400.0;

        label.setPosition(label.getCenterX(screen), label.getCenterY(screen) + 20.0);

        add(label);

        setPosition(this.getCenterX(), Options.downscroll ? -height : FlxG.height);
    }

    public function popUp():Void
    {
        tween.tween(this, {y: Options.downscroll ? 0.0 : FlxG.height - height}, 1.25, 
            {ease: FlxEase.quartOut});

        new FlxTimer(timer).start(2.0, (tmr:FlxTimer) ->
        {
            tween.tween(this, {y: Options.downscroll ? -height : FlxG.height}, 2.0, 
               {ease: FlxEase.quartIn, onComplete: (twn:FlxTween) -> kill()});

            tween.flicker(label, 2.0, 0.5);

            label.text = 'Composer: ${credits.composer}';
        });
    }
}