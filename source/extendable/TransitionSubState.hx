package extendable;

import flixel.FlxSprite;
import flixel.FlxSubState;

import extendable.TransitionState;

class TransitionSubState extends FlxSubState
{
    public static var cancelFadeIn:Bool;

    public static var cancelFadeOut:Bool;

    public static function cancelNextTransition():Void
    {
        cancelFadeIn = true;

        cancelFadeOut = true;
    }

    override function create():Void
    {
        super.create();

        if (!cancelFadeIn)
        {
            persistentUpdate = true;

            transitionIn(() -> persistentUpdate = false);
        }

        cancelFadeIn = false;
    }

    override function openSubState(newSubState:FlxSubState):Void
    {
        super.openSubState(newSubState);

        var typeOf:Class<FlxSubState> = Type.getClass(newSubState);

        // If the sub state trying to open ISN'T of type `CustomTransition`, proceed.
        if (typeOf != CustomTransition)
        {
            // Get type of current sub state.
            typeOf = Type.getClass(subState);

            /**
             * We set `persistentUpdate` to false here because Flixel has internally already closed the `CustomTransition`
             * sub state, but it hasn't (and won't) dispatched the sub state's `close` method, which WOULD set this to false.
             * Therefore, we have to do it ourselves here.
             */
            if (typeOf == CustomTransition)
                persistentUpdate = false;
        }
    }

    override function close():Void
    {
        if (cancelFadeOut)
        {
            cancelFadeOut = false;

            closeHelper();

            return;
        }

        transitionOut(closeHelper);
    }

    public function transitionIn(onFinish:()->Void = null):Void
    {
        openSubState(new CustomTransition(IN, () ->
        {
            closeSubState();

            if (onFinish != null)
                onFinish();
        }));
    }

    public function transitionOut(onFinish:()->Void = null):Void
    {
        persistentUpdate = false;

        openSubState(new CustomTransition(OUT, () -> {if (onFinish != null) onFinish();}));
    }
    
    public function closeHelper():Void
    {
        super.close();
    }
}