package game;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxTimer;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.Chart.CreditsData;

import interfaces.ISequenceHandler;

using util.MathUtil;

class CreditsPopup extends FlxSpriteGroup
{
    public var tweens:FlxTweenManager;

    public var timers:FlxTimerManager;

    public var credits:CreditsData;

    public var screen:FlxSprite;

    public var label:FlxText;

    public function new(x:Float = 0.0, y:Float = 0.0, sequenceHandler:ISequenceHandler, credits:CreditsData):Void
    {
        super(x, y);

        tweens = sequenceHandler.tweens;

        timers = sequenceHandler.timers;

        this.credits = credits;

        screen = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/CreditsPopup/screen"));
        
        screen.active = false;

        add(screen);

        label = new FlxText(0.0, 0.0, 0.0);

        label.visible = false;

        label.size = 24;

        label.font = Paths.font(Paths.ttf("Comic Sans MS"));

        label.alignment = CENTER;

        label.centerTo(screen);

        add(label);

        setPosition(this.getCenterX(), Options.downscroll ? -height : FlxG.height);
    }

    public function popUp():Void
    {
        tweens.tween(this, {y: Options.downscroll ? 0.0 : FlxG.height - height}, 1.25, 
            {ease: FlxEase.quartOut});

        new FlxTimer(timers).start(2.0, (tmr:FlxTimer) ->
        {
            tweens.tween(this, {y: Options.downscroll ? -height : FlxG.height}, 2.0, 
               {ease: FlxEase.quartIn, onComplete: (_:FlxTween) -> kill()});

            tweens.flicker(label, 2.0, 0.5);

            label.text = 'Composer(s): ${credits.composer}';

            var newWidth:Float = screen.width * 0.675;

            while (label.width > newWidth)
                label.size--;

            label.centerTo(screen);
        });
    }
}