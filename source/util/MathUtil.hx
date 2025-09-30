package util;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;

import flixel.math.FlxMath;

import flixel.util.FlxAxes;

class MathUtil
{
    public static function minInt(...values:Int):Int
    {
        var output:Int = FlxMath.MAX_VALUE_INT;

        for (i in 0 ... values.length)
        {
            var value:Int = values[i];

            if (value < output)
                output = value;
        }

        return output;
    }

    public static function maxInt(...values:Int):Int
    {
        var output:Int = FlxMath.MIN_VALUE_INT;

        for (i in 0 ... values.length)
        {
            var value:Int = values[i];

            if (value > output)
                output = value;
        }

        return output;
    }

    public static overload inline extern function getCenterX(object:FlxObject, base:FlxObject):Float
    {
        return base.getMidpoint().x - object.width * 0.5;
    }

    public static overload inline extern function getCenterX(object:FlxObject, base:FlxCamera):Float
    {
        return base.scroll.x + (base.width - object.width) * 0.5;
    }

    public static overload inline extern function getCenterX(object:FlxObject):Float
    {
        return (FlxG.width - object.width) * 0.5;
    }

    public static overload inline extern function getCenterY(object:FlxObject, base:FlxObject):Float
    {
        return base.getMidpoint().y - object.height * 0.5;
    }

    public static overload inline extern function getCenterY(object:FlxObject, base:FlxCamera):Float
    {
        return base.scroll.y + (base.height - object.height) * 0.5;
    }

    public static overload inline extern function getCenterY(object:FlxObject):Float
    {
        return (FlxG.height - object.height) * 0.5;
    }

    public static overload inline extern function centerTo(object:FlxObject, base:FlxObject, axes:FlxAxes = XY):FlxObject
    {
        if (axes.x)
            object.x = getCenterX(object, base);

        if (axes.y)
            object.y = getCenterY(object, base);

        return object;
    }

    public static overload inline extern function centerTo(object:FlxObject, base:FlxCamera, axes:FlxAxes = XY):FlxObject
    {
        if (axes.x)
            object.x = getCenterX(object, base);

        if (axes.y)
            object.y = getCenterY(object, base);

        return object;
    }

    public static overload inline extern function centerTo(object:FlxObject, axes:FlxAxes = XY):FlxObject
    {
        if (axes.x)
            object.x = getCenterX(object);

        if (axes.y)
            object.y = getCenterY(object);

        return object;
    }
}