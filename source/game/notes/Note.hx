package game.notes;

import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import core.Assets;
import core.Paths;

import data.NoteSkin;
import data.NoteSkin.RawNoteSkin;

class Note extends FlxSprite
{
    public static final DIRECTIONS:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];

    public var skin(default, set):RawNoteSkin;

    @:noCompletion
    function set_skin(_skin:RawNoteSkin):RawNoteSkin
    {
        skin = _skin;

        var pngPath:String = Paths.image(Paths.png('game/notes/Note/${skin.png}'));

        var xmlPath:String = Paths.image(Paths.xml('game/notes/Note/${skin.xml}'));

        switch (skin.format ?? "".toLowerCase():String)
        {
            case "sparrow": frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(pngPath), xmlPath);

            case "texturepackerxml": frames = FlxAtlasFrames.fromTexturePackerXml(Assets.getGraphic(pngPath), xmlPath);
        }

        for (i in 0 ... DIRECTIONS.length)
        {
            animation.addByPrefix(DIRECTIONS[i].toLowerCase(), DIRECTIONS[i].toLowerCase() + "0", 24.0, false);

            animation.addByPrefix(DIRECTIONS[i].toLowerCase() + "HoldPiece", DIRECTIONS[i].toLowerCase() + "HoldPiece0", 24.0, false);
            
            animation.addByPrefix(DIRECTIONS[i].toLowerCase() + "HoldTail", DIRECTIONS[i].toLowerCase() + "HoldTail0", 24.0, false);
        }

        antialiasing = _skin.antialiasing ?? true;

        return skin;
    }

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

    public var status:NoteStatus;

    public var showPop:Bool;

    public var finishedHold:Bool;

    public var unholdTime:Float;

    public var sustain:Sustain;

    public var strumline:Strumline;

    public var strum:Strum;

    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        skin = NoteSkin.get("default");

        antialiasing = true;

        time = 0.0;

        direction = 0;

        length = 0.0;

        lane = 0;

        status = IDLING;

        showPop = false;

        finishedHold = false;

        unholdTime = 0.0;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        y = strum.y;

        x = strum.getMidpoint().x - width * 0.5;

        if (status != HIT || length <= 0.0)
            y += (time - strumline.conductor.time) * (strumline.downscroll ? -1 : 1) * strumline.scrollSpeed * 0.45;
    }

    override function kill():Void
    {
        super.kill();

        sustain?.kill();

        sustain?.trail?.kill();
    }

    public function isHittable():Bool
    {
        return status == IDLING && ((strumline.automated && time <= strumline.conductor.time) || (!strumline.automated && Math.abs(time - strumline.conductor.time) <= 166.6));
    }
}

enum NoteStatus
{
    IDLING;

    HIT;

    MISSED;
}