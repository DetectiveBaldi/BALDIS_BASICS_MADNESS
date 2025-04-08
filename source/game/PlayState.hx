package game;

import sys.FileSystem;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.math.FlxMath;

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

import extendable.ResourceState;

import game.notes.Note;
import game.notes.Strumline;

import game.notes.events.GhostTapEvent;
import game.notes.events.NoteHitEvent;

import game.events.CameraFollowEvent;
import game.events.CameraZoomEvent;
import game.events.ScrollSpeedChangeEvent;

import menus.LauncherScreen;
import menus.ModeSelectScreen;

import ui.Countdown;

import util.TimedObjectUtil;

using StringTools;

using util.ArrayUtil;

class PlayState extends ResourceState
{
    public static var week:WeekData;

    public static var level:LevelData;

    public static var isCampaign:Bool;

    public static function getCampaignLevel():PlayState
    {
        return Type.createInstance(Type.resolveClass('game.levels.${week.name}.Level${level.id}'), []);
    }

    public static function loadWeek(_week:WeekData, index:Int = 0, _isCampaign:Bool = true):Void
    {
        week = _week;

        level = week.levels[index];

        isCampaign = _isCampaign;

        FlxG.switchState(() -> getCampaignLevel());
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

    public var gameCameraTarget:FlxObject;

    public var gameCameraZoom:Float;

    /**
     * Most UI elements are drawn on this camera.
     */
    public var hudCamera:FlxCamera;

    /**
     * Elements such as the pause menu and fade transition are drawn on this camera.
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

        gameCameraTarget = new FlxObject();

        add(gameCameraTarget);

        gameCamera.follow(gameCameraTarget, LOCKON, 0.05);

        gameCameraZoom = gameCamera.zoom;

        loadChart();

        loadSong();

        stage ??= new FlxGroup();

        add(stage);

        cacheCharacterSheet("bf-dead0");

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

        playField = new PlayField(conductor, chart, instrumental);

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

        updateHealthBar(opponent.config.name, "opponent");

        updateHealthBar(player.config.name, "player");

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

            switch (event.name:String)
            {
                case "Camera Follow":
                    CameraFollowEvent.dispatch(this, event.value.x ?? 0.0, event.value.y ?? 0.0, event.value.characterRole ?? "", event.value.duration ?? -1.0, event.value.ease ?? "linear");

                case "Camera Zoom":
                    CameraZoomEvent.dispatch(this, event.value.zoom, event.value.duration, event.value.ease);

                case "Scroll Speed Change":
                    ScrollSpeedChangeEvent.dispatch(this, event.value.scrollSpeed, event.value.duration, event.value.ease);
            }

            eventIndex++;
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

    override function openSubState(subState:FlxSubState):Void
    {
        super.openSubState(subState);

        if (Type.getClass(subState) == PauseScreen)
            pauseMusic();
    }

    override function closeSubState():Void
    {
        super.closeSubState();

        if (Type.getClass(subState) == PauseScreen)
            resumeMusic();
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

    public function loadChart():Void
    {
        chart = ChartConverters.build(Paths.data('game/levels/${week.name}/Level${level.id}'));

        TimedObjectUtil.sort(chart.notes);

        if (Options.gameModifiers["shuffle"])
        {
            var shuffledDirections:Array<Int> = new Array<Int>();

            for (i in 0 ... 4)
                shuffledDirections.push(FlxG.random.int(0, 4 - 1, shuffledDirections));

            for (i in 0 ... chart.notes.length)
            {
                var note:RawNote = chart.notes[i];

                note.direction = shuffledDirections[note.direction];
            }
        }

        if (Options.gameModifiers["mirror"])
        {
            var mirroredDirections:Array<Int> = new Array<Int>();

            for (i in 0 ... 4)
                mirroredDirections.insert(0, i);

            for (i in 0 ... chart.notes.length)
            {
                var note:RawNote = chart.notes[i];

                note.direction = mirroredDirections[note.direction];
            }
        }

        TimedObjectUtil.sort(chart.events);

        TimedObjectUtil.sort(chart.timeChanges);

        conductor.tempo = chart.tempo;

        conductor.timeChange = {time: 0.0, tempo: chart.tempo, step: 0.0};

        conductor.timeChanges = chart.timeChanges;

        conductor.time = -conductor.beatLength * 5.0;

        eventIndex = 0;
    }

    public function loadSong():Void
    {
        var path:String = Paths.music('game/levels/${week.name}/Level${level.id}/');

        instrumental = FlxG.sound.load(Assets.getSound(Paths.ogg('${path}Instrumental')));

        instrumental.onComplete = endSong;

        if (FileSystem.exists(Paths.ogg('${path}Vocals-Main')))
            mainVocals = FlxG.sound.load(Assets.getSound(Paths.ogg('${path}Vocals-Main')));
        else
        {
            if (FileSystem.exists(Paths.ogg('${path}Vocals-Opponent')))
                opponentVocals = FlxG.sound.load(Paths.ogg('${path}Vocals-Opponent'));

            if (FileSystem.exists(Paths.ogg('${path}Vocals-Player')))
                playerVocals = FlxG.sound.load(Assets.getSound(Paths.ogg('${path}Vocals-Player')));
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

    public function endSong():Void
    {
        // Uh oh! Looks like something malfunctioned... let's head back to `menus.LauncherScreen`!

        if (week == null)
            FlxG.switchState(() -> new LauncherScreen());
        else
        {
            var i:Int = week.levels.indexOf(level);

            if (i + 1.0 >= week.levels.length || !isCampaign)
            {
                /* You completed the week!
                    Or perhaps, you were never truly in a week to begin with.
                        Either way, you can go back to `menus.ModeSelectScreen` for the time being. */

                FlxG.switchState(() -> new ModeSelectScreen());

                return;
            }

            // You still have places to be! Let's keep going!
            
            level = week.levels[i + 1];

            FlxG.switchState(() -> getCampaignLevel());
        }
    }

    public function pause():Void
    {
        openSubState(new PauseScreen(this));
    }

    public function gameOver():Void
    {
        #if debug
        return;
        #end
        
        persistentDraw = false;

        openSubState(new GameOverScreen());

        pauseMusic();
    }

    public function getSpectator(name:String):Character
    {
        return spectators.group.getFirst((spectator:Character) -> spectator.config.name == name);
    }

    public function getOpponent(name:String):Character
    {
        return opponents.group.getFirst((_opponent:Character) -> _opponent.config.name == name);
    }

    public function getPlayer(name:String):Character
    {
        return players.group.getFirst((_player:Character) -> _player.config.name == name);
    }

    public function cacheCharacterSheet(name:String):Void
    {
        Assets.getGraphic(Paths.image(Paths.png('game/Character/${name}')));
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

    public function updateHealthBar(character:String, role:String):Void
    {
        var _character:Character;

        switch (role:String)
        {
            case "spectator":
                _character = getSpectator(character);

            case "opponent":
                _character = getOpponent(character);

            default:
                _character = getPlayer(character);
        }

        var healthBar:HealthBar = playField.healthBar;

        if (role == "spectator" || role == "opponent")
            healthBar.opponentIcon.config = HealthIconData.get(_character.config.healthIcon);
        else
            healthBar.playerIcon.config = HealthIconData.get(_character.config.healthIcon);
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
}