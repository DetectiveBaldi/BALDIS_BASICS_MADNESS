package game.notes;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.util.FlxColor;

import core.Assets;
import core.Paths;

class Sustain extends FlxSprite
{
    public var note:Note;

    public var trail:SustainTrail;

    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        // TODO: Update to support custom note configuration assets.

        frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.image(Paths.png("game/notes/Note/default"))), Paths.image(Paths.xml("game/notes/Note/default")));

        for (i in 0 ... Note.DIRECTIONS.length)
        {
            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase(), Note.DIRECTIONS[i].toLowerCase() + "0", 24.0, false);

            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase() + "HoldPiece", Note.DIRECTIONS[i].toLowerCase() + "HoldPiece0", 24.0, false);
            
            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase() + "HoldTail", Note.DIRECTIONS[i].toLowerCase() + "HoldTail0", 24.0, false);
        }
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        var length:Float = note.length;

        if (note.status == HIT)
            length -= note.strumline.conductor.time - note.time;

        var _height:Float = Math.max(length * 0.45 * note.strumline.scrollSpeed, 0.0);

        setGraphicSize(frameWidth * 0.7, _height);

        updateHitbox();

        x = note.getMidpoint().x - width * 0.5;

        y = note.y + note.height * 0.5;

        if (note.strumline.downscroll)
            y -= _height;

        trail.x = getMidpoint().x - trail.width * 0.5;

        trail.y = y + _height;

        if (note.strumline.downscroll)
            trail.y -= _height + trail.height;

        trail.y -= 2.0 * (note.strumline.downscroll ? -1.0 : 1.0);

        if (note.status == MISSED)
            color = 0xFFB3B3B3;
        else
            color = FlxColor.WHITE;

        alpha = note.alpha;

        trail.color = color;

        trail.alpha = alpha;
    }
}