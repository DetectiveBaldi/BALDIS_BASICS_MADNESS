package editors.chart;

import openfl.display.BitmapData;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxTiledSprite;

class ChartEditorGrid extends FlxTiledSprite
{
    public function new():Void
    {
        super(null, 0.0, 0.0);

        var bitmapWidth:Int = 40 * 8;

        bitmapWidth += 40;

        var bitmapHeight:Int = 40 * 16;

        var bitmap:BitmapData = FlxGridOverlay.createGrid(40, 40, bitmapWidth, bitmapHeight, true, 0xFF181919, 0xFF202020);

        bitmap.disposeImage();

        loadGraphic(bitmap);

        width = bitmapWidth;

        height = 1000.0;
    }
}