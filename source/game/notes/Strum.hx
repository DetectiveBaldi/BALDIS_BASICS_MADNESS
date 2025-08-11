package game.notes;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import core.AssetCache;
import core.Options;
import core.Paths;

import music.Conductor;

using StringTools;

class Strum extends FlxSprite
{
    public var conductor:Conductor;

    public var strumline:Strumline;

    public var direction:Int;

    public var downscroll:Bool;

    public var holdTimer:Float;

    public function new(_conductor:Conductor, x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        conductor = _conductor;

        frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/notes/Strum/default"),
            Paths.image(Paths.xml("game/notes/Strum/default")));
        
        for (i in 0 ... Note.DIRECTIONS.length)
        {
            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase() + "Static", Note.DIRECTIONS[i].toLowerCase() + "Static0", 24.0, false);

            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase() + "Press", Note.DIRECTIONS[i].toLowerCase() + "Press0", 24.0, false);
            
            animation.addByPrefix(Note.DIRECTIONS[i].toLowerCase() + "Confirm", Note.DIRECTIONS[i].toLowerCase() + "Confirm0", 24.0, false);
        }

        direction = 0;

        downscroll = Options.downscroll;

        holdTimer = 0.0;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (conductor == null)
            return;

        if ((animation.name ?? "").endsWith("Confirm"))
        {
            holdTimer += elapsed;

            if (holdTimer >= conductor.stepLength * 0.001)
            {
                holdTimer = 0.0;

                animation.play(Note.DIRECTIONS[direction].toLowerCase() + (strumline.botplay ? "Static" : "Press"));
            }
        }
        else
            holdTimer = 0.0;
    }
}