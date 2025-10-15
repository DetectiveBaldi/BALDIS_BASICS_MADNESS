package editors.chart;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup;

import core.AssetCache;
import core.Paths;

import data.Chart;

import game.notes.Note;

import music.Conductor;

import util.TimingUtil;

using util.MathUtil;

// A `NoteGroup` is similar to a `game.notes.Note` object, except that it updates the note, sustain and sustain trail
    // all from one instance.
class NoteGroup extends FlxSpriteGroup
{
    public var conductor:Conductor;

    public var noteData:NoteData;

    public var note:FlxSprite;

    public var sustain:FlxSprite;

    public var trail:FlxSprite;

    public function new(beatDispatcher:IBeatDispatcher, noteData:NoteData):Void
    {
        super();

        conductor = beatDispatcher.conductor;

        this.noteData = noteData;

        note = new FlxSprite();

        note.active = false;

        note.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/notes/Note/default"),
            Paths.image(Paths.xml("game/notes/Note/default")));

        var directionStr:String = Note.DIRECTIONS[noteData.direction].toLowerCase();

        note.animation.addByPrefix(directionStr, '${directionStr}0', 24.0, false);

        note.animation.play(directionStr);

        note.setGraphicSize(40.0, 40.0);

        note.updateHitbox();

        note.setGraphicSize(64.0, 64.0);

        add(note);

        sustain = new FlxSprite();

        sustain.active = false;

        sustain.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/notes/Note/default"),
            Paths.image(Paths.xml("game/notes/Note/default")));

        sustain.animation.addByPrefix('${directionStr}HoldPiece', '${directionStr}HoldPiece0', 24.0, false);

        sustain.animation.play('${directionStr}HoldPiece');

        sustain.scale.copyFrom(note.scale);

        sustain.updateHitbox();

        sustain.setPosition(sustain.getCenterX(note), note.height * 0.5);

        insert(0, sustain);

        trail = new FlxSprite();

        trail.active = false;

        trail.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/notes/Note/default"),
            Paths.image(Paths.xml("game/notes/Note/default")));

        trail.animation.addByPrefix('${directionStr}HoldTail', '${directionStr}HoldTail0', 24.0, false);

        trail.animation.play('${directionStr}HoldTail');

        trail.scale.copyFrom(note.scale);

        trail.updateHitbox();

        trail.x = trail.getCenterX(sustain);

        insert(1, trail);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        sustain.visible = noteData.length != 0.0;

        trail.visible = noteData.length != 0.0;

        var stepLength:Float = conductor.getTimingPointAtTime(noteData.time).beatLength * 0.25;

        var height:Float = 40.0 * (noteData.length / stepLength);

        sustain.setGraphicSize(sustain.width, height);

        sustain.updateHitbox();

        trail.y = sustain.y + sustain.height;
    }
}