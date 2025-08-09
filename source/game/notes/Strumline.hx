package game.notes;

import flixel.FlxG;

import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.sound.FlxSound;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal.FlxTypedSignal;

import core.AssetCache;
import core.Options;

import game.notes.events.GhostTapEvent;
import game.notes.events.NoteHitEvent;
import game.notes.events.SustainDropEvent;
import game.notes.events.SustainHoldEvent;

import music.Conductor;

using StringTools;

using flixel.util.FlxColorTransformUtil;

using util.ArrayUtil;
using util.MathUtil;

// TODO: Update scoring when a note is dropped? Maybe?
class Strumline extends FlxGroup
{
    public var conductor:Conductor;

    public var keys:Map<Int, Int>;

    public var keysHeld:Array<Bool>;

    public var strums:FlxTypedSpriteGroup<Strum>;

    public var spacing(default, set):Float;

    @:noCompletion
    function set_spacing(_spacing:Float):Float
    {   
        spacing = _spacing;

        for (i in 0 ... strums.members.length)
            strums.members[i].x = strums.x + spacing * i;

        return spacing;
    }

    public var notes:FlxTypedGroup<Note>;

    public var notesPendingRemoval:Array<Note>;

    public var sustains:FlxTypedGroup<Sustain>;

    public var trails:FlxTypedGroup<SustainTrail>;

    public var onNoteSpawn:FlxTypedSignal<(note:Note)->Void>;

    public var noteHitEvent:NoteHitEvent;

    public var onNoteHit:FlxTypedSignal<(event:NoteHitEvent)->Void>;

    public var onNoteMiss:FlxTypedSignal<(note:Note)->Void>;

    public var noteSplashes:FlxTypedGroup<NoteSplash>;

    public var onSustainHold:FlxTypedSignal<(event:SustainHoldEvent)->Void>;

    public var sustainHoldEvent:SustainHoldEvent;

    public var onSustainDrop:FlxTypedSignal<(event:SustainDropEvent)->Void>;

    public var sustainDropEvent:SustainDropEvent;

    public var onGhostTap:FlxTypedSignal<(event:GhostTapEvent)->Void>;

    public var ghostTapEvent:GhostTapEvent;

    public var scrollSpeed:Float;

    public var downscroll:Bool;

    public var botplay:Bool;

    public var characters:FlxTypedSpriteGroup<Character>;

    public var vocals:FlxSound;

    public var lastStep:Int;

    public function new(_conductor:Conductor):Void
    {
        super();

        conductor = _conductor;

        getKeys();

        keysHeld = [for (i in 0 ... 4) false];

        strums = new FlxTypedSpriteGroup<Strum>();

        add(strums);

        for (i in 0 ... 4)
        {
            var strum:Strum = new Strum(conductor);

            strum.strumline = this;

            strum.direction = i;

            strum.animation.play(Note.DIRECTIONS[strum.direction].toLowerCase() + "Static");

            strum.scale.set(0.7, 0.7);

            strum.updateHitbox();
            
            strums.add(strum);
        }

        spacing = 116.0;

        notes = new FlxTypedGroup<Note>();

        notes.active = false;

        add(notes);

        notesPendingRemoval = new Array<Note>();

        sustains = new FlxTypedGroup<Sustain>();

        sustains.active = false;

        insert(members.indexOf(notes), sustains);

        trails = new FlxTypedGroup<SustainTrail>();

        trails.active = false;

        insert(members.indexOf(sustains), trails);

        onNoteSpawn = new FlxTypedSignal<(note:Note)->Void>();

        noteHitEvent = new NoteHitEvent();

        onNoteHit = new FlxTypedSignal<(event:NoteHitEvent)->Void>();

        onNoteMiss = new FlxTypedSignal<(note:Note)->Void>();

        onSustainHold = new FlxTypedSignal<(event:SustainHoldEvent)->Void>();

        sustainHoldEvent = new SustainHoldEvent();

        onSustainDrop = new FlxTypedSignal<(event:SustainDropEvent)->Void>();

        sustainDropEvent = new SustainDropEvent();

        noteSplashes = new FlxTypedGroup<NoteSplash>();

        add(noteSplashes);

        onGhostTap = new FlxTypedSignal<(event:GhostTapEvent)->Void>();

        ghostTapEvent = new GhostTapEvent();

        scrollSpeed = 1.0;

        downscroll = Options.downscroll;

        botplay = false;

        lastStep = 0;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (botplay)
        {
            for (i in 0 ... notes.members.length)
            {
                var note:Note = notes.members[i];

                if (note.isHittable())
                    noteHit(note);
            }
        }
        else
        {
            for (k => v in keys)
            {
                var keyCode:Int = k;

                var direc:Int = v;

                if (FlxG.keys.checkStatus(keyCode, JUST_PRESSED))
                {
                    keysHeld[direc] = true;

                    var strum:Strum = strums.members[direc];

                    strum.animation.play(Note.DIRECTIONS[direc].toLowerCase() + "Press");

                    var note:Note = notes.getFirst((_note:Note) -> _note.isHittable() && _note.direction == direc);

                    if (note == null)
                        ghostTap(strum.direction);
                    else
                        noteHit(note);
                }

                if (FlxG.keys.checkStatus(keyCode, JUST_RELEASED))
                {
                    keysHeld[direc] = false;

                    var strum:Strum = strums.members[direc];

                    strum.animation.play(Note.DIRECTIONS[direc].toLowerCase() + "Static");
                }
            }
        }

        for (i in 0 ... notes.members.length)
        {
            var note:Note = notes.members[i];

            var hasMissed:Bool = conductor.time > note.time + note.latestTiming;

            if ((note.status == MOVING || note.status == DROPPING) && hasMissed)
            {
                if (note.status == MOVING)
                    noteMiss(note);
                else
                    sustainDrop(note, note.sustain);
            }

            var hasExpired:Bool = conductor.time > note.time + note.length + note.latestTiming;

            if (hasMissed && hasExpired)
                notesPendingRemoval.push(note);

            if (note.length == 0.0)
                continue;

            if (isHoldingNote(note))
                holdSustainNote(note, note.sustain, elapsed);
            else
            {
                if (note.status == HIT)
                {
                    if (note.status != DROPPING)
                    {
                        resizeSustainNote(note);

                        note.status = DROPPING;
                    }
                }

                if (note.status == DROPPING)
                {
                    note.colorTransform.setMultipliers(1.0, 1.0, 1.0, 1.0);

                    setStrumActive(note.direction, true);

                    note.droppedTime += 1000.0 * elapsed;

                    if (note.droppedTime >= note.latestTiming * 2.0)
                        sustainDrop(note, note.sustain);
                }
            }

            if (conductor.time >= note.time + note.length)
                finishSustainNote(note);
        }

        while (notesPendingRemoval.length > 0.0)
        {
            var note:Note = notesPendingRemoval.pop();

            notes.members.remove(note);

            note.kill();

            if (note.sustain != null)
            {
                sustains.members.remove(note.sustain);

                trails.members.remove(note.sustain.trail);
            }
        }

        notes.update(elapsed);

        sustains.update(elapsed);

        trails.update(elapsed);

        lastStep = conductor.step;
    }

