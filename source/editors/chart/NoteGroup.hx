package editors.chart;

import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

import data.Chart;

// A `NoteGroup` is similar to a `game.notes.Note` object, except that it updates and draws the sustain and sustain trail
    // all from one instance.
class NoteGroup extends FlxSpriteGroup
{
    public var note:FlxSprite;

    public var sustain:FlxSprite;

    public var trail:FlxSprite;

    public var noteData:NoteData;

    public function new():Void
    {
        super();

        var kind:NoteKindData = {type: "", altAnimation: false, noAnimation: false, specSing: false, charIds: null}

        noteData = {time: 0.0, direction: -1, length: 0.0, lane: -1, kind: kind}
    }
}