package effects;

import flixel.FlxState;
import flixel.FlxSubState;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

class TransitionState extends FlxState
{
    public static var skipTransition:Bool = false;

    override function create():Void
    {
        super.create();

        if (!skipTransition)
            openSubState(new CustomTransition(OUT));
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
        if (skipTransition)
        {
            super.startOutro(onOutroComplete);

            return;
        }

        openSubState(new CustomTransition(IN, onOutroComplete));
    }
}

class CustomTransition extends FlxSubState
{
    public var fade:CustomTransitionFade;
    
    public var onComplete:()->Void;

    public function new(_fade:CustomTransitionFade, _onComplete:()->Void = null):Void
    {
        super();

        fade = _fade;

        onComplete = _onComplete;
    }

    override function create():Void
    {
        super.create();

        var backdrop:FlxBackdrop = new FlxBackdrop();

        backdrop.loadGraphic(Assets.getGraphic(Paths.png("assets/images/effects/TransitionState/gradient")), true, 16, 16);

		backdrop.animation.add("this", [for (i in 0 ... 7) i], 12, false);

        backdrop.animation.onFinish.addOnce((name:String) ->
        {
            if (fade == OUT)
                close();

            if (onComplete != null)
                onComplete();
        });

		backdrop.animation.play("this", true, fade == IN);

		add(backdrop);
    }

    override function destroy():Void
    {
        super.destroy();

        onComplete = null;
    }
}

enum CustomTransitionFade
{
    IN;

    OUT;
}