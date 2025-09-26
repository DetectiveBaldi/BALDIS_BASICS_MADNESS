package game.levels;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxGroup;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;

import core.AssetCache;
import core.Options;
import core.Paths;

import game.stages.ScribbleS;

import ui.ProgressBar;

using StringTools;

using flixel.util.FlxColorTransformUtil;

using util.MathUtil;

class ScribbleL extends PlayState
{
    public var scribbleS:ScribbleS;

    public var scribbleUI:ScribbleUI;

    public var pencil:FlxSprite;

    public var throwPencilSound:FlxSound;

    public var stabPencilSound:FlxSound;

    override function create():Void
    {
        stage = new ScribbleS();

        scribbleS = cast (stage, ScribbleS);

        super.create();

        scribbleUI = new ScribbleUI(this);

        scribbleUI.visible = false;

        add(scribbleUI);

        throwPencilSound = FlxG.sound.load(AssetCache.getSound("shared/throw-pencil"));

        stabPencilSound = FlxG.sound.load(AssetCache.getSound("shared/stab-pencil"));

        oppStrumline.strums.x = oppStrumline.strums.getCenterX();

        plrStrumline.strums.x = plrStrumline.strums.getCenterX();

        plrStrumline.botplay = true;

        player.scale.set(3.75, 3.75);
        player.setPosition(700, 100);

        opponent.setPosition(1070, 185);
        opponent.scale.set(0.85, 0.85);

        pencil = new FlxSprite();

        pencil.visible = false;

        pencil.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("shared/pencil-throw"),
            Paths.image(Paths.xml("shared/pencil-throw")));

        pencil.animation.addByPrefix("throw", "throw", 32.0, false);

        add(pencil);

        opponent.colorTransform.setOffsets(FlxColor.WHITE);

        player.colorTransform.setOffsets(FlxColor.WHITE);

        playField.scoreText.visible = playField.timerClock.visible = false;

        scribbleUI.progressBar.visible = scribbleUI.timeText.visible = false;

        oppStrumline.strums.alpha = 0.0;

        plrStrumline.strums.alpha = 0.0;

        gameCameraZoom = 1.3;

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 132.0)
        {
            tweens.tween(oppStrumline.strums, {alpha: 0.25}, conductor.beatLength * 0.001);

            tweens.tween(plrStrumline.strums, {alpha: 1.0}, conductor.beatLength * 0.001);
        }

        if (step == 288.0)
        {
            playField.scoreText.visible = playField.timerClock.visible = true;

            scribbleUI.progressBar.visible = scribbleUI.timeText.visible = true;

            scribbleS.classicHall0.visible = true;

            tweens.tween(opponent.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 0.0},
                conductor.beatLength * 2.0 * 0.001);

            tweens.tween(player.colorTransform, {redOffset: 0.0, greenOffset: 0.0, blueOffset: 0.0, alphaOffset: 0.0},
                conductor.beatLength * 2.0 * 0.001);

            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 1072)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            playField.scoreText.visible = playField.timerClock.visible = false;

            scribbleUI.progressBar.visible = scribbleUI.timeText.visible = false;

            scribbleS.classicHall0.colorTransform.setOffsets(20, 20, 20, 155);
        }

        if (step == 368.0 || step == 592.0 || step ==  784.0)
        {
            throwPencilSequence();
        }

        if (step == 1312)
        {
            tweens.tween(player.colorTransform, {redOffset: 255.0, greenOffset: 255.0, blueOffset: 255.0, alphaOffset: 0.0},
                conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(opponent.colorTransform, {redOffset: 204.0, greenOffset: 204.0, blueOffset: 204.0, alphaOffset: 0.0},
                conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            tweens.tween(scribbleS.classicHall0.colorTransform, {redOffset: 255.0, greenOffset: 255.0, blueOffset: 255.0, alphaOffset: 0.0},
                conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});
        }

        if (step == 1328)
        {
            opponent.visible = false;

            player.colorTransform.setOffsets(0xFFFFFF);

            tweens.tween(player, {alpha: 0.0}, conductor.beatLength * 4.0 * 0.001, {ease: FlxEase.quartIn});

            scribbleS.classicHall0.visible = false;
        }

        if (step == 1344)
            plrStrumline.botplay = true;
    }

    override function measureHit(measure:Int):Void
    {
        super.measureHit(measure);
    
        if (cameraCharTarget == "OPPONENT")
            gameCameraZoom = 1.3;
        else
            gameCameraZoom = 1;
    }

    public function resetPencilPosition():Void
    {

    }

    public function throwPencilSequence():Void
    {
        opponent.skipDance = true;

        opponent.skipSing = true;

        opponent.animation.onFrameChange.add(animChange);

        opponent.animation.onFinish.addOnce(animFinish);

        opponent.animation.play("stab");
    }

    public function animChange(name:String, num:Int, index:Int):Void
    {
        if (num == 51)
        {
            throwPencilSound.play(true);

            pencil.visible = true;

            pencil.animation.play("throw");

            pencil.setPosition(865.0, 215.0);
        }
    }

    public function animFinish(name:String):Void
    {
        opponent.animation.onFrameChange.remove(animChange);

        opponent.skipDance = false;

        opponent.skipSing = false;

        reduceMaxHealth();

        pencil.visible = false;

        stabPencilSound.play(true);
    }

    public function reduceMaxHealth():Void
    {
        var healthBar:HealthBar = playField.healthBar;

        var oldMaxHealth:Float = healthBar.max;

        healthBar.max -= 10.0;

        healthBar.value = healthBar.value;

        healthBar.value *= 0.85;

        healthBar.value = healthBar.value * healthBar.max / oldMaxHealth;

        var progressBar:ProgressBar = scribbleUI.progressBar;

        progressBar.max = healthBar.max;

        progressBar.width -= 48.0;

        progressBar.regenerateSides();

        progressBar.regenerateBorder();

        progressBar.setPosition(progressBar.getCenterX(), Options.downscroll ? 50.0 : FlxG.height - progressBar.height - 50.0);
    }
}

