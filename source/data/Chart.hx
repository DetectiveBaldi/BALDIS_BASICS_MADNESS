package data;

import haxe.Json;

import util.TimedObjectUtil.TimedObject;

class Chart
{
    public static function fromRaw(raw:RawChart):Chart
    {
        var chart:Chart = new Chart();

        var fields:Array<String> = Reflect.fields(raw);

        for (i in 0 ... fields.length)
        {
            var field:String = fields[i];

            Reflect.setProperty(chart, field, Reflect.field(raw, field));
        }

        return chart;
    }

    public var name:String;

    public var tempo:Float;

    public var scrollSpeed:Float;

    public var notes:Array<RawNote>;

    public var events:Array<RawEvent>;

    public var timeChanges:Array<RawTimeChange>;

    public var spectator:String;

    public var opponent:String;

    public var player:String;

    public var credits:CreditsData;

    public function new():Void
    {
        name = "Test";

        tempo = 150.0;

        scrollSpeed = 1.6;

        notes = new Array<RawNote>();

        events = new Array<RawEvent>();

        timeChanges = new Array<RawTimeChange>();

        spectator = "";

        opponent = "baldi0";

        player = "bf0";

        credits = {composer: "", step: 0}
    }
}

typedef RawChart =
{
    var name:String;

    var tempo:Float;

    var scrollSpeed:Float;

    var notes:Array<RawNote>;

    var events:Array<RawEvent>;

    var timeChanges:Array<RawTimeChange>;

    var spectator:String;

    var opponent:String;

    var player:String;

    var credits:CreditsData;
}

typedef RawEvent = TimedObject &
{
    var name:String;

    var value:Dynamic;
}

typedef RawNote = TimedObject &
{
    var direction:Int;

    var length:Float;

    var lane:Int;

    var kind:String;
}

typedef RawTimeChange = TimedObject &
{
    var tempo:Float;

    var step:Float;
}

typedef CreditsData =
{
    public var composer:String;

    public var ?step:Int;
}