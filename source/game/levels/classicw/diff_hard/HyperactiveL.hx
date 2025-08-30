package game.levels.classicw.diff_hard;

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

import game.stages.classicw.diff_hard.HyperactiveS;

using util.MathUtil;

using StringTools;

class HyperactiveL extends PlayState
{
    public var hyperactiveS:HyperactiveS;

    override function create():Void
    {
        stage = new HyperactiveS();

        hyperactiveS = cast (stage, HyperactiveS);

        super.create();
    }
}