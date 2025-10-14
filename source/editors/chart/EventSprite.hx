package editors.chart;

import flixel.FlxSprite;

import data.Chart.EventData;

class EventSprite extends FlxSprite
{
    public var eventData:EventData;

    public function new():Void
    {
        super();

        eventData = {time: 0.0, name: "", value: null}
    }
}