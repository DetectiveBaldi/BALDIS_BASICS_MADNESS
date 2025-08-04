package data;

import haxe.Json;

import util.TimedObjectUtil.TimedObject;

class Chart
{
    public static function parse(schema:ChartSchema):Chart
    {
        var chart:Chart = new Chart();

        var fields:Array<String> = Reflect.fields(schema);

        for (i in 0 ... fields.length)
        {
            var field:String = fields[i];

            Reflect.setProperty(chart, field, Reflect.field(schema, field));
        }

        return chart;
    }

    public var name:String;

    public var tempo:Float;

    public var scrollSpeed:Float;

    public var notes:Array<NoteSchema>;

    public var events:Array<EventSchema>;

    public var timeChanges:Array<TimeChange>;

    public var spectator:String;

    public var opponent:String;

    public var player:String;

    public var credits:CreditsData;

    public function new():Void
    {
        name = "Test";

        tempo = 150.0;

        scrollSpeed = 1.6;

        notes = new Array<NoteSchema>();

        events = new Array<EventSchema>();

        timeChanges = new Array<TimeChange>();

        spectator = "";

        opponent = "baldi-face-front";

        player = "bf-face-left";

        credits = {composer: "", step: 0}
    }
}

typedef ChartSchema =
{
    var name:String;

    var tempo:Float;

    var scrollSpeed:Float;

    var notes:Array<ChartSchema>;

    var events:Array<EventSchema>;

    var timeChanges:Array<TimeChange>;

    var spectator:String;

    var opponent:String;

    var player:String;

    var credits:CreditsData;
}

typedef EventSchema = TimedObject &
{
    var name:String;

    var value:Dynamic;
}

typedef NoteSchema = TimedObject &
{
    var direction:Int;

    var length:Float;

    var lane:Int;

    var kind:String;
}

typedef TimeChange = TimedObject &
{
    var tempo:Float;

    var step:Float;
}

typedef CreditsData =
{
    public var composer:String;

    public var ?step:Int;
}