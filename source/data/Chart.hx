package data;

import haxe.Json;

import util.TimingUtil;

using StringTools;

class Chart
{
    public static function decodeData(v:ChartData):Chart
    {
        var chart:Chart = new Chart();

        chart.name = v.name;

        chart.scrollSpeed = v.scrollSpeed;

        chart.notes = v.notes;

        chart.events = v.events;

        chart.timingPoints = v.timingPoints;

        chart.spectator = v.spectator;

        chart.opponent = v.opponent;

        chart.player = v.player;

        chart.credits = v.credits;
        
        return chart;
    }

    public var name:String;

    public var tempo:Float;

    public var scrollSpeed:Float;

    public var notes:Array<NoteData>;

    public var events:Array<EventData>;

    public var timingPoints:Array<TimingPointData>;
    
    public var spectator:String;

    public var opponent:String;

    public var player:String;

    public var credits:CreditsData;

    public function new():Void
    {
        name = "Test";

        tempo = 150.0;

        scrollSpeed = 1.6;

        notes = new Array<NoteData>();

        events = new Array<EventData>();

        timingPoints = new Array<TimingPointData>();

        spectator = "";

        opponent = "baldi-face-front";

        player = "bf-face-left";

        credits = {composer: "", step: 0}
    }
}

typedef ChartData =
{
    var name:String;

    var tempo:Float;

    var scrollSpeed:Float;

    var notes:Array<NoteData>;

    var events:Array<EventData>;

    var timingPoints:Array<TimingPointData>;

    var spectator:String;

    var opponent:String;

    var player:String;

    var credits:CreditsData;
}

typedef EventData = TimedObject &
{
    var name:String;

    var value:Dynamic;
}

typedef NoteData = TimedObject &
{
    var direction:Int;

    var length:Float;

    var lane:Int;

    var kind:String;

    var charId:Int;
}

typedef TimingPointData = TimedObject &
{
    var tempo:Float;
}

typedef CreditsData =
{
    public var composer:String;

    public var ?step:Int;
}

@:structInit
class NoteKindData
{
    public var altAnimation:Bool;

    public var noAnimation:Bool;

    public var specSing:Bool;

    public static function parseString(str:String):NoteKindData
    {
        return {altAnimation: NoteKindData.hasField(str, "alt-animation"),
            noAnimation: NoteKindData.hasField(str, "no-animation"), specSing: NoteKindData.hasField(str, "spec-sing")};
    }

    public static function addField(data:String, field:String):String
    {
        if (data.length == 0.0)
        {
            data = field;

            return data;
        }

        data = data.trim();

        data += '&& ${field}';

        return data;
    }

    public static function hasField(data:String, field:String):Bool
    {
        return data.contains(field);
    }
}