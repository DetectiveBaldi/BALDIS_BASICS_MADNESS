package data;

import haxe.Json;

class Chart
{
    public static function parse(schema:ChartSchema):Chart
    {
        var chart:Chart = new Chart();

        chart.name = schema.name;

        chart.scrollSpeed = schema.scrollSpeed;

        chart.notes = schema.notes;

        chart.events = schema.events;

        chart.timeChanges = schema.timeChanges;

        chart.spectator = schema.spectator;

        chart.opponent = schema.opponent;

        chart.player = schema.player;

        chart.credits = schema.credits;
        
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

    var notes:Array<NoteSchema>;

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