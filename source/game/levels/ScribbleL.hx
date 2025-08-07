package game.levels;

import flixel.tweens.FlxEase;

import flixel.util.FlxColor;

import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.ScribbleS;

using util.MathUtil;

using StringTools;

class ScribbleL extends PlayState
{
    public var scribbleS:ScribbleS;

    override function create():Void
    {
        stage = new ScribbleS();

        scribbleS = cast (stage, ScribbleS);

        super.create();
        
        scribbleS.classicHall0.visible = true;

        setCamStartPos();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    }
}