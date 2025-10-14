package editors.chart;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import core.AssetCache;
import core.Paths;

import data.Chart;

import game.notes.Note;

using util.MathUtil;

// A `NoteGroup` is similar to a `game.notes.Note` object, except that it updates the note, sustain and sustain trail
    // all from one instance.
class NoteGroup extends FlxSpriteGroup
{
    public var noteData:NoteData;

    public var note:FlxSprite;

    public var sustain:FlxSprite;

    public var trail:FlxSprite;

    public function new(noteData:NoteData):Void
    {
        super();

        this.noteData = noteData;

        note = new FlxSprite();

        note.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/notes/Note/default"),
            Paths.image(Paths.xml("game/notes/Note/default")));

        var directionStr:String = Note.DIRECTIONS[noteData.direction].toLowerCase();

        note.animation.addByPrefix(directionStr, '${directionStr}0', 24.0, false);

        note.animation.play(directionStr);

        note.setGraphicSize(40.0, 40.0);

        note.updateHitbox();

        note.setGraphicSize(64.0, 64.0);

        add(note);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        return;

        sustain.setGraphicSize(40.0, noteData.length);

        sustain.updateHitbox();

        sustain.setPosition(sustain.getCenterX(note), note.y + note.height * 0.5);

        trail.setPosition(trail.getCenterX(sustain), y + noteData.length - 2.0);
    }
}