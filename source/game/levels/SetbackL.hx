package game.levels;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import data.CharacterData;

import game.stages.SetbackS;

using util.MathUtil;

using StringTools;

class SetbackL extends PlayState
{
    public var setbackS:SetbackS;

    public var thanks:FlxSprite;

    override function create():Void
    {
        stage = new SetbackS();

        setbackS = cast (stage, SetbackS);

        super.create();

        cameraLock = FOCUS_CAM_POINT;

        cameraPoint.centerTo();

        gameCamera.alpha = 0.0;

        playField.healthBar.visible = false;

        setbackS.room.visible = true;

        setbackS.chair.visible = true;

        setbackS.remove(opponents, true);

        setbackS.insert(setbackS.members.indexOf(setbackS.chair), opponents);

        setbackS.room.color = setbackS.chair.color = opponent.color = player.color = 0x333333;

        opponent.setPosition(397.0, 117.0);

        opponent.scale.set(1.16, 1.16);

        player.setPosition(305.0, 100.0);

        player.visible = false;
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 32)
        {
            gameCamera.alpha = 1.0;

            playField.healthBar.visible = true;
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
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = false;
        }

        if (step == 476)
        {
            gameCamera.alpha = 0.0;
            playField.visible = false;

            gameCameraZoom = 0.5;
        }

        if (step == 480)
        {
            gameCamera.alpha = 1.0;
            playField.visible = true;
            playField.scoreClip.visible = playField.scoreText.visible = playField.healthBar.visible = 
                playField.timerClock.visible = playField.timerNeedle.visible = true;

            var opp:Character = getOpponent("dsci");
            opp.visible = false;

            var opp:Character = new Character(conductor, 0.0, 0.0, Character.getConfig("dsci-pov"));
            opp.setPosition(-725.0, -408.0);
            opp.color = 0x333333;
            opponents.add(opp);

            player.visible = true;
        }

        if (step == 736)
        {
            gameCameraZoom = 0.65;
        }

        if (step == 800)
        {
            thanks = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/thanks"));
            thanks.scale.set(2.7, 2.7);
            thanks.camera = hudCamera;
            thanks.screenCenter();
            add(thanks);
        }
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);

        if (beat >= 152 && beat <= 199)
        {
            if (beat % 4.0 == 0.0)
                spawnBalloon();
        }
    }

    public function spawnBalloon():Void
    {
        var balloon:FlxSprite;

        var scaleNum:Float;

        var posX:Float;

        posX = FlxG.random.int(-1000, 1000);

        scaleNum = FlxG.random.float(1.0, 5.0);

        balloon = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/spoopBalloon"));

        balloon.scale.set(scaleNum, scaleNum);

        balloon.updateHitbox();

        balloon.setPosition(posX, balloon.getCenterY() + 15.0);

        balloon.active = true;

        add(balloon);

        if (scaleNum <= 2.5)
        {
            remove(balloon);
            setbackS.insert(setbackS.members.indexOf(players), balloon);
        }

        if (scaleNum <= 2.0)
        {
            remove(balloon);
            setbackS.insert(setbackS.members.indexOf(setbackS.chair), balloon);
        }

        if (balloon.x <= 0)
            balloon.velocity.x = 400.0;
        else
            balloon.velocity.x = -400.0;
    }
}