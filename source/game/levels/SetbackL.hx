package game.levels;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

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

        setCamStartPos();

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

        player.setPosition(215.0, -20.0);

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

            var opp:Character = new Character(conductor, 0.0, 0.0, CharacterData.get("dsci-pov"));
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
}