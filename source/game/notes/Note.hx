package game.notes;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import core.Assets;
import core.Paths;

using util.ArrayUtil;

class Note extends FlxSprite
{
    public static final DIRECTIONS:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];

    public static var NOTE_FRAMES:FlxAtlasFrames;

    public var time:Float;

    public var direction:Int;

    public var length(default, set):Float;

    @:noCompletion
    function set_length(_length:Float):Float
    {
        length = Math.max(_length, 0.0);

        return length;
    }

    public var lane:Int;

    public var kind:String;

    public var status:NoteStatus;

    public var playSplash:Bool;

    public var finishedHold:Bool;

    public var unholdTime:Float;

    public var latestTiming:Float;

    public var sustain:Sustain;

    public var strumline:Strumline;

    public var strum:Strum;

    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        NOTE_FRAMES ??= FlxAtlasFrames.fromSparrow(Assets.getGraphic("game/notes/Note/default"),
            Paths.image(Paths.xml("game/notes/Note/default")));

        frames = NOTE_FRAMES;

        for (i in 0 ... DIRECTIONS.length)
            animation.addByPrefix(DIRECTIONS[i].toLowerCase(), DIRECTIONS[i].toLowerCase() + "0", 24.0, false);

        antialiasing = true;

        time = 0.0;

        direction = 0;

        length = 0.0;

        lane = 0;

        kind = "";

        status = IDLING;

        playSplash = false;

        finishedHold = false;

        unholdTime = 0.0;

        latestTiming = Rating.list.last().timing;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        x = strum.getMidpoint().x - width * 0.5;

        y = strum.y;

        if (status != HIT || length <= 0.0)
            y += (time - strumline.conductor.time) * (strumline.downscroll ? -1 : 1) * strumline.scrollSpeed * 0.45;

        alpha = strumline.strums.alpha;
    }

    override function kill():Void
    {
        super.kill();

        sustain?.kill();

        sustain?.trail.kill();
    }

    public function isHittable():Bool
    {
        return status == IDLING && ((strumline.botplay && time <= strumline.conductor.time) || (!strumline.botplay && Math.abs(time - strumline.conductor.time) <= latestTiming));
    }
}

enum NoteStatus
{
    IDLING;

    HIT;

    MISSED;
}