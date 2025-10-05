package plugins;

import flixel.FlxBasic;
import flixel.FlxG;

import flixel.math.FlxPoint;

class MouseRectPlugin extends FlxBasic
{
    public var left:Float;

    public var right:Float;

    public var top:Float;

    public var bottom:Float;

    public function new():Void
    {
        super();

        active = false;

        visible = false;

        FlxG.stage.window.onMouseMove.add(updateMouseRect);

        FlxG.signals.preStateSwitch.add(resetMouseRect);
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.stage.window.onMouseMove.remove(updateMouseRect);
        
        FlxG.signals.preStateSwitch.remove(resetMouseRect);
    }

    public function updateMouseRect(x:Float, y:Float):Void
    {
        if (FlxG.debugger.visible)
            return;
        
        var mouseX:Int = Math.floor(x);

        var mouseY:Int = Math.floor(y);

        var offset:FlxPoint = FlxG.scaleMode.offset;
        
        var newLeft:Int = Math.floor(left * FlxG.scaleMode.scale.x + offset.x);

        var newRight:Int = Math.floor(right * FlxG.scaleMode.scale.x + offset.x -
            FlxG.mouse.cursor.width);

        var newTop:Int = Math.floor(top * FlxG.scaleMode.scale.y + offset.y);

        var newBottom:Int = Math.floor(bottom * FlxG.scaleMode.scale.y + offset.y -
            FlxG.mouse.cursor.height);

        if (mouseX < newLeft)
            FlxG.stage.window.warpMouse(newLeft, mouseY);

        if (mouseX > newRight)
            FlxG.stage.window.warpMouse(newRight, mouseY);

        if (mouseY < newTop)
            FlxG.stage.window.warpMouse(mouseX, newTop);

        if (mouseY > newBottom)
            FlxG.stage.window.warpMouse(mouseX, newBottom);
    }

    public function setMouseRect(left:Float = 0.0, right:Float = 0.0, top:Float = 0.0, bottom:Float = 0.0):Void
    {
        this.left = left;

        this.right = right;

        this.top = top;

        this.bottom = bottom;

        updateMouseRect(FlxG.stage.mouseX, FlxG.stage.mouseY);
    }

    public function resetMouseRect():Void
    {
        left = 0.0;

        right = FlxG.width;

        top = 0.0;

        bottom = FlxG.height;
    }
}