    override function destroy():Void
    {
        super.destroy();

        keys = null;

        keysHeld = null;

        onNoteHit = cast FlxDestroyUtil.destroy(onNoteHit);

        onNoteMiss = cast FlxDestroyUtil.destroy(onNoteMiss);

        onSustainHold = cast FlxDestroyUtil.destroy(onSustainHold);

        onSustainDrop = cast FlxDestroyUtil.destroy(onSustainDrop);

        onNoteSpawn = cast FlxDestroyUtil.destroy(onNoteSpawn);

        onGhostTap = cast FlxDestroyUtil.destroy(onGhostTap);
    }

    public function getKeys():Map<Int, Int>
    {
        return keys =
        [
            for (i in 0 ... Note.DIRECTIONS.length)
                for (j in 0 ... Options.controls['NOTE:${Note.DIRECTIONS[i]}'].length)
                    Options.controls['NOTE:${Note.DIRECTIONS[i]}'][j] => i
        ];
    }

    public function resetStrums():Void
    {
        strums.forEach((strum:Strum) -> strum.animation.play(Note.DIRECTIONS[strum.direction].toLowerCase() + "Static", true));
    }

    public function setStrumActive(direc:Int, active:Bool):Void
    {
        var strum:Strum = strums.members[direc];

        strum.active = active;

        if (!active)
            strum.animation.finish();
    }

    public function noteHit(note:Note):Void
    {
        noteHitEvent.reset(note);

        onNoteHit.dispatch(noteHitEvent);

        note.status = HIT;

        note.playSplash = noteHitEvent.playSplash;

        var strum:Strum = note.strum;

        strum.confirmTimer = 0.0;
        
        strum.animation.play(Note.DIRECTIONS[note.direction].toLowerCase() + "Confirm", true);

        if (note.length > 0.0)
        {
            note.colorTransform.setMultipliers(1.75, 1.75, 1.75, 1.75);

            resizeSustainNote(note);

            setStrumActive(note.direction, false);
        }
        else
        {
            notesPendingRemoval.push(note);

            if (note.playSplash)
                playSplash(note);
        }   

        playCharSingAnims(note, note.direction, false);

        if (vocals != null)
            vocals.volume = 1.0;
    }

    public function noteMiss(note:Note):Void
    {
        onNoteMiss.dispatch(note);

        note.status = MISSED;

        playCharMissAnims(note, note.direction);

        if (vocals != null)
            vocals.volume = 0.0;

        var _noteMiss:FlxSound = FlxG.sound.play(AssetCache.getSound('game/GameState/noteMiss${FlxG.random.int(0, 2)}'), 0.15);

        _noteMiss.onComplete = _noteMiss.kill;
    }

