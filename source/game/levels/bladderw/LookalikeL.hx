package game.levels.bladderw;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.bladderw.LookalikeS;

using util.MathUtil;

using StringTools;

class LookalikeL extends PlayState
{
    public var lookalikeS:LookalikeS;

    override function create():Void
    {
        stage = new LookalikeS();

        lookalikeS = cast (stage, LookalikeS);

        super.create();

        gameCameraZoom = 0.8;

        lookalikeS.room3.visible = true;

        player.setPosition(300, 150);
        
        opponent.setPosition(0, -200);

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    }
}