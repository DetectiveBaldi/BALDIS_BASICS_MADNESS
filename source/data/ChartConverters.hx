package data;

import haxe.Json;

import haxe.ds.ArraySort;

import sys.io.File;

import core.AssetCache;
import core.Paths;

import data.Chart;

import util.MathUtil;
import util.TimingUtil;

using StringTools;

using util.ArrayUtil;

class FunkinConverter
{
    public static function run(chartPath:String, metaPath:String, difficulty:String):Chart
    {
        var output:Chart = new Chart();

        var rawChart:Dynamic = Json.parse(File.getContent(chartPath));

        var notes:Array<FunkinNote> = Reflect.field(rawChart.notes, difficulty);

        var rawMeta:Dynamic = Json.parse(File.getContent(metaPath));

        output.name = rawMeta.songName;

        output.scrollSpeed = Reflect.field(rawChart.scrollSpeed, difficulty);

        for (i in 0 ... notes.length)
        {
            var note:FunkinNote = notes[i];

            output.notes.push({time: note.t, direction: note.d % 4, lane: 1 - Math.floor(note.d * 0.25), length: note.l,
                kind: note.k, charId: -1});
        }

        var timingPoints:Array<FunkinTimingPoint> = rawMeta.timingPoints;

        for (i in 0 ... timingPoints.length)
        {
            var timeChange:FunkinTimingPoint = timingPoints[i];

            output.timingPoints.push({time: timeChange.t, tempo: timeChange.bpm});
        }

        var characters:Dynamic = rawMeta.playData.characters;

        output.spectator = characters.girlfriend;

        output.opponent = characters.opponent;

        output.player = characters.player;

        output.credits = {composer: rawMeta.artist, step: 0}

        return output;
    }
}

class PsychConverter
{
    public static function run(chartPath:String, creditsPath:String):Chart
    {
        var output:Chart = new Chart();

        var raw:Dynamic = Json.parse(File.getContent(chartPath));

        output.name = raw.song;

        output.scrollSpeed = raw.speed;
        
        var time:Float = 0.0;

        var tempo:Float = raw.bpm;

        output.timingPoints.push({time: 0.0, tempo: tempo});

        var character:String = "";

        for (i in 0 ... raw.notes.length)
        {
            var section:Dynamic = raw.notes[i];

            var _section:PsychSection =
            {
                sectionNotes:
                [
                    for (j in 0 ... section.sectionNotes.length)
                    {
                        var note:Array<Dynamic> = section.sectionNotes[j];

                        {time: note[0], direction: note[1], length: note[2], type: note[3]}
                    }
                ],

                sectionBeats: section.sectionBeats,

                mustHitSection: section.mustHitSection,

                gfSection: section.gfSection,

                changeBPM: section.changeBPM,

                bpm: section.bpm
            };

            character = _section.mustHitSection ? "player" : "opponent";

            if (_section.gfSection)
                character = "spectator";
            
            output.events.push({time: time, name: "SetCamFocus", value: {x: 0.0, y: 0.0, charType: character,
                duration: 0.0, ease: "linear"}});

            var beatLength:Float = (60.0 / tempo * 1000.0);

            if (_section.changeBPM)
            {
                tempo = _section.bpm;

                beatLength = (60.0 / tempo * 1000.0);

                output.timingPoints.push({time: time, tempo: tempo});
            }

            time += beatLength * (Math.round(_section.sectionBeats * 4.0) * 0.25);

            for (j in 0 ... _section.sectionNotes.length)
            {
                var note:PsychNote = _section.sectionNotes[j];

                var type:String = note.type ?? "";

                var kind:String = "";

                // `_section.gfSection` is not supported here unfortunately.
                if (type == "GF Sing")
                    kind = NoteKindData.addField(kind, "spec-sing");

                if (type == "Alt Animation")
                    kind = NoteKindData.addField(kind, "alt-animation");

                if (type == "No Animation")
                    kind = NoteKindData.addField(kind, "no-animation");

                var charId:Int = -1;

                if (type.startsWith("mamacitas-char-id"))
                    charId = Std.parseInt(type.split("-").last());

                output.notes.push({time: note.time, direction: note.direction % 4, lane: 1 - Math.floor(note.direction * 0.25),
                    length: Math.max(note.length - beatLength * 0.25, 0.0), kind: kind, charId: charId});
            }
        }

        output.spectator = raw.gfVersion;

        output.opponent = raw.player2;

        output.player = raw.player1;

        var credits:String = File.getContent(creditsPath);

        var split:Array<String> = credits.split("|");

        var composer:String = split[0].split("=").last();

        var step:Int = Std.int(Math.abs(Std.parseInt(split[1]?.split("=")?.last() ?? "0")));

        output.credits = {composer: composer, step: step}

        return output;
    }
}

typedef FunkinTimedObject =
{
    var t:Float;
}

typedef FunkinEvent = FunkinTimedObject &
{
    var e:String;

    var v:Dynamic;
};

typedef FunkinNote = FunkinTimedObject &
{
    var d:Int;

    var l:Float;

    var k:String;
};

typedef FunkinTimingPoint = FunkinTimedObject &
{
    var b:Float;

    var bpm:Float;

    var n:Int;

    var d:Int;

    var bt:Array<Int>;
};

typedef PsychSection =
{
    var sectionNotes:Array<PsychNote>;

    var sectionBeats:Float;

    var mustHitSection:Bool;

    var gfSection:Bool;

    var changeBPM:Bool;

    var bpm:Float;
};

typedef PsychEvent = TimedObject &
{
    var name:String;

    var value1:String;

    var value2:String;
};

typedef PsychNote = TimedObject &
{
    var direction:Int;

    var length:Float;

    var type:String;
};