package plugins;

import flixel.FlxBasic;
import flixel.FlxG;

import flixel.math.FlxRect;

class MouseRectPlugin extends FlxBasic
{
    /**
     * The mouse position is limited to the boundaries of this `FlxRect`.
     */
    public var mouseRect:FlxRect;

    public function new():Void
    {
        super();

        active = false;

        visible = false;

        mouseRect = FlxRect.get();

        FlxG.stage.window.onMouseMove.add(updateMouseRect);

        FlxG.signals.preStateSwitch.add(resetMouseRect);
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.stage.window.onMouseMove.remove(updateMouseRect);
        
        FlxG.signals.preStateSwitch.remove(resetMouseRect);

        mouseRect.put();
    }

    public function updateMouseRect(x:Float, y:Float):Void
    {
        var mouseX:Int = Math.floor(x);

        var mouseY:Int = Math.floor(y);

        if (!mouseRect.isEmpty)
        {
            // Thanks Arcadia.
            
            var left:Int = Math.floor(mouseRect.left * FlxG.scaleMode.scale.x);

            var top:Int = Math.floor(mouseRect.top * FlxG.scaleMode.scale.y);

            var bottom:Int = Math.floor((mouseRect.bottom - mouseRect.y) * FlxG.scaleMode.scale.y -
                FlxG.mouse.cursorContainer.height);

            var right:Int = Math.floor((mouseRect.right - mouseRect.x) * FlxG.scaleMode.scale.x -
                FlxG.mouse.cursorContainer.width);

            if (mouseX < left)
                FlxG.stage.window.warpMouse(left, mouseY);

            if (mouseY < top)
                FlxG.stage.window.warpMouse(mouseX, top);

            if (mouseY > bottom)
                FlxG.stage.window.warpMouse(mouseX, bottom);

            if (mouseX > right)
                FlxG.stage.window.warpMouse(right, mouseY);
        }
    }

    public function resetMouseRect():Void
    {
        mouseRect.set(0.0, 0.0, 0.0, 0.0);
    }
}