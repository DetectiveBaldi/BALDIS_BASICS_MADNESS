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

import game.stages.BloxyCS;

using util.MathUtil;

using StringTools;

using flixel.util.FlxColorTransformUtil;

class BloxyCL extends PlayState
{
    public var bloxyCS:BloxyCS;

    override function create():Void
    {
        stage = new BloxyCS();

        bloxyCS = cast (stage, BloxyCS);

        super.create();
    
        gameCameraZoom = 0.8;

        setCamStartPos();

        bloxyCS.oldSchool.visible = true;

        player.setPosition(600.0, 125.0);
    
        opponent.setPosition(-250.0, 125.0);
    }

    override function stepHit(step:Int):Void
    {
        // im gonna add minor events later trust
    }
}