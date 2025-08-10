package game.levels;

import openfl.filters.BitmapFilter;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.Options;
import core.Paths;

import data.CharacterData;

import game.events.FocusCamPointEvent;

import game.stages.UncanonS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class OverseerL extends PlayState
{
    public var uncanonS:UncanonS;

    override function create():Void
    {
        stage = new UncanonS();

        uncanonS = cast (stage, UncanonS);

        super.create();
    }
}