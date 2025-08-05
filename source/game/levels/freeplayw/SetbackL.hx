package game.levels.freeplayw;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.bladderw.WallsS;

using util.MathUtil;

using StringTools;

class SetbackL extends PlayState
{
    public var wallsS:WallsS;

    override function create():Void
    {
        stage = new WallsS();

        wallsS = cast (stage, WallsS);

        super.create();

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    }
}