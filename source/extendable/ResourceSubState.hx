package extendable;

import flixel.FlxSubState;

import flixel.tweens.FlxTween.FlxTweenManager;

import flixel.util.FlxTimer.FlxTimerManager;

/**
 * An extended `flixel.FlxSubState` with built in `tween` and `timer` fields.
 */
// TODO: Merge `extendable.ResourceState`, and `music.MusicSubState` into one class.
class ResourceSubState extends FlxSubState
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