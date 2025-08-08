package game.levels;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.math.FlxRect;

import core.Options;

import data.CharacterData;

import game.events.FocusCamCharEvent;
import game.events.FocusCamPointEvent;

import game.stages.ScribbleS;

import music.Conductor;

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
        
        playField.scoreClip.visible = false;

        replaceHealthBar();
        
        var plrStrumlineX:Float = plrStrumline.strums.x;
        
        var oppStrumlineX:Float = oppStrumline.strums.x;

        plrStrumline.strums.x = oppStrumlineX;
        
        oppStrumline.strums.x = plrStrumlineX;

        scribbleS.classicHall0.visible = true;

        player.scale.set(3.75, 3.75);
        player.setPosition(700, 100);

        opponent.setPosition(1050, 185);

        setCamStartPos();
    }

    public function replaceHealthBar():Void
    {
        var healthBar:HealthBar = playField.healthBar;

        healthBar.kill();

        playField.healthBar = new OldHealthBar(0.0, 0.0, conductor);

        healthBar = playField.healthBar;
        
        healthBar.onEmptied.add(gameOver);

        healthBar.setPosition(healthBar.getCenterX(),
            Options.downscroll ? -20.0 : FlxG.height - healthBar.height + 20.0);

        updateHealthBar("opponent");

        updateHealthBar("player");

        playField.insert(playField.members.indexOf(playField.scoreTxt) + 1, healthBar);
    }
}

// TODO: Replace old components with red-green bar.
class OldHealthBar extends HealthBar
{
    public function new(x:Float = 0.0, y:Float = 0.0, conductor:Conductor):Void
    {
        super(x, y, conductor);

        gradient.kill();

        needle.kill();

        overlay.kill();

        positionNeedle = null;
    }
}

class OldBarSideSprite extends FlxSprite
{
    @:noCompletion
    override function set_clipRect(clip:FlxRect):FlxRect
    {
        clipRect = clip;

        return clipRect;
    }
}