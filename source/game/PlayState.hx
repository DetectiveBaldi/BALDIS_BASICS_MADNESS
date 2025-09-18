package game;

import sys.FileSystem;

import openfl.filters.BitmapFilter;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSubState;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;

import flixel.util.typeLimit.NextState;

import flixel.sound.FlxSound;

import core.AssetCache;
import core.Paths;
import core.Options;

import data.CharacterData;
import data.Chart;
import data.Chart.EventSchema;
import data.Chart.NoteSchema;
import data.ChartLoader;
import data.LevelData;
import data.WeekData;

import data.PlayStats;

import extendable.CustomState;

import game.notes.Note;
import game.notes.Strumline;

import game.notes.events.GhostTapEvent;
import game.notes.events.NoteHitEvent;

import game.events.CameraZoomEvent;
import game.events.SetCamFocusEvent;

import menus.FreeplayScreen;
import menus.StoryMenuScreen;
import menus.UnlockScreen;

import ui.Countdown;

using StringTools;

using util.ArrayUtil;
using util.TimingUtil;

// TODO: Improve song syncing.
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

    public static var weekStats:Map<String, PlayStats> = new Map<String, PlayStats>();
    
    public static function getClassFromLevel(level:LevelData = null, params:PlayStateParams = null):PlayState
    {
        level ??= PlayState.level;

        return Type.createInstance(Type.resolveClass(level.getClassPath(".")), [params]);
    }

    public static function loadWeek(week:WeekData):Void
    {
        PlayState.week = week.copy();

        level = week.levels[0];

        weekStats.clear();

        FlxG.switchState(() -> getClassFromLevel());
    }

    public static function loadLevel(level:LevelData, params:PlayStateParams = null):Void
    {
        week = null;

        PlayState.level = level;

        weekStats.clear();

        FlxG.switchState(() -> getClassFromLevel(params));
    }
    
    public function getClassFromNextState():Class<FlxState>
    {
        var nextState:NextState = params?.nextState;

        if (nextState == null)
            return null;
        
        return Type.getClass(nextState.createInstance());
    }

    public var params:PlayStateParams;

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

    /**
     * Simplistic representation of what the camera is viewing. Values include "POINT" and "CHARACTER".
     */
    public var cameraTarget:String;

    /**
     * A more specific version `cameraTarget` that explicitly refers to the type of character the camera is viewing.
     */
    public var cameraCharTarget:String;

    public var cameraLock:CameraLockMode;

    public var gameCamBopStrength:Float;

    public var gameCameraZoom:Float;

    /**
     * Most UI elements are drawn on this camera.
     */
    public var hudCamera:FlxCamera;

    public var hudCamBopStrength:Float;

    /**
     * Elements such as the pause menu and other sub states are drawn on this camera.
     */
    public var topCamera:FlxCamera;

    public var canPause:Bool;

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

    public var startingSong:Bool;

    public function new(params:PlayStateParams):Void
    {
        super();

        this.params = params;
    }

    override function create():Void
    {
        gameCamera.filters = new Array<BitmapFilter>();
        
        hudCamera = new FlxCamera();

        hudCamera.bgColor.alpha = 0;

        hudCamera.filters = new Array<BitmapFilter>();

        FlxG.cameras.add(hudCamera, false);

        topCamera = new FlxCamera();

        topCamera.bgColor.alpha = 0;

        FlxG.cameras.add(topCamera, false);

        canPause = true;

        super.create();

        cameraPoint = new FlxObject();

        add(cameraPoint);

        gameCamera.follow(cameraPoint, LOCKON, 0.05);

        cameraTarget = "POINT";

        cameraCharTarget = "";

        cameraLock = DEFAULT;

        gameCamBopStrength = 0.035;

        gameCameraZoom = gameCamera.zoom;

        hudCamBopStrength = 0.015;

        loadChart();

        loadSong();

        stage ??= new FlxGroup();

        add(stage);

        AssetCache.getGraphic("game/Character/bf-dead");

        spectators = new FlxTypedSpriteGroup<Character>();

        stage.add(spectators);

        if (chart?.spectator != "")
        {
            spectator = new Character(conductor, 0.0, 0.0, Character.getConfig(chart.spectator));

            spectator.skipSing = true;
        }

        opponents = new FlxTypedSpriteGroup<Character>();

        stage.add(opponents);

        opponent = new Character(conductor, 0.0, 0.0, Character.getConfig(chart.opponent));

        players = new FlxTypedSpriteGroup<Character>();

        stage.add(players);

        player = new Character(conductor, 0.0, 0.0, Character.getConfig(chart.player));

        playField = new PlayField(tween, timer, conductor, chart, instrumental);

        playField.camera = hudCamera;

        if (params?.playStats != null)
            playField.playStats = params?.playStats;

        if (params?.health != null)
            playField.healthBar.value = params?.health;

        add(playField);

        FlxG.watch.add(playField.playStats, "score", "Score");

        FlxG.watch.add(playField.playStats, "misses", "Misses");

        FlxG.watch.add(playField.playStats, "accuracy", "Accuracy%");

        var healthBar:HealthBar = playField.healthBar;

        healthBar.onEmptied.add(gameOver);

        oppStrumline.onNoteSpawn.add(noteSpawn); plrStrumline.onNoteSpawn.add(noteSpawn);

        oppStrumline.onNoteHit.add(noteHit); plrStrumline.onNoteHit.add(noteHit);

        oppStrumline.onNoteMiss.add(noteMiss); plrStrumline.onNoteMiss.add(noteMiss);

        oppStrumline.onGhostTap.add(ghostTap); plrStrumline.onGhostTap.add(ghostTap);

        oppStrumline.characters = opponents;

        oppStrumline.spectators = spectators;

        oppStrumline.vocals = opponentVocals ?? mainVocals;

        plrStrumline.characters = players;

        plrStrumline.spectators = spectators;

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

        add(countdown);

        var startOnTime:Null<Float> = params?.startOnTime;

        if (startOnTime != null && startOnTime > 0.0)
        {
            countdown.skip();

            changeTime(startOnTime);
        }

        startingSong = true;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Calculate new time here, we need to update camera target fields before updating the conductor.
        var timeToUpdateTo:Float = conductor.time + 1000.0 * elapsed;

        if (startingSong)
            timeToUpdateTo = Math.min(timeToUpdateTo, 0.0);

        // Update the camera target fields.
        updateCameraTarget(timeToUpdateTo);
            
        // Update the conductor now.
        conductor.update(timeToUpdateTo);

        while (eventIndex < chart.events.length)
        {
            var event:EventSchema = chart.events[eventIndex];

            if (conductor.time < event.time)
                break;

            onEvent(event);
        }

        if (startingSong)
        {
            if (conductor.time == 0.0)
                startSong();
        }
        else
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
        
        gameCamera.zoom = FlxMath.lerp(gameCamera.zoom, gameCameraZoom, FlxMath.getElapsedLerp(0.15, elapsed));

        hudCamera.zoom = FlxMath.lerp(hudCamera.zoom, 1.0, FlxMath.getElapsedLerp(0.15, elapsed));

        if (FlxG.keys.anyJustPressed(Options.controls["UI:PAUSE"]) && canPause)
            pause();

        #if debug
        if (FlxG.keys.justPressed.R)
            gameOver();

        if (FlxG.keys.justPressed.EIGHT)
            FlxG.switchState(() -> new editors.CharacterEditorState(
                () -> PlayState.getClassFromLevel(params), player.config.name));
        #end
    }

    override function measureHit(measure:Int):Void
    {
        super.measureHit(measure);

        gameCamera.zoom += gameCamBopStrength;

        hudCamera.zoom += hudCamBopStrength;
    }

    public function loadChart():Void
    {
        chart = ChartLoader.readPath(Paths.data(level.getClassPath()));

        chart.notes.sortTimed();

        chart.events.sortTimed();
        
        conductor.writeTimingPointData(chart.timingPoints);

        conductor.calibrateTimingPoints();

        conductor.update(-conductor.beatLength * 5.0);

        FlxG.watch.add(conductor, "time", "Time");

        FlxG.watch.add(conductor, "step", "Step");

        FlxG.watch.add(conductor, "beat", "Beat");

        FlxG.watch.add(conductor, "measure", "Measure");

        eventIndex = 0;
    }

    public function onEvent(ev:EventSchema):Void
    {
        var val:Dynamic = ev.value;

        switch (ev.name:String)
        {
            case "CameraZoom":
                CameraZoomEvent.dispatch(this, val.zoom, val.duration, val.ease);

            case "SetCamFocus":
                SetCamFocusEvent.dispatch(this, val.x, val.y, val.charType, val.duration, val.ease);
        }

        eventIndex++;
    }

    public function loadSong():Void
    {
        var songPath:String = '${level.getClassPath()}/';

        var pathSuffix:String = "Instrumental";

        instrumental = FlxG.sound.load(AssetCache.getMusic(songPath + pathSuffix));

        instrumental.onComplete = endSong;

        pathSuffix = "Vocals-Main";

        if (FileSystem.exists(Paths.music(Paths.ogg(songPath + pathSuffix))))
            mainVocals = FlxG.sound.load(AssetCache.getMusic(songPath + pathSuffix));
        else
        {
            pathSuffix = "Vocals-Opponent";

            if (FileSystem.exists(Paths.music(Paths.ogg(songPath + pathSuffix))))
                opponentVocals = FlxG.sound.load(AssetCache.getMusic(songPath + pathSuffix));

            pathSuffix = "Vocals-Player";

            if (FileSystem.exists(Paths.music(Paths.ogg(songPath + pathSuffix))))
                playerVocals = FlxG.sound.load(AssetCache.getMusic(songPath + pathSuffix));
        }
    }

    public function startSong():Void
    {
        instrumental.play();

        mainVocals?.play();

        opponentVocals?.play();

        playerVocals?.play();

        startingSong = false;
    }

    public function endSong():Void
    {
        mainVocals?.stop();

        opponentVocals?.stop();

        playerVocals?.stop();

        var nextState:NextState = params?.nextState;
        
        var playStats:PlayStats = playField.playStats;

        var score:Int = playStats.score;

        var misses:Int = playStats.misses;

        var accuracy:Float = playStats.accuracy;

        var grade:String = playStats.grade;

        var unlocks:Array<UnlockScreenParams> = new Array<UnlockScreenParams>();

        if (isWeek)
        {
            weekStats[level.name] = playField.playStats.copy();

            week.levels.shift();

            if (week.levels.length == 0.0)
            {
                nextState ??= () -> new StoryMenuScreen();

                var totalStats:PlayStats = PlayStats.empty();

                totalStats.concat(for (k => v in weekStats) v);

                score = totalStats.score;

                misses = totalStats.misses;

                accuracy = totalStats.accuracy;

                grade = totalStats.grade;

                var testA:Bool = #if debug true #else HighScore.getWeekScore(week.name, level.difficulty).score == 0.0 #end ;

                var weekToSearch:WeekData = WeekData.list.first((w:WeekData) -> w.name == week.name);

                if (testA)
                {
                    if (WeekData.list.first() == weekToSearch)
                    {
                        unlocks.push({unlock: "Freeplay Mode"});

                        unlocks.push({unlock: "Mystery Mode"});
                    }

                    var filteredDependencies:Array<WeekData> = WeekData.list.filter((w:WeekData) ->
                        w.scoreRequirements.exists(week.name));

                    for (w in filteredDependencies)
                    {
                        // We display this later down the line.
                        if (week.name == w.name)
                            continue;

                        unlocks.push({unlock: w.name + week.nameSuffix});
                    }
                }

                var testB:Bool = #if debug true #else HighScore.getWeekScore(week.name, "Normal").score == 0.0 #end &&
                    weekToSearch.hasDifficulty("Hard");

                if (testB)
                    unlocks.push({unlock: "Hard Mode"});

                if (testA)
                {
                    if (week.scoreRequirements.exists(week.name))
                        unlocks.push({unlock: week.name + week.nameSuffix});
                }

                if (HighScore.isWeekHighScore(week.name, level.difficulty, score))
                    HighScore.setWeekScore(week.name, level.difficulty, {score: score, misses: misses, accuracy: accuracy,
                        grade: grade});
            }
            else
            {
                level = week.levels[0];

                nextState ??= () -> PlayState.getClassFromLevel();
            }
        }
        else
        {
            nextState ??= () -> new FreeplayScreen();

            var testA:Bool = #if debug true #else HighScore.getLevelScore(level.name, level.difficulty).score == 0.0 #end &&
                level.obscurity == SMALL;

            if (testA)
                unlocks.push({unlock : level.name});
        }

        if (HighScore.isLevelHighScore(level.name, level.difficulty, score))
            HighScore.setLevelScore(level.name, level.difficulty, {score: score, misses: misses, accuracy: accuracy, grade: grade});

        FlxG.switchState(unlocks.length > 0.0 ? () -> new UnlockScreen(nextState, unlocks) : nextState);
    }

    public function changeTime(newTime:Float):Void
    {
        if (startingSong)
            return;

        if (conductor.time == newTime)
            return;

        if (conductor.time > newTime)
        {
            conductor.time = newTime;
            
            playField.noteSpawner.setNoteIndexAt(newTime);

            setEventIndexAt(newTime);
        }
        else
        {
            pauseMusic();

            playField.noteSpawner.setNoteIndexAt(newTime);

            while (conductor.time < newTime)
            {
                @:privateAccess
                FlxG.game.step();
            }

            resumeMusic();
        }
    }

    public function setEventIndexAt(time:Float):Void
    {
        eventIndex = 0;
        
        var event:EventSchema = chart.events[eventIndex];

        while (eventIndex < chart.events.length && event.time <= time)
        {
            eventIndex++;
            
            event = chart.events[eventIndex];
        }
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
            healthBar.opponentIcon.loadFromFile(character.config.healthIcon);
        else
            healthBar.playerIcon.loadFromFile(character.config.healthIcon);
    }

    public function getStartingCamFocusEvent():EventSchema
    {
        return chart.events.first((e:EventSchema) -> e.name == "SetCamFocus");
    }

    public function setCamStartPos():Void
    {
        var ev:EventSchema = getStartingCamFocusEvent();

        // I don't know why you wouldn't have atleast one of these, but who knows?
        if (ev == null)
            return;

        SetCamFocusEvent.dispatch(this, ev.value.x, ev.value.y, ev.value.charType, 0.0, "linear");

        gameCamera.snapToTarget();
    }

    public function getCameraTarget(timeToCheck:Float):String
    {
        var ev:EventSchema = chart.events.last((e:EventSchema) -> e.name == "SetCamFocus" && e.time <= timeToCheck);

        if (ev == null)
            ev = getStartingCamFocusEvent();

        if (ev.value.charType == null)
            return "POINT";
        else
            return ev.value.charType.toUpperCase();
    }

    public function updateCameraTarget(timeToCheck:Float):Void
    {
        var target:String = getCameraTarget(timeToCheck);

        if (target == "POINT")
            cameraTarget = target;
        else
        {
            cameraTarget = "CHARACTER";

            cameraCharTarget = target;
        }
    }

    public function noteSpawn(note:Note):Void {}

    public function noteHit(ev:NoteHitEvent):Void {}

    public function noteMiss(note:Note):Void {}

    public function ghostTap(ev:GhostTapEvent):Void {}

    public function pause():Void
    {
        openSubState(new PauseScreen(this));

        gameCamera.active = false;

        pauseMusic();
    }

    public function resume():Void
    {
        gameCamera.active = true;
        
        resumeMusic();
    }

    public function gameOver():Void
    {
        persistentDraw = false;

        openSubState(new GameOverScreen(this));

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
    DEFAULT;

    /**
     * Camera movement is limited to the use of `SetCamFocus` events with `charType != null`.
     */
    FOCUS_CAM_CHAR;

    /**
     * Camera movement is limited to the use of `SetCamFocus` events with `charType == null`.
     */
    FOCUS_CAM_POINT;

    /**
     * All camera events are restricted.
     */
    NONE;
}

typedef PlayStateParams =
{
    /**
     * At what point in time should the level initialize to?
     */
    var ?startOnTime:Float;

    /**
     * Play stats to initialize with.
     */
    var ?playStats:PlayStats;

    /**
     * Health to initialize with.
     */
    var ?health:Float;

    /**
     * Where should we go after this level is finished?
     */
    var ?nextState:NextState;
} 