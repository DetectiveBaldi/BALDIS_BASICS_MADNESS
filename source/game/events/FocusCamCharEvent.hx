package game.events;

import game.PlayState;

class FocusCamCharEvent
{
    public static function dispatch(game:PlayState, charType:String, duration:Float, ease:String = "linear"):Void
    {
        if (game.cameraLock == MANUAL || game.cameraLock == STRICT)
        {
            game.cameraTarget = charType.toUpperCase();
            
            return;
        }

        var char:Character = Reflect.getProperty(game, charType);

        var x:Float = char.getMidpoint().x + char.config.cameraPoint.x;

        var y:Float = char.getMidpoint().y + char.config.cameraPoint.y;

        FocusCamPointEvent.dispatch(game, x, y, duration, ease);

        game.cameraTarget = charType.toUpperCase();
    }
}