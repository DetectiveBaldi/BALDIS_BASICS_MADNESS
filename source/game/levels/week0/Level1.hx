package game.levels.week0;

import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ShaderFilter;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.animation.FlxAnimation;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.Assets;
import core.Options;
import core.Paths;

import data.CharacterData;

import game.events.CameraFollowEvent;

import game.stages.School;

using util.MathUtil;

using StringTools;

class Level1 extends PlayState
{
    public var castedStage(get, never):School;

    @:noCompletion
    function get_castedStage():School
    {
        return cast (stage, School);
    }

    override function create():Void
    {
        stage = new School();

        super.create();

        gameCameraTarget.centerTo();

        gameCameraZoom = 0.8;

        plrStrumline.clearKeys();

        plrStrumline.resetStrums();
    
        if (!Options.automatedInputs)
            plrStrumline.getKeys();
    
        castedStage.revisionBg.visible = true;
        
        players.setPosition(215, 135);
        opponents.setPosition(435, 35);
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);
    
    
    }

    override function beatHit(beat:Int):Void
    {
        super.beatHit(beat);
    }
}