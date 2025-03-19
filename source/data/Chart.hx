package data;

import haxe.Json;

import util.TimedObjectUtil.TimedObject;

class Chart
{
    public static function fromRaw(raw:RawChart):Chart
    {
        var chart:Chart = new Chart();

        chart.name = raw.name;

        chart.tempo = raw.tempo; chart.scrollSpeed = raw.scrollSpeed;

        chart.notes = raw.notes; chart.events = raw.events; chart.timeChanges = raw.timeChanges;

        chart.spectator = raw.spectator; chart.opponent = raw.opponent; chart.player = raw.player;

        return chart;
    }

    /**
     * A unique `String` identifier for `this` `Chart`. Used in several areas of the application.
     */
    public var name:String;

    public var tempo:Float;

    public var scrollSpeed:Float;

    public var notes:Array<RawNote>;

    public var events:Array<RawEvent>;

    public var timeChanges:Array<RawTimeChange>;

    public var spectator:String;

    public var opponent:String;

    public var player:String;

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
    }

    public function toString():String
    {
        return Json.stringify({name: name, tempo: tempo, scrollSpeed: scrollSpeed, notes: notes, events: events,
            timeChanges: timeChanges, spectator: spectator, opponent: opponent, player: player});
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