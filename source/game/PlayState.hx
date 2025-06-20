package game;

import sys.FileSystem;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;

import flixel.sound.FlxSound;

import core.Assets;
import core.Paths;
import core.Options;

import data.CharacterData;
import data.Chart;
import data.Chart.RawEvent;
import data.Chart.RawNote;
import data.ChartConverters;
import data.HealthIconData;
import data.LevelData;
import data.WeekData;

import data.PlayStats;

import extendable.CustomState;

import game.notes.Note;
import game.notes.Strumline;

import game.notes.events.GhostTapEvent;
import game.notes.events.NoteHitEvent;

import game.events.CameraZoomEvent;
import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import menus.FreeplayScreen;
import menus.StoryMenuScreen;

import ui.Countdown;

import util.TimedObjectUtil;

using StringTools;

using util.ArrayUtil;

class PlayState extends CustomState
{
    public static var week:WeekData;

    public static var level:LevelData;

    public static var isWeek(get, never):Bool;

    @:noCompletion
    static function get_isWeek():Bool
    {
        return week != null;
    }

    public static var weekStats:Map<String, PlayStats>;

    public static function getLevelPath(?level:LevelData, sep:String = "/"):String
    {
        level ??= PlayState.level;

        var path:String = "game/levels";

        if (level.week != null)
            path += '/${level.week.sanitize()}';

        path += '/${level.sanitize()}';

        return sep == "/" ? path : path.replace("/", sep);
    }

    public static function getLevelClass(?level:LevelData):PlayState
    {
        return Type.createInstance(Type.resolveClass(getLevelPath(level ??= PlayState.level, ".")), []);
    }

    public static function loadWeek(week:WeekData):Void
    {
        PlayState.week = week;

        level = week.levels[0];

        weekStats = new Map<String, PlayStats>();

        FlxG.switchState(() -> getLevelClass());
    }

    public static function loadSingle(level:LevelData):Void
    {
        week = null;

        PlayState.level = level;

        weekStats = null;

        FlxG.switchState(() -> getLevelClass());
    }

    /**
     * Characters and stages are drawn on this camera.
     */
    public var gameCamera(get, never):FlxCamera;
    
    @:noCompletion
    function get_gameCamera():FlxCamera
    {
        return FlxG.camera;
    }

    public var cameraPoint:FlxObject;

    public var cameraTarget:String;

    public var cameraLock:CameraLockMode;

    public var gameCameraZoom:Float;

    /**
     * Most UI elements are drawn on this camera.
     */
    public var hudCamera:FlxCamera;

    /**
     * Elements such as the pause menu and other sub states are drawn on this camera.
     */
    public var topCamera:FlxCamera;

    public var chart:Chart;

    public var eventIndex:Int;

    public var instrumental:FlxSound;

    public var mainVocals:FlxSound;

    public var opponentVocals:FlxSound;

    public var playerVocals:FlxSound;

    public var stage:FlxGroup;

    public var spectators:FlxTypedSpriteGroup<Character>;

    public var spectator:Character;

    public var opponents:FlxTypedSpriteGroup<Character>;

    public var opponent:Character;

    public var players:FlxTypedSpriteGroup<Character>;

    public var player:Character;

    public var playField:PlayField;

    public var oppStrumline(get, never):Strumline;

    @:noCompletion
    function get_oppStrumline():Strumline
    {
        return playField.strumlines.members[0];
    }

    public var plrStrumline(get, never):Strumline;

    @:noCompletion
    function get_plrStrumline():Strumline
    {
        return playField.strumlines.members[1];
    }

    public var countdown:Countdown;

