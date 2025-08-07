package game.events;

import game.PlayState;

class FocusCamCharEvent
{
    public static function dispatch(game:PlayState, charType:String, duration:Float, ease:String = "linear",
        skipCameraLock:Bool = false):Void
    {
        game.cameraTarget = "CHARACTER";

        game.focusedCharacter = charType.toUpperCase();

        if ((game.cameraLock == FOCUS_CAM_POINT || game.cameraLock == NONE) && !skipCameraLock)
            return;

        var char:Character = Reflect.getProperty(game, charType);

        var x:Float = char.getMidpoint().x + char.config.cameraPoint.x;

        var y:Float = char.getMidpoint().y + char.config.cameraPoint.y;

        FocusCamPointEvent.dispatch(game, x, y, duration, ease, true);
    }
}