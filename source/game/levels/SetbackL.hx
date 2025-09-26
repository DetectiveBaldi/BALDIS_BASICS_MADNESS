package game.levels;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.CharacterData;

import game.levels.ScribbleL.ScribbleUI;
import game.stages.SetbackS;

using util.MathUtil;

using StringTools;

class SetbackL extends PlayState
{
    public var setbackS:SetbackS;

    public var setbackUI:SetbackUI;

    public var thanks:FlxSprite;

    public var spoop:FlxSprite;

    override function create():Void
    {
        stage = new SetbackS();

        setbackS = cast (stage, SetbackS);

        super.create();

        setbackUI = new SetbackUI(this);

        setbackUI.visible = false;

        add(setbackUI);

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.alpha = 0.0;

        setbackS.room.visible = true;

        setbackS.chair.visible = true;

        setbackS.remove(opponents, true);

        setbackS.insert(setbackS.members.indexOf(setbackS.chair), opponents);

        setbackS.room.color = setbackS.chair.color = opponent.color = player.color = 0x333333;

        opponent.setPosition(397.0, 117.0);

        opponent.scale.set(1.16, 1.16);

        player.setPosition(305.0, 100.0);

        player.visible = false;

        spoop = new FlxSprite();

        spoop.active = false;

        spoop.visible = false;

        spoop.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/stages/SetbackS/spoopballoon-distraction"), Paths.image(Paths.xml("game/stages/SetbackS/spoopballoon-distraction")));

        spoop.scale.set(2.7, 2.7);

        spoop.updateHitbox();

        spoop.screenCenter();

        spoop.animation.addByPrefix("intro", "intro", 24.0, false);

        spoop.animation.addByPrefix("left", "left", 24.0, false);

        spoop.animation.addByPrefix("right", "right", 24.0, false);

        spoop.animation.addByPrefix("lpopup", "lpopup", 24.0, false);

        spoop.animation.addByPrefix("rpopup", "rpopup", 24.0, false);

        spoop.animation.addByPrefix("lbye", "lbye", 24.0, false);

        spoop.animation.addByPrefix("rbye", "rbye", 24.0, false);

        spoop.animation.addByPrefix("outro", "outro", 24.0, false);

        spoop.active = true;

        spoop.camera = hudCamera;

        add(spoop);

        playField.scoreClip.visible = playField.scoreText.visible = playField.timerClock.visible = false;

        playField.strumlines.visible = false;

        setbackUI.progressBar.visible = setbackUI.timeText.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 32)
        {
            gameCamera.alpha = 1.0;

            playField.scoreClip.visible = playField.scoreText.visible = playField.timerClock.visible = true;

            playField.strumlines.visible = true;

            setbackUI.progressBar.visible = setbackUI.timeText.visible = true;
        }

        if (step == 156)
        {
            opponent.color = setbackS.room.color = setbackS.chair.color = 0x1F1F1F;
        }

        if (step == 160)
        {
            opponent.color = setbackS.room.color = setbackS.chair.color = 0x333333;
        }

        if (step == 416)
        {
            playField.scoreClip.visible = playField.scoreText.visible = playField.timerClock.visible = false;

            playField.strumlines.visible = false;

            setbackUI.progressBar.visible = setbackUI.timeText.visible = false;
        }

        if (step == 476)
        {
            gameCamera.alpha = 0.0;

            gameCameraZoom = 0.5;

            plrStrumline.botplay = true;
            plrStrumline.resetStrums();
        }

        if (step == 480)
        {
            gameCamera.alpha = 1.0;

            plrStrumline.botplay = Options.botplay;

            playField.scoreClip.visible = playField.scoreText.visible = playField.timerClock.visible = true;

            setbackUI.progressBar.visible = true;

            playField.strumlines.visible = true;

            var opp:Character = getOpponent("dsci");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("dsci-pov"));
            opp.setPosition(-725.0, -408.0);
            opp.color = 0x333333;
            opponents.add(opp);

            player.visible = true;
        }

        if (step == 604)
        {
            spoop.visible = true;
            spoop.animation.play("intro");
        }

        if (step == 672)
            spoop.animation.play("left");

        if (step == 704)
            spoop.animation.play("right");

        if (step == 736)
        {
            gameCameraZoom = 0.65;

            spoop.animation.play("lpopup");
        }

        if (step == 748)
            spoop.animation.play("lbye");

        if (step == 752)
            spoop.animation.play("rpopup");

        if (step == 764)
            spoop.animation.play("rbye");

        if (step == 768)
            spoop.animation.play("outro");

        if (step == 800)
        {
            thanks = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/thanks"));
            thanks.camera = hudCamera;
            thanks.setGraphicSize(FlxG.width, FlxG.height);
            thanks.updateHitbox();
            thanks.screenCenter();
            add(thanks);

            plrStrumline.botplay = true;

            hudCamBopStrength = 0.0;

            gameCamBopStrength = 0.0;

            canPause = false;
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 152 && beat <= 183)
        {
            if (beat % 4.0 == 0.0)
                spawnBalloon();
        }

        if (beat >= 184 && beat <= 199)
        {
            if (beat % 2.0 == 0.0)
                spawnBalloon();
        }
    }

    public function spawnBalloon():Void
    {
        var balloon:FlxSprite;

        var scaleNum:Float;

        var posX:Float;

        var randomThing:Int;

        randomThing = FlxG.random.int(1, 2);

        if (randomThing == 1)
            posX = -1500.0;
        else
            posX = 1500.0;

        scaleNum = FlxG.random.float(2.25, 5.0);

        balloon = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/spoopBalloon"));

        balloon.scale.set(scaleNum, scaleNum);

        balloon.updateHitbox();

        balloon.setPosition(posX, balloon.getCenterY() + 15.0);

        balloon.active = true;

        add(balloon);

        if (scaleNum <= 2.75)
        {
            remove(balloon);
            setbackS.insert(setbackS.members.indexOf(players), balloon);
        }
        
        if (balloon.x <= 0)
            balloon.velocity.x = 550.0;
        else
            balloon.velocity.x = -550.0;
    }
}

/**
 * A "component" of sorts to extend the ui.
 */
class SetbackUI extends ScribbleUI
{
    public function new(game:PlayState):Void
    {
        super(game);

        var playField:PlayField = game.playField;

        playField.scoreClip.visible = true;

        var scoreText:FlxText = game.playField.scoreText;

        scoreText.antialiasing = false;

        scoreText.textField.antiAliasType = ADVANCED;

        scoreText.textField.sharpness = 400.0;

        timeText.antialiasing = false;

        timeText.textField.antiAliasType = ADVANCED;

        timeText.textField.sharpness = 400.0;
    }
}