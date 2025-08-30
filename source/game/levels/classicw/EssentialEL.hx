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

import game.stages.classicw.EssentialES;

using util.MathUtil;

using StringTools;

class EssentialEL extends PlayState
{
    public var essentialES:EssentialES;

    override function create():Void
    {
        stage = new EssentialES();

        essentialES = cast (stage, EssentialES);

        super.create();
    }
}