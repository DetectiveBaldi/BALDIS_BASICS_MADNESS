package game;

import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import flixel.util.FlxSignal;

import core.AssetCache;
import core.Paths;

import interfaces.IBeatDispatcher;

import music.Conductor;

using util.MathUtil;

class HealthBar extends FlxSpriteGroup
{
    public var conductor:Conductor;

    public var percent(get, set):Float;

    @:noCompletion
    function get_percent():Float
    {
        return ((value - min) / (max - min)) * 100.0;
    }

    @:noCompletion
    function set_percent(_percent:Float):Float
    {
        value = (range / max) * _percent;

        return percent;
    }

    public var value(default, set):Float;

    @:noCompletion
    function set_value(_value:Float):Float
    {
        value = FlxMath.bound(_value, min, max);

        if (value == min)
            onEmptied.dispatch();

        if (value == max)
            onFilled.dispatch();
        
        return value;
    }

    public var min:Float;

    public var max:Float;

    public var range(get, never):Float;
    
    @:noCompletion
    function get_range():Float
    {
        return max - min;
    }

    public var onEmptied:FlxSignal;

    public var onFilled:FlxSignal;

    public var fillDirection:HealthBarFillDirection;

    public var gradient:FlxSprite;

    public var needle:FlxSprite;

    public var overlay:FlxSprite;

    public var opponentIcon:HealthIcon;

    public var playerIcon:HealthIcon;

    public function new(x:Float = 0.0, y:Float = 0.0, beatDispatcher:IBeatDispatcher):Void
    {
        super(x, y);

        conductor = beatDispatcher.conductor;

        conductor.onBeatHit.add(beatHit);

        @:bypassAccessor
        value = 50.0;

        min = 0.0;

        max = 100.0;

        onEmptied = new FlxSignal();

        onFilled = new FlxSignal();

        fillDirection = LEFT_TO_RIGHT;

        gradient = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/HealthBar/gradient"));

        gradient.scale.set(1.3, 1.3);

        gradient.updateHitbox();

        add(gradient);

        needle = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/HealthBar/needle"));

        needle.scale.set(1.3, 1.3);

        needle.updateHitbox();

        add(needle);

        overlay = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("game/HealthBar/overlay"));

        overlay.scale.set(1.3, 1.3);

        overlay.updateHitbox();

        add(overlay);

        gradient.centerTo(overlay);

        needle.centerTo(gradient);

        opponentIcon = new HealthIcon("baldi");

        opponentIcon.centerTo(overlay);

        opponentIcon.x -= 250.0;

        opponentIcon.y -= 5.0;

        add(opponentIcon);

        playerIcon = new HealthIcon("bf");

        playerIcon.flipX = true;

        playerIcon.x = overlay.x + overlay.width - playerIcon.width + 15.0;

        playerIcon.centerTo(overlay);

        playerIcon.x += 250.0;

        playerIcon.y -= 5.0;
        
        add(playerIcon);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (positionNeedle != null)
            positionNeedle();

        playerIcon.animation.curAnim.curFrame = (percent < 20.0) ? 1 : 0;
        
        opponentIcon.animation.curAnim.curFrame = (percent > 80.0) ? 1 : 0;

        if (scaleIcons != null)
            scaleIcons(elapsed);
    }

    override function destroy():Void
    {
        super.destroy();

        conductor?.onBeatHit?.remove(beatHit);
    }

    public function beatHit(beat:Int):Void
    {
        opponentIcon.scale *= 1.35 - 0.3 * (value / max);

        playerIcon.scale *= 1.05 + 0.3 * (value / max);
    }

    public dynamic function scaleIcons(elapsed:Float):Void
    {
        opponentIcon.scale.x = FlxMath.lerp(opponentIcon.scale.x, 1.0, FlxMath.getElapsedLerp(0.15, elapsed));

        opponentIcon.scale.y = FlxMath.lerp(opponentIcon.scale.y, 1.0, FlxMath.getElapsedLerp(0.15, elapsed));

        playerIcon.scale.x = FlxMath.lerp(playerIcon.scale.x, 1.0, FlxMath.getElapsedLerp(0.15, elapsed));

        playerIcon.scale.y = FlxMath.lerp(playerIcon.scale.y, 1.0, FlxMath.getElapsedLerp(0.15, elapsed));
    }

    public dynamic function positionNeedle():Void
    {
        switch (fillDirection:HealthBarFillDirection)
        {
            case LEFT_TO_RIGHT:
            {
                needle.setPosition(gradient.x + (gradient.width - needle.width) * percent * 0.01,
                    gradient.getMidpoint().y - needle.height * 0.5);
            }
            
            case RIGHT_TO_LEFT:
            {
                needle.setPosition(gradient.x + (gradient.width - needle.width) * (100.0 - percent) * 0.01,
                    gradient.getMidpoint().y - needle.height * 0.5);
            }
        }
    }
}

enum HealthBarFillDirection
{
    LEFT_TO_RIGHT;

    RIGHT_TO_LEFT;
}