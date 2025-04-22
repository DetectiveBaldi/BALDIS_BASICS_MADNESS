package game;

import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import flixel.math.FlxMath;

import flixel.util.FlxSignal;

import core.Assets;
import core.Paths;

import data.HealthIconData;

import music.Conductor;

using util.MathUtil;

class HealthBar extends FlxSpriteGroup
{
    public var conductor(default, set):Conductor;

    @:noCompletion
    function set_conductor(_conductor:Conductor):Conductor
    {
        var __conductor:Conductor = conductor;

        conductor = _conductor;

        conductor?.onBeatHit?.add(beatHit);

        __conductor?.onBeatHit?.remove(beatHit);

        return conductor;
    }

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

    public function new(x:Float = 0.0, y:Float = 0.0, _conductor:Conductor):Void
    {
        super(x, y);

        conductor = _conductor;

        @:bypassAccessor
        value = 50.0;

        min = 0.0;

        max = 100.0;

        onEmptied = new FlxSignal();

        onFilled = new FlxSignal();

        fillDirection = LEFT_TO_RIGHT;

        gradient = new FlxSprite(0.0, 0.0, Assets.getGraphic("game/HealthBar/gradient"));

        gradient.scale.set(1.3, 1.3);

        gradient.updateHitbox();

        add(gradient);

        needle = new FlxSprite(0.0, 0.0, Assets.getGraphic("game/HealthBar/needle"));

        needle.scale.set(1.3, 1.3);

        needle.updateHitbox();

        add(needle);

        overlay = new FlxSprite(0.0, 0.0, Assets.getGraphic("game/HealthBar/overlay"));

        overlay.scale.set(1.3, 1.3);

        overlay.updateHitbox();

        add(overlay);

        gradient.centerTo(overlay);

        gradient.y += gradient.height * 0.15;

        needle.centerTo(gradient);

        opponentIcon = new HealthIcon(0.0, 0.0, HealthIconData.get("baldi0"));

        opponentIcon.centerTo(overlay);

        opponentIcon.x -= 250.0;

        add(opponentIcon);

        playerIcon = new HealthIcon(0.0, 0.0, HealthIconData.get("bf0"));

        playerIcon.flipX = true;

        playerIcon.x = overlay.x + overlay.width - playerIcon.width + 15.0;

        playerIcon.centerTo(overlay);

        playerIcon.x += 250.0;
        
        add(playerIcon);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (positionNeedle != null)
            positionNeedle();

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
        opponentIcon.scale *= 1.35 + -0.35 * (value / max);

        playerIcon.scale *= 1.0 + 0.35 * (value / max);
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

enum abstract HealthBarFillDirection(String) from String to String
{
    var LEFT_TO_RIGHT:HealthBarFillDirection;

    var RIGHT_TO_LEFT:HealthBarFillDirection;
}