package editors.chart;

import haxe.ds.ArraySort;

import openfl.net.FileReference;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Paths;

import data.Chart;
import data.ChartLoader;
import data.LevelData;

import extendable.TransitionState;

import music.Conductor;

import util.MouseBitmaps;

using util.ArrayUtil;
using util.MathUtil;
using util.TimingUtil;

class ChartEditorState extends TransitionState implements IBeatDispatcher
{
    public var level:LevelData;

    public var conductor:Conductor;

    public var chart:Chart;

    public var instrumental:FlxSound;

    public var mainVocals:FlxSound;

    public var opponentVocals:FlxSound;

    public var playerVocals:FlxSound;

    public var grid:ChartEditorGrid;

    public var songPosBar:FlxSprite;

    public var gridPosHighlight:FlxSprite;

    public var notes:FlxTypedGroup<NoteGroup>;

    public var notesSelected:Array<NoteGroup>;

    public var hasUnsavedChanges:Bool;

    public function new(level:LevelData):Void
    {
        super();

        this.level = level;
    }

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        MouseBitmaps.setMouseBitmap(HAND);

        bgColor = FlxColor.GRAY;

        camera.zoom = 1.25;

        conductor = new Conductor();

        loadChart();

        loadSong();

        startSong();

        pauseMusic();

        var songLengthInSteps:Float = conductor.getStepAt(instrumental.length);

        var gridHeight:Int = Math.floor(songLengthInSteps * 40.0);
        
        grid = new ChartEditorGrid();

        grid.height = gridHeight;

        grid.x = grid.getCenterX() - 40.0;

        add(grid);

        songPosBar = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        songPosBar.scale.set(400.0, 5.0);

        songPosBar.updateHitbox();

        songPosBar.setPosition(grid.x, grid.y);

        add(songPosBar);

        camera.follow(songPosBar, LOCKON);

