package extendable;

import flixel.FlxState;

import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxTimer.FlxTimerManager;

/**
 * An extended `flixel.FlxState` with built in `tween` and `timer` fields.
 */
// TODO: Merge `extendable.ResourceState`, `effects.TransitionState`, and `music.MusicState` into one class.
class ResourceState extends FlxState
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