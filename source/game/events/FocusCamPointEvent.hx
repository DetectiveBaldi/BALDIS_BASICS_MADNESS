package game.events;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import game.PlayState;

class FocusCamPointEvent
{
    public static function dispatch(game:PlayState, x:Float = 0.0, y:Float = 0.0, duration:Float, ease:String = "linear"):Void
    {
        if (game.cameraLock == MANUAL || game.cameraLock == STRICT)
            return;

        game.cameraTarget = "POINT";

        if (duration > 0.0)
        {
            game.gameCamera.follow(null, LOCKON, 0.05);

            game.cameraPoint.setPosition(x, y);

            game.tween.tween(game.gameCamera.scroll, {x: game.cameraPoint.x - game.gameCamera.width * 0.5, y: game.cameraPoint.y - game.gameCamera.height * 0.5}, duration,
            {
                ease: Reflect.getProperty(FlxEase, ease),

                onComplete: (_tween:FlxTween) -> game.gameCamera.follow(game.cameraPoint, LOCKON, 0.05)
            });
        }
        else
            game.cameraPoint.setPosition(x, y);
    }
}