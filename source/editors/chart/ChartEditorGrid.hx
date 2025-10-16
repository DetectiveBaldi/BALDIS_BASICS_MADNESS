package editors.chart;

import openfl.display.BitmapData;

import openfl.geom.Rectangle;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxTiledSprite;

class ChartEditorGrid extends FlxTiledSprite
{
    public function new():Void
    {
        super(null, 0, 0);

        active = false;

        var bitmapWidth:Int = 360;

        var bitmapHeight:Int = 80;

        var bitmap:BitmapData = FlxGridOverlay.createGrid(40, 40, bitmapWidth, bitmapHeight, true, 0xFF181919, 0xFF202020);

        var drawPos:Rectangle = new Rectangle(40.0, 0.0, 3.0, 80.0);

        bitmap.fillRect(drawPos, 0xFFA3A3A3);

        drawPos.setTo(200.0, 0.0, 3.0, 80.0);

        bitmap.fillRect(drawPos, 0xFFA3A3A3);

        bitmap.disposeImage();

        loadGraphic(bitmap);

        width = bitmapWidth;

        height = bitmapHeight;
    }
}