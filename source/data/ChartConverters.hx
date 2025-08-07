package data;

import haxe.Json;

import haxe.ds.ArraySort;

import core.AssetCache;
import core.Paths;

import util.MathUtil;
import util.TimedObjectUtil;
import util.TimedObjectUtil.TimedObject;

using StringTools;

using util.ArrayUtil;

class FunkinConverter
{
    public static function parse(chartPath:String, metaPath:String, diff:String):Chart
    {
        var output:Chart = new Chart();

        var rawChart:Dynamic = Json.parse(AssetCache.getText(chartPath));

        var notes:Array<FunkinNote> = Reflect.field(rawChart.notes, diff);

        sortTimedObjects(notes);

        var rawMeta:Dynamic = Json.parse(AssetCache.getText(metaPath));

        var timeChanges:Array<FunkinTimeChange> = rawMeta.timeChanges;

        sortTimedObjects(timeChanges);

        output.name = rawMeta.songName;

        output.tempo = timeChanges[0].bpm;

        output.scrollSpeed = Reflect.field(rawChart.scrollSpeed, diff);

        for (i in 0 ... notes.length)
        {
            var note:FunkinNote = notes[i];

            output.notes.push({time: note.t, direction: note.d % 4, lane: 1 - Math.floor(note.d * 0.25), length: note.l, kind: note.k});
        }

        for (i in 1 ... timeChanges.length)
        {
            var timeChange:FunkinTimeChange = timeChanges[i];

            output.timeChanges.push({time: timeChange.t, tempo: timeChange.bpm, step: 0.0});
        }

        output.spectator = rawMeta.playData.characters.girlfriend;

        output.player = rawMeta.playData.characters.opponent;

        output.opponent = rawMeta.playData.characters.player;

        output.credits = {composer: rawMeta.artist, step: 0}

        return output;
    }
    
    public static function sortTimedObjects(arr:Array<FunkinTimedObject>):Array<FunkinTimedObject>
    {
        ArraySort.sort(arr, (a:FunkinTimedObject, b:FunkinTimedObject) -> Std.int(a.t - b.t));
        
        return arr;
    }
}

// TODO: Migrate credits .txt to .json.
class PsychConverter
{
    public static function parse(chartPath:String, creditsPath:String):Chart
    {
        var output:Chart = new Chart();

        var raw:Dynamic = Json.parse(AssetCache.getText(chartPath));

        output.name = raw.song;

        output.tempo = raw.bpm;

        output.scrollSpeed = raw.speed;
        
        var time:Float = 0.0;

        var tempo:Float = output.tempo;

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

            TimedObjectUtil.sort(_section.sectionNotes);

            var newCharacter:String = _section.mustHitSection ? "player" : "opponent";

            if (_section.gfSection)
                newCharacter = "spectator";

            if (character != newCharacter)
            {
                output.events.push({time: time, name: "FocusCamChar", value: {charType: newCharacter,
                    duration: 0.0, ease: "linear"}});

                character = newCharacter;
            }

            var beatLength:Float = (60.0 / tempo * 1000.0);

            if (_section.changeBPM)
            {
                tempo = _section.bpm;

                beatLength = (60.0 / tempo * 1000.0);

                output.timeChanges.push({time: time, tempo: tempo, step: 0.0});
            }

            time += beatLength * (Math.round(_section.sectionBeats * 4.0) * 0.25);

            for (j in 0 ... _section.sectionNotes.length)
            {
                var note:PsychNote = _section.sectionNotes[j];

                var kind:String = "";

                if (note.type == "Alt Animation")
                    kind = "alt-animation";

                if (note.type == "No Animation")
                    kind = "no-animation";

                output.notes.push({time: note.time, direction: note.direction % 4, lane: 1 - Math.floor(note.direction * 0.25), length: MathUtil.maxInt(Math.round(note.length - beatLength * 0.25), 0), kind: kind});
            }
        }

        output.spectator = raw.gfVersion;

        output.opponent = raw.player2;

        output.player = raw.player1;

        var credits:String = AssetCache.getText(creditsPath);

        var split:Array<String> = credits.split("|");

        var composer:String = split.first((str:String) -> str.toLowerCase().contains("composer")).split("=")[1];

        var step:Null<Int> = split.length > 1.0 ? Std.parseInt(split.first((str:String) -> str.toLowerCase().contains("step"))
            .split("=")[1]) : null;

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

typedef FunkinTimeChange = FunkinTimedObject &
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