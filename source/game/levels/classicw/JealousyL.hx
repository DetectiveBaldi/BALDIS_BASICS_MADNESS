package game.levels.classicw;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import flixel.util.FlxColor;

import core.AssetCache;
import core.Options;

import data.CharacterData;

import game.events.SetCamFocusEvent;

import game.stages.classicw.JealousyS;

using util.MathUtil;

using StringTools;

class JealousyL extends PlayState
{
    public var jealousyS:JealousyS;

    override function create():Void
    {
        stage = new JealousyS();

        jealousyS = cast (stage, JealousyS);

        super.create();
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {

        }
    }
}