/**
 * A "component" of sorts to extend the ui.
 */
class ScribbleUI extends FlxBasic
{
    public var game:PlayState;

    public var healthBar:HealthBar;

    public var progressBar:ProgressBar;

    public var timeText:FlxText;

    public function new(game:PlayState):Void
    {
        super();

        this.game = game;

        var playField:PlayField = game.playField;

        healthBar = playField.healthBar;

        playField.scoreClip.visible = false;

        var scoreText:FlxText = playField.scoreText;

        scoreText.antialiasing = true;

        scoreText.textField.antiAliasType = NORMAL;

        scoreText.textField.sharpness = 100.0;

        healthBar.visible = false;

        var timerClock:FlxSprite = playField.timerClock;

        timerClock.loadGraphic(AssetCache.getGraphic("shared/alarm-clock-classic"));

        timerClock.scale.set(1.5, 1.5);

        timerClock.updateHitbox();

        timerClock.setPosition(FlxG.width - timerClock.width - 25.0,
            Options.downscroll ? 25.0 : FlxG.height - timerClock.height - 25.0);

        playField.timerNeedle.visible = false;

        progressBar = new ProgressBar(0.0, 0.0, 480, 30, 0, LEFT_TO_RIGHT);

        progressBar.emptiedSide.color = FlxColor.RED;

        progressBar.filledSide.color = FlxColor.LIME;

        progressBar.setPosition(progressBar.getCenterX(), Options.downscroll ? 50.0 : FlxG.height - progressBar.height - 50.0);

        playField.insert(playField.members.indexOf(healthBar), progressBar);

        if (Options.botplay)
            progressBar.kill();

        timeText = new FlxText(0.0, 0.0, timerClock.width);

        timeText.antialiasing = true;

        timeText.color = FlxColor.BLACK;

        timeText.size = 16;

        timeText.text = "0:00";

        timeText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        timeText.alignment = CENTER;

        timeText.setPosition(timerClock.x, timeText.getCenterY(timerClock) + 18.5);

        playField.insert(playField.members.indexOf(timerClock) + 1, timeText);

        if (Options.botplay)
            timeText.kill();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!game.startingSong)
            timeText.text = FlxStringUtil.formatTime(game.conductor.time * 0.001);
        
        progressBar.value = healthBar.value;
    }
}