        gridPosHighlight = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);

        gridPosHighlight.scale.set(40.0, 40.0);

        gridPosHighlight.updateHitbox();

        add(gridPosHighlight);

        notes = new FlxTypedGroup<NoteGroup>();

        add(notes);

        addNotes();

        notesSelected = new Array<NoteGroup>();

        hasUnsavedChanges = false;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.wheel != 0.0)
        {
            var wheel:Int = FlxG.mouse.wheel;

            wheel *= -1;

            var add:Float = wheel * (conductor.stepLength * 0.25);

            var time:Float = conductor.time + add;

            setMusicTime(time);

            conductor.time = instrumental.time;
        }

        if (FlxG.keys.justPressed.SPACE)
        {
            if (instrumental.playing)
                pauseMusic();
            else
                resumeMusic();

            resyncVocals();
        }

        if (instrumental.playing)
        {
            var timeToUpdateTo:Float = conductor.time + 1000.0 * elapsed;

            conductor.update(timeToUpdateTo);

            var conductorDesync:Float = Math.abs(conductor.time - instrumental.time);

            if (conductorDesync >= 20.0)
                conductor.time = instrumental.time;

            var mainVocalsDesync:Float = 0.0;

            if (mainVocals != null)
                mainVocalsDesync = Math.abs(mainVocals.time - instrumental.time);

            var opponentVocalsDesync:Float = 0.0;

            if (opponentVocals != null)
                opponentVocalsDesync = Math.abs(opponentVocals.time - instrumental.time);

            var playerVocalsDesync:Float = 0.0;

            if (playerVocals != null)
                playerVocalsDesync = Math.abs(playerVocals.time - instrumental.time);

            if (mainVocalsDesync >= 20.0 || opponentVocalsDesync >= 20.0 || playerVocalsDesync >= 20.0)
                resyncVocals();
        }

        songPosBar.y = getPosFromTime(conductor.time);

        gridPosHighlight.visible = FlxG.mouse.overlaps(grid, camera);

        var highlightX:Float = Math.floor((FlxG.mouse.x - grid.x) / 40.0) * 40.0 + grid.x;

        var highlightY:Float = 0.0;

        if (FlxG.keys.pressed.SHIFT)
            highlightY = FlxG.mouse.y;
        else
            highlightY = Math.floor((FlxG.mouse.y - grid.y) / 40.0) * 40.0 + grid.y;

        gridPosHighlight.setPosition(highlightX, highlightY);

        if (FlxG.mouse.overlaps(grid) && (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight))
        {
            var time:Float = getTimeFromPos(gridPosHighlight.y);

            var direction:Int = Math.floor((FlxG.mouse.x - grid.x - 40.0) / 40.0);

            if (direction != -1.0)
            {
                var lane:Int = Math.floor(direction * 0.25);

                direction %= 4;

                var noteToSelect:NoteGroup = notes.members.last((noteGroup:NoteGroup) -> FlxG.mouse.overlaps(noteGroup, camera) &&
                    noteGroup.noteData.direction == direction);

                if (noteToSelect == null)
                {
                    var noteData:NoteData =
                    {
                        time: time,

                        direction: direction,

                        length: 0.0,

                        lane: lane,

                        kind: null
                    }

                    chart.notes.push(noteData);

                    var note:NoteGroup = new NoteGroup(this, noteData);

                    note.setPosition(gridPosHighlight.x, gridPosHighlight.y);

                    notes.add(note);

                    sortNotes();

                    clearNoteSelect();

                    addNoteSelect(note);
                }
                else
                {
                    var note:NoteGroup = noteToSelect;

                    if (FlxG.mouse.justPressed && !FlxG.keys.pressed.SHIFT)
                    {
                        chart.notes.remove(note.noteData);

                        notes.remove(note, true);

                        sortNotes();

                        note.kill();

                        removeNoteSelect(note);

                        hasUnsavedChanges = true;
                    }
                    else
                        addNoteSelect(note);

                    sortSelectedNotes();
                }
            }
        }

        if (FlxG.keys.justPressed.DELETE)
        {
            for (i in 0 ... notesSelected.length)
            {
                var note:NoteGroup = notesSelected[i];

                notes.remove(note, true);
            }

            sortNotes();

            notesSelected.resize(0);

            hasUnsavedChanges = true;
        }

        var fade:Float = 0.75 + 0.25 * Math.sin(FlxG.game.ticks * 0.001 * 1.5);

        for (i in 0 ... notesSelected.length)
        {
            var note:NoteGroup = notesSelected[i];

            note.color = FlxColor.fromRGBFloat(fade, fade, fade, 1.0);
        }

        for (i in 0 ... notes.members.length)
        {
            var note:NoteGroup = notes.members[i];

            note.active = note.isOnScreen(camera);
        }

        if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
        {
            var speed:Float = FlxG.keys.pressed.SHIFT ? 16.0 : 8.0;

            var add:Float = conductor.stepLength * ((FlxG.keys.pressed.W ? -1.0 : 1.0) * speed) * elapsed;

            setMusicTime(conductor.time + add);

            conductor.time = instrumental.time;
        }
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function stepHit(step:Int):Void
    {

    }

    public function beatHit(beat:Int):Void
    {

    }

    public function measureHit(measure:Int):Void
    {

    }

    public function loadChart():Void
    {
        chart = ChartLoader.readPath(Paths.data(level.getClassPath()));

        chart.notes.sortTimed();

        chart.events.sortTimed();

        chart.timingPoints.sortTimed();
        
        conductor.writeTimingPointData(chart.timingPoints);

        conductor.calibrateTimingPoints();

        #if FLX_DEBUG
        FlxG.watch.add(conductor, "time", "Time");

        FlxG.watch.add(conductor, "step", "Step");

        FlxG.watch.add(conductor, "beat", "Beat");

        FlxG.watch.add(conductor, "measure", "Measure");
        #end
    }

    public function loadSong():Void
    {
        var songPath:String = '${level.getClassPath()}/';

        instrumental = FlxG.sound.load(AssetCache.getMusic('${songPath}Instrumental'), 1.0, true);

        if (Paths.exists(Paths.music(Paths.ogg('${songPath}Vocals-Main'))))
            mainVocals = FlxG.sound.load(AssetCache.getMusic('${songPath}Vocals-Main'), 1.0, true);
        else
        {
            if (Paths.exists(Paths.music(Paths.ogg('${songPath}Vocals-Opponent'))))
                opponentVocals = FlxG.sound.load(AssetCache.getMusic('${songPath}Vocals-Opponent'), 1.0, true);

            if (Paths.exists(Paths.music(Paths.ogg('${songPath}Vocals-Player'))))
                playerVocals = FlxG.sound.load(AssetCache.getMusic('${songPath}Vocals-Player'), 1.0, true);
        }
    }

    public function startSong():Void
    {
        instrumental.play();

        mainVocals?.play();

        opponentVocals?.play();

        playerVocals?.play();
    }

    public function pauseMusic():Void
    {
        instrumental.pause();

        mainVocals?.pause();

        opponentVocals?.pause();

        playerVocals?.pause();
    }

    public function resumeMusic():Void
    {
        instrumental.resume();

        mainVocals?.resume();

        opponentVocals?.resume();

        playerVocals?.resume();
    }

    public function setMusicTime(v:Float):Void
    {
        if (instrumental.playing)
            pauseMusic();

        if (v < 0.0)
            v = instrumental.length;

        if (v > instrumental.length)
            v = 0.0;

        instrumental.time = v;

        if (mainVocals != null)
            mainVocals.time = v;

        if (opponentVocals != null)
            opponentVocals.time = v;

        if (playerVocals != null)
            playerVocals.time = v;
    }

    public function resyncVocals():Void
    {
        if (mainVocals != null)
            mainVocals.time = instrumental.time;

        if (opponentVocals != null)
            opponentVocals.time = instrumental.time;

        if (playerVocals != null)
            playerVocals.time = instrumental.time;
    }

    public function getPosFromTime(v:Float):Float
    {
        return conductor.getStepAt(v) * 40.0;
    }

    // TODO: Test
    public function getTimeFromPos(v:Float):Float
    {
        return conductor.beatToTime(v / 160.0);
    }

    public function addNotes():Void
    {
        for (i in 0 ... chart.notes.length)
        {
            var noteData:NoteData = chart.notes[i];

            var noteGroup:NoteGroup = new NoteGroup(this, noteData);

            noteGroup.setPosition(grid.x + 40.0 + 40.0 * noteData.direction + 160.0 * noteData.lane,
                getPosFromTime(noteData.time));

            notes.add(noteGroup);
        }
    }

    public function addNoteSelect(note:NoteGroup):Void
    {
        notesSelected.push(note);
    }

    public function removeNoteSelect(note:NoteGroup):Void
    {
        notesSelected.remove(note);
    }

    public function clearNoteSelect():Void
    {
        for (i in 0 ... notesSelected.length)
        {
            var note:NoteGroup = notesSelected[i];

            note.color = FlxColor.fromRGBFloat(1.0, 1.0, 1.0, 1.0);
        }

        notesSelected.resize(0);
    }

    public function sortNotes():Void
    {
        chart.notes.sortTimed();

        sortNoteGroups(notes.members);
    }

    public function sortSelectedNotes():Void
    {
        sortNoteGroups(notesSelected);
    }

    public function sortNoteGroups(v:Array<NoteGroup>):Void
    {
        ArraySort.sort(v, (a:NoteGroup, b:NoteGroup) ->
        {
            var aTime:Float = a.noteData.time;

            var bTime:Float = b.noteData.time;

            Math.floor(aTime - bTime);
        });
    }
}