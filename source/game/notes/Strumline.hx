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
import game.notes.events.SustainHoldEvent;
import game.notes.events.SustainMissEvent;

import music.Conductor;

using StringTools;

using util.ArrayUtil;
using util.MathUtil;

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

    public var onSustainMiss:FlxTypedSignal<(event:SustainMissEvent)->Void>;

    public var sustainMissEvent:SustainMissEvent;

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

        onSustainMiss = new FlxTypedSignal<(event:SustainMissEvent)->Void>();

        sustainMissEvent = new SustainMissEvent();

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

        if (keys != null)
        {
            for (k => v in keys)
            {
                var dir:Int = v;

                if (FlxG.keys.checkStatus(k, JUST_PRESSED))
                {
                    keysHeld[dir] = true;

                    var strum:Strum = strums.members[dir];

                    strum.animation.play(Note.DIRECTIONS[dir].toLowerCase() + "Press");

                    var note:Note = notes.getFirst((_note:Note) -> strum.direction == _note.direction && _note.isHittable());

                    if (note == null)
                        ghostTap(strum.direction);
                    else
                        noteHit(note);
                }

                if (FlxG.keys.checkStatus(k, JUST_RELEASED))
                {
                    keysHeld[dir] = false;

                    var strum:Strum = strums.members[dir];

                    strum.animation.play(Note.DIRECTIONS[dir].toLowerCase() + "Static");
                }
            }
        }

        for (i in 0 ... notes.members.length)
        {
            var note:Note = notes.members[i];

            if (botplay && note.isHittable())
                noteHit(note);

            var isLate:Bool = conductor.time > note.time + note.latestTiming;

            if (!botplay && note.status == IDLING && isLate)
                noteMiss(note, false);

            var isExpired:Bool = conductor.time > (note.time + note.length + (note.latestTiming / scrollSpeed));

            if (isLate && isExpired)
                notesPendingRemoval.push(note);

            if (note.length > 0.0 && note.status != IDLING && !note.finishedHold)
            {
                if (isHolding(note))
                {
                    holdSustainNote(note, note.sustain, elapsed);

                    note.unholdTime = Math.max(0.0, note.unholdTime - elapsed * 1000.0);
                }
                else
                {
                    if (note.status == MISSED)
                    {
                        if (note.sustain != null)
                            missSustainNote(note, note.sustain, elapsed);
                    }
                    else
                    {
                        note.unholdTime += elapsed * 1000.0;

                        if (note.unholdTime > note.latestTiming)
                            noteMiss(note, true);
                    }
                }
    
                if (conductor.time >= note.time + note.length)
                    finishSustainNote(note);
            }
        }

        /**
         * TODO: It seems like this fixes rendering bugs. However I need confirmation and if so, I want to figure out why.
        */
        notes.update(elapsed);

        sustains.update(elapsed);

        trails.update(elapsed);

        lastStep = conductor.step;
    }

    override function destroy():Void
    {
        super.destroy();

        clearKeys();

        keysHeld = null;

        onNoteHit = cast FlxDestroyUtil.destroy(onNoteHit);

        onNoteMiss = cast FlxDestroyUtil.destroy(onNoteMiss);

        onSustainHold = cast FlxDestroyUtil.destroy(onSustainHold);

        onSustainMiss = cast FlxDestroyUtil.destroy(onSustainMiss);

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

    public function clearKeys():Void
    {
        keys = null;
    }

    public function resetStrums():Void
    {
        strums.forEach((strum:Strum) -> strum.animation.play(Note.DIRECTIONS[strum.direction].toLowerCase() + "Static", true));
    }

    public function noteHit(note:Note):Void
    {
        noteHitEvent.reset(note);

        onNoteHit.dispatch(noteHitEvent);

        note.status = HIT;

        note.playSplash = noteHitEvent.playSplash;

        if (note.length > 0.0)
            note.visible = false;
        else
        {
            notesPendingRemoval.push(note);

            if (note.playSplash)
                playSplash(note);
        }

        if (note.length > 0.0)
            resizeSustainNote(note);

        var strum:Strum = note.strum;

        strum.confirmTimer = 0.0;
        
        strum.animation.play(Note.DIRECTIONS[note.direction].toLowerCase() + "Confirm", true);

        playCharSingAnims(note, note.direction, false);

        if (vocals != null)
            vocals.volume = 1.0;
    }

    public function noteMiss(note:Note, resize:Bool):Void
    {
        onNoteMiss.dispatch(note);

        if (resize)
            resizeSustainNote(note);

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

    public function isHolding(note:Note):Bool
    {
        return note.status != MISSED && (botplay || keysHeld[note.direction] || (note.status == HIT && conductor.time >= note.time + note.length));
    }

    public function holdSustainNote(note:Note, sustain:Sustain, elapsed:Float):Void
    {
        sustainHoldEvent.reset(note, sustain, elapsed);

        onSustainHold.dispatch(sustainHoldEvent);

        if (lastStep != conductor.step || note.status != HIT)
        {
            note.status = HIT;
            
            var strum:Strum = note.strum;

            strum.confirmTimer = 0.0;

            strum.animation.play(Note.DIRECTIONS[strum.direction].toLowerCase() + "Confirm", true);
            
            if (vocals != null)
                vocals.volume = 1.0;

            playCharSingAnims(note, note.direction, true);
        }
    }

    public function missSustainNote(note:Note, sustain:Sustain, elapsed:Float):Void
    {
        sustainMissEvent.reset(note, sustain, elapsed);

        onSustainMiss.dispatch(sustainMissEvent);
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
        if (note.status == HIT)
            notesPendingRemoval.push(note);

        if (!botplay)
        {
            if (note.unholdTime == 0.0)
            {
                if (note.playSplash)
                    playSplash(note);
            }
            else
            {
                var anim:String = Note.DIRECTIONS[note.strum.direction].toLowerCase() + "Static";

                note.strum.animation.play(anim, true);

                if (note.status != MISSED)
                    noteMiss(note, false);
            }
        }

        note.finishedHold = true;
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

            var translatedDir:String = Note.DIRECTIONS[note.direction];

            if (hold && character.animation.name.contains(translatedDir))
                continue;

            var animToPlay:String = 'Sing${translatedDir}${animSuffix}';

            if (character.animation.exists(animToPlay))
                character.animation.play(animToPlay, true);
            else
            {
                animToPlay = 'Sing${translatedDir}';

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

            var translatedDir:String = Note.DIRECTIONS[note.direction];

            var animToPlay:String = 'Sing${translatedDir}MISS${animSuffix}';

            if (character.animation.exists(animToPlay))
                character.animation.play(animToPlay, true);
            else
            {
                animToPlay = 'Sing${translatedDir}MISS';

                if (character.animation.exists(animToPlay))
                    character.animation.play(animToPlay, true);
            }
        }
    }
}