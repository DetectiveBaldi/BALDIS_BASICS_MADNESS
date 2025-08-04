package game.notes;

import flixel.FlxCamera;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;

import flixel.util.FlxColor;

import core.Assets;
import core.Paths;

/**
 * TODO: Patch sustain clipping when note is not held.
 * TODO: Replace coloring during misses with an alpha decrease.
 */
class Sustain extends FlxSprite
{
    public var note:Note;

    public var trail:SustainTrail;

    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        frames = Note.NOTE_FRAMES;

        for (i in 0 ... Note.DIRECTIONS.length)
            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase() + "HoldPiece", Note.DIRECTIONS[i].toLowerCase() + "HoldPiece0", 24.0, false);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        var length:Float = note.length;

        if (note.status == HIT)
            length -= note.strumline.conductor.time - note.time;

        var sustainHeight:Float = Math.max(length * 0.45 * note.strumline.scrollSpeed, 0.0);

        setGraphicSize(frameWidth * 0.7, sustainHeight);

        updateHitbox();

        x = note.getMidpoint().x - width * 0.5;

        y = note.y + note.height * 0.5;

        if (note.strumline.downscroll)
            y -= sustainHeight;

        trail.x = getMidpoint().x - trail.width * 0.5;

        trail.y = y + sustainHeight;

        if (note.strumline.downscroll)
            trail.y -= sustainHeight + trail.height;

        trail.y -= 2.0 * (note.strumline.downscroll ? -1.0 : 1.0);

        alpha = note.alpha;

        trail.color = color;

        trail.alpha = alpha;
    }
}