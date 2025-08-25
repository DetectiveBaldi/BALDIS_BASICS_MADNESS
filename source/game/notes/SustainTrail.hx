package game.notes;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import core.AssetCache;
import core.Paths;

class SustainTrail extends FlxSprite
{
    public var sustain:Sustain;

    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/notes/Note/default"),
            Paths.image(Paths.xml("game/notes/Note/default")));
        
        for (i in 0 ... Note.DIRECTIONS.length)
            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase() + "HoldTail", Note.DIRECTIONS[i].toLowerCase() + "HoldTail0", 24.0, false);
    }
}