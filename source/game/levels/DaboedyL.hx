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

import game.stages.DaboedyS;

using util.MathUtil;

using StringTools;

class DaboedyL extends PlayState
{
    public var daboedyS:DaboedyS;

    override function create():Void
    {
        stage = new DaboedyS();

        daboedyS = cast (stage, DaboedyS);

        super.create();

        daboedyS.boedy.visible = true;

        cameraPoint.centerTo();

        gameCamera.snapToTarget();

        gameCameraZoom = 0.8;

        opponent.scale.set(1.5, 1.5);

        opponent.setPosition(-185.0, 200.0);

        player.setPosition(680.0, 180.0);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    }
}