    public function playSplash(note:Note):Void
    {
        var splash:NoteSplash = noteSplashes.recycle(NoteSplash, () -> new NoteSplash());

        splash.play(note.strum.direction, note.length > 0.0);

        splash.centerTo(note.strum);
    }

    public function isHoldingNote(note:Note):Bool
    {
        if (note.length == 0.0 || (note.status != HIT && note.status != DROPPING))
            return false;

        if (botplay)
            return true;

        return keysHeld[note.direction];
    }

    public function holdSustainNote(note:Note, sustain:Sustain, elapsed:Float):Void
    {
        sustainHoldEvent.reset(note, sustain, elapsed);

        onSustainHold.dispatch(sustainHoldEvent);

        if (lastStep != conductor.step || note.status != HIT)
        {
            note.status = HIT;

            note.droppedTime = 0.0;
            
            var strum:Strum = note.strum;

            strum.confirmTimer = 0.0;

            strum.animation.play(Note.DIRECTIONS[strum.direction].toLowerCase() + "Confirm", true);

            note.colorTransform.setMultipliers(1.75, 1.75, 1.75, 1.75);

            setStrumActive(note.direction, false);
            
            if (vocals != null)
                vocals.volume = 1.0;

            playCharSingAnims(note, note.direction, true);
        }
    }

    public function sustainDrop(note:Note, sustain:Sustain):Void
    {
        sustainDropEvent.reset(note, sustain);

        onSustainDrop.dispatch(sustainDropEvent);

        note.status = MISSED;

        playCharMissAnims(note, note.direction);

        if (vocals != null)
            vocals.volume = 0.0;

        var _noteMiss:FlxSound = FlxG.sound.play(AssetCache.getSound('game/GameState/noteMiss${FlxG.random.int(0, 2)}'), 0.15);

        _noteMiss.onComplete = _noteMiss.kill;
    }

    public function resizeSustainNote(note:Note):Void
    {
        note.length += note.time - conductor.time;

        note.time = conductor.time;

        if (note.length == 0.0)
            finishSustainNote(note);
    }

    public function finishSustainNote(note:Note):Void
    {
        setStrumActive(note.direction, true);

        if (note.status == HIT)
            notesPendingRemoval.push(note);

        if (note.droppedTime == 0.0)
        {
            if (!note.hasDropped && note.playSplash)
                playSplash(note);
        }
        else
        {
            var anim:String = Note.DIRECTIONS[note.strum.direction].toLowerCase() + "Static";

            note.strum.animation.play(anim, true);
        }
    }

    public function ghostTap(direction:Int):Void
    {
        ghostTapEvent.reset(direction);

        onGhostTap.dispatch(ghostTapEvent);

        if (!ghostTapEvent.ghostTapping)
        {
            var _noteMiss:FlxSound = FlxG.sound.play(AssetCache.getSound('game/GameState/noteMiss${FlxG.random.int(0, 2)}'), 0.15);

            _noteMiss.onComplete = _noteMiss.kill;

            playCharMissAnims(null, direction);

            if (vocals != null)
                vocals.volume = 0.0;
        }
    }

    public function playCharSingAnims(note:Note, direction:Int, hold:Bool):Void
    {
        if (characters == null)
            return;

        for (i in 0 ... characters.members.length)
        {
            var character:Character = characters.members[i];

            if (note.kind == "no-animation" || character.skipSing)
                continue;

            character.singTimer = 0.0;

            var animSuffix:String = "";

            if (note.kind == "alt-animation")
                animSuffix = "-alt";

            var direcStr:String = Note.DIRECTIONS[note.direction];

            if (hold && character.animation.name.contains(direcStr))
                continue;

            var animToPlay:String = 'Sing${direcStr}${animSuffix}';

            if (character.animation.exists(animToPlay))
                character.animation.play(animToPlay, true);
            else
            {
                animToPlay = 'Sing${direcStr}';

                if (character.animation.exists(animToPlay))
                    character.animation.play(animToPlay, true);
            }
        }
    }

    public function playCharMissAnims(note:Note, direction:Int):Void
    {
        if (characters == null)
            return;

        for (i in 0 ... characters.members.length)
        {
            var character:Character = characters.members[i];

            if ((note != null && note.kind == "no-animation") || character.skipSing)
                continue;

            character.singTimer = 0.0;

            var animSuffix:String = "";

            if (note != null)
            {
                if (note.kind == "alt-animation")
                    animSuffix = "-alt";
            }

            var direcStr:String = Note.DIRECTIONS[note.direction];

            var animToPlay:String = 'Sing${direcStr}MISS${animSuffix}';

            if (character.animation.exists(animToPlay))
                character.animation.play(animToPlay, true);
            else
            {
                animToPlay = 'Sing${direcStr}MISS';

                if (character.animation.exists(animToPlay))
                    character.animation.play(animToPlay, true);
            }
        }
    }
}