    override function create():Void
    {
        hudCamera = new FlxCamera();

        hudCamera.bgColor.alpha = 0;

        FlxG.cameras.add(hudCamera, false);

        topCamera = new FlxCamera();

        topCamera.bgColor.alpha = 0;

        FlxG.cameras.add(topCamera, false);

        super.create();

        conductor.active = true;

        cameraPoint = new FlxObject();

        add(cameraPoint);

        gameCamera.follow(cameraPoint, LOCKON, 0.05);

        cameraTarget = "POINT";

        cameraLock = LOOSE;

        gameCameraZoom = gameCamera.zoom;

        loadChart();

        loadSong();

        stage ??= new FlxGroup();

        add(stage);

        Assets.getGraphic("game/Character/bf-dead0");

        spectators = new FlxTypedSpriteGroup<Character>();

        stage.add(spectators);

        if (chart.spectator != "")
        {
            spectator = new Character(conductor, 0.0, 0.0, CharacterData.get(chart.spectator));

            spectator.skipSing = true;
        }

        opponents = new FlxTypedSpriteGroup<Character>();

        stage.add(opponents);

        opponent = new Character(conductor, 0.0, 0.0, CharacterData.get(chart.opponent));

        players = new FlxTypedSpriteGroup<Character>();

        stage.add(players);

        player = new Character(conductor, 0.0, 0.0, CharacterData.get(chart.player));

        playField = new PlayField(tween, timer, conductor, chart, instrumental);

        playField.camera = hudCamera;

        add(playField);

        var healthBar:HealthBar = playField.healthBar;

        healthBar.onEmptied.add(gameOver);

        oppStrumline.onNoteSpawn.add(noteSpawn); plrStrumline.onNoteSpawn.add(noteSpawn);

        oppStrumline.onNoteHit.add(noteHit); plrStrumline.onNoteHit.add(noteHit);

        oppStrumline.onNoteMiss.add(noteMiss); plrStrumline.onNoteMiss.add(noteMiss);

        oppStrumline.onNoteSpawn.add(oppNoteSpawn); plrStrumline.onNoteSpawn.add(plrNoteSpawn);

        oppStrumline.onNoteHit.add(oppNoteHit); plrStrumline.onNoteHit.add(plrNoteHit);

        oppStrumline.onNoteMiss.add(oppNoteMiss); plrStrumline.onNoteMiss.add(plrNoteMiss);

        oppStrumline.onGhostTap.add(ghostTap); plrStrumline.onGhostTap.add(ghostTap);

        oppStrumline.characters = opponents;

        oppStrumline.vocals = opponentVocals ?? mainVocals;

        plrStrumline.characters = players;

        plrStrumline.vocals = playerVocals ?? mainVocals;

        spectators.group.memberAdded.add((spectator:Character) -> spectator.strumline = playField.opponentStrumline);

        opponents.group.memberAdded.add((opponent:Character) -> opponent.strumline = playField.opponentStrumline);

        players.group.memberAdded.add((player:Character) -> player.strumline = playField.playerStrumline);

        if (spectator != null)
            spectators.add(spectator);

        opponents.add(opponent);

        players.add(player);

        updateHealthBar("opponent");

        updateHealthBar("player");

        countdown = new Countdown(conductor);
        
        countdown.camera = hudCamera;

        countdown.onPause.add(() -> conductor.active = false);

        countdown.onResume.add(() -> conductor.active = true);

        countdown.onFinish.add(startSong);

        countdown.onSkip.add(startSong);

        countdown.start();

        add(countdown);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        gameCamera.zoom = FlxMath.lerp(gameCamera.zoom, gameCameraZoom, FlxMath.getElapsedLerp(0.15, elapsed));

        hudCamera.zoom = FlxMath.lerp(hudCamera.zoom, 1.0, FlxMath.getElapsedLerp(0.15, elapsed));

        while (eventIndex < chart.events.length)
        {
            var event:RawEvent = chart.events[eventIndex];

            if (conductor.time < event.time)
                break;

            onEvent(event);
        }

        if (countdown.finished || countdown.skipped)
        {
            if (Math.abs(instrumental.time - conductor.time) >= 25.0)
                instrumental.time = conductor.time;

            if (mainVocals != null)
                if (Math.abs(mainVocals.time - instrumental.time) >= 5.0)
                    mainVocals.time = instrumental.time;

            if (opponentVocals != null)
                if (Math.abs(opponentVocals.time - instrumental.time) >= 5.0)
                    opponentVocals.time = instrumental.time;

            if (playerVocals != null)
                if (Math.abs(playerVocals.time - instrumental.time) >= 5.0)
                    playerVocals.time = instrumental.time;
        }

        if (FlxG.keys.anyJustPressed(Options.controls["UI:PAUSE"]))
            pause();

        #if debug
        if (FlxG.keys.justPressed.EIGHT)
            FlxG.switchState(() -> new editors.CharacterEditorState());
        #end
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
        
        if (beat == 1.0)
            countdown.kill();
    }

    override function measureHit(measure:Int):Void
    {
        super.measureHit(measure);

        gameCamera.zoom += 0.035;

        hudCamera.zoom += 0.015;
    }

    #if debug
    public function stepUntil(time:Float):Void
    {
        if (conductor.time < 0.0)
            return;
        
        pauseMusic();

        var i:Int = chart.notes.length - 1;

		while (i >= 0.0)
        {
			var raw:RawNote = chart.notes[i];

			if (playField.noteSpawner.noteIndex < i && raw.time - 166.6 < time)
                chart.notes.remove(raw);

			i--;
		}

        while (conductor.time < time)
            @:privateAccess
                FlxG.game.step();

        resumeMusic();
    }
    #end

    public function loadChart():Void
    {
        chart = ChartConverters.build(Paths.data(getLevelPath()));

        TimedObjectUtil.sort(chart.notes);

        TimedObjectUtil.sort(chart.events);

        TimedObjectUtil.sort(chart.timeChanges);

        conductor.tempo = chart.tempo;

        conductor.timeChange = {time: 0.0, tempo: chart.tempo, step: 0.0};

        conductor.timeChanges = chart.timeChanges;

        conductor.time = -conductor.beatLength * 5.0;

        eventIndex = 0;
    }

    public function onEvent(ev:RawEvent):Void
    {
        var val:Dynamic = ev.value;

        switch (ev.name:String)
        {
            case "CameraZoom":
                CameraZoomEvent.dispatch(this, val.zoom, val.duration, val.ease);

            case "FocusCamChar":
                FocusCamCharEvent.dispatch(this, val.charType, val.duration, val.ease);

            case "FocusCamPoint":
                FocusCamPointEvent.dispatch(this, val.x, val.y, val.duration, val.ease);
        }

        eventIndex++;
    }

    public function loadSong():Void
    {
        var path:String = Paths.music('${getLevelPath()}/');

        instrumental = FlxG.sound.load(Assets.getMusic(Paths.ogg('${path}Instrumental'), true));

        instrumental.onComplete = endSong;

        if (FileSystem.exists(Paths.ogg('${path}Vocals-Main')))
            mainVocals = FlxG.sound.load(Assets.getMusic(Paths.ogg('${path}Vocals-Main'), true));
        else
        {
            if (FileSystem.exists(Paths.ogg('${path}Vocals-Opponent')))
                opponentVocals = FlxG.sound.load(Assets.getMusic(Paths.ogg('${path}Vocals-Opponent'), true));

            if (FileSystem.exists(Paths.ogg('${path}Vocals-Player')))
                playerVocals = FlxG.sound.load(Assets.getMusic(Paths.ogg('${path}Vocals-Player'), true));
        }
    }

    public function startSong():Void
    {
        conductor.time = 0.0;

        instrumental.play();

        mainVocals?.play();

        opponentVocals?.play();

        playerVocals?.play();
    }

    public function endSong():Void
    {
        if (isWeek)
        {
            weekStats[level.name] = playField.playStats.copy();

            var i:Int = week.levels.indexOf(level);

            if (i == week.levels.length - 1.0)
            {
                var totalStats:PlayStats = PlayStats.empty();

                totalStats = totalStats.concat(for (k => v in weekStats) v);

                if (HighScore.isWeekHighScore(week.name, "normal", totalStats.score))
                    HighScore.setWeekScore(week.name, "normal", totalStats.score);

                FlxG.switchState(() -> new StoryMenuScreen());

                return;
            }

            level = week.levels[i + 1];

            FlxG.switchState(() -> getLevelClass());
        }
        else
            FlxG.switchState(() -> new FreeplayScreen());

        if (HighScore.isLevelHighScore(level.name, "normal", playField.playStats.score))
            HighScore.setLevelScore(level.name, "normal", playField.playStats.score);

        mainVocals?.stop();

        opponentVocals?.stop();

        playerVocals?.stop();
    }

    public function getSpectator(name:String):Character
    {
        return spectators.group.getFirst((spectator:Character) -> spectator.config.name == name);
    }

    public function getOpponent(name:String):Character
    {
        return opponents.group.getFirst((opponent:Character) -> opponent.config.name == name);
    }

    public function getPlayer(name:String):Character
    {
        return players.group.getFirst((player:Character) -> player.config.name == name);
    }

    public function updateHealthBar(charType:String):Void
    {
        var character:Character = Reflect.getProperty(this, charType);

        var healthBar:HealthBar = playField.healthBar;

        if (charType == "spectator" || charType == "opponent")
            healthBar.opponentIcon.config = HealthIconData.get(character.config.healthIcon);
        else
            healthBar.playerIcon.config = HealthIconData.get(character.config.healthIcon);
    }

    public function setCamStartPos():Void
    {
        var ev:RawEvent = chart.events.first((e:RawEvent) -> e.name == "FocusCamChar");

        FocusCamCharEvent.dispatch(this, "opponent", -1.0);

        gameCamera.snapToTarget();
    }

    public function noteSpawn(note:Note):Void {}

    public function noteHit(ev:NoteHitEvent):Void {}

    public function noteMiss(note:Note):Void {}

    public function ghostTap(ev:GhostTapEvent):Void {}

    public function oppNoteSpawn(note:Note):Void {}

    public function oppNoteHit(ev:NoteHitEvent):Void {}

    public function oppNoteMiss(note:Note):Void {}

    public function plrNoteSpawn(note:Note):Void {}

    public function plrNoteHit(ev:NoteHitEvent):Void {}

    public function plrNoteMiss(note:Note):Void {}

    public function pause():Void
    {
        persistentUpdate = false;

        openSubState(new PauseScreen(this));

        pauseMusic();
    }

    public function resume():Void
    {
        resumeMusic();
    }

    public function gameOver():Void
    {
        #if debug
        return;
        #end

        persistentUpdate = false;
        
        persistentDraw = false;

        openSubState(new GameOverScreen());

        pauseMusic();
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
}

enum CameraLockMode
{
    /**
     * No camera events are restricted.
     */
    LOOSE;

    /**
     * `FocusCamCharEvent` events are restricted.
     */
    MANUAL;

    /**
     * `FocusCamPointEvent` events are restricted.
     */
    AUTOMATIC;

    /**
     * All camera events are restricted.
     */
    STRICT;
}