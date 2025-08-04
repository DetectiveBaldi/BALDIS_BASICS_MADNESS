package extendable;

import flixel.FlxSubState;

import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxTimer.FlxTimerManager;

class CustomSubState extends FlxSubState
{
    public var tween:FlxTweenManager;

    public var timer:FlxTimerManager;

    override function create():Void
    {
        super.create();

        tween = new FlxTweenManager();

        add(tween);

        timer = new FlxTimerManager();

        add(timer);
    }
}