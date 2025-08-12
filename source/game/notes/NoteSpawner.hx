package game.notes;

import flixel.FlxBasic;
import flixel.FlxG;

import flixel.group.FlxGroup.FlxTypedGroup;

import data.Chart;

import music.Conductor;

using StringTools;

using util.ArrayUtil;

class NoteSpawner extends FlxBasic
{
    public var conductor:Conductor;

    public var noteData:Array<NoteSchema>;

    public var strumlines:FlxTypedGroup<Strumline>;

    public var notes:FlxTypedGroup<Note>;

    public var sustains:FlxTypedGroup<Sustain>;

    public var trails:FlxTypedGroup<SustainTrail>;

    public var noteIndex:Int;

    public function new(_conductor:Conductor, _noteData:Array<NoteSchema>, _strumlines:FlxTypedGroup<Strumline>):Void
    {
        super();

        visible = false;

        camera = FlxG.cameras.list.last();

        conductor = _conductor;
        
        noteData = _noteData.copy();

        strumlines = _strumlines;

        notes = new FlxTypedGroup<Note>();

        sustains = new FlxTypedGroup<Sustain>();

        trails = new FlxTypedGroup<SustainTrail>();

        noteIndex = 0;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        while (noteIndex < noteData.length)
        {
            var noteSchema:NoteSchema = noteData[noteIndex];

            var strumline:Strumline = strumlines.members[noteSchema.lane];

            if (noteSchema.time > conductor.time + getSpawnDistance(noteSchema.lane))
                break;

            var note:Note = notes.recycle(Note, noteConstructor);

            note.visible = true;
        
            note.time = noteSchema.time;

            note.direction = noteSchema.direction;

            note.length = noteSchema.length;

            note.lane = noteSchema.lane;

            note.kind = noteSchema.kind;
            
            note.status = MOVING;

            note.playSplash = false;

            note.droppedTime = 0.0;

            note.sustain = null;

            note.strumline = strumline;

            note.strum = strumline.strums.members[note.direction];

            note.animation.play(Note.DIRECTIONS[note.direction].toLowerCase());

            note.flipY = false;

            note.scale.set(0.7, 0.7);

            note.updateHitbox();

            note.setPosition(camera.viewRight, 0.0);

            notes.add(note);

            strumline.notes.add(note);

            strumline.onNoteSpawn.dispatch(note);

            if (noteSchema.length > 0.0)
            {
                var sustain:Sustain = sustains.recycle(Sustain, sustainConstructor);

                sustain.note = note;

                sustain.animation.play(Note.DIRECTIONS[note.direction].toLowerCase() + "HoldPiece");

                sustain.flipY = note.strum.downscroll;

                sustain.setGraphicSize(sustain.frameWidth * 0.7, note.length * strumline.scrollSpeed * 0.45);

                sustain.updateHitbox();

                sustain.setPosition(camera.viewRight, 0.0);

                sustains.add(sustain);

                strumline.sustains.add(sustain);

                note.sustain = sustain;

                var trail:SustainTrail = trails.recycle(SustainTrail, trailConstructor);

                trail.sustain = sustain;

                trail.animation.play(Note.DIRECTIONS[note.direction].toLowerCase() + "HoldTail");

                trail.flipY = note.strum.downscroll;

                trail.scale.set(0.7, 0.7);

                trail.updateHitbox();

                trail.setPosition(camera.viewRight, 0.0);

                trails.add(trail);

                strumline.trails.add(trail);

                sustain.trail = trail;
            }

            noteIndex++;
        }
    }

    public function noteConstructor():Note
    {
        return new Note();
    }

    public function sustainConstructor():Sustain
    {
        return new Sustain();
    }

    public function trailConstructor():SustainTrail
    {
        return new SustainTrail();
    }

    public function getStrumline(lane:Int):Strumline
    {
        return strumlines.members[lane];
    }

    public function getSpawnDistance(lane:Int):Float
    {
        var strumline:Strumline = getStrumline(lane);

        return FlxG.height / camera.zoom / strumline.scrollSpeed / 0.45;
    }

    public function clearNotesBefore(time:Float):Void
    {
        var notesToRemove:Array<NoteSchema> = new Array<NoteSchema>();

        for (i in 0 ... noteData.length)
        {
            var noteSchema:NoteSchema = noteData[i];

            if (noteIndex < i && noteSchema.time - getSpawnDistance(noteSchema.lane) < time)
                notesToRemove.push(noteSchema);
        }

        for (i in 0 ... notesToRemove.length)
            noteData.remove(notesToRemove[i]);
    }
}