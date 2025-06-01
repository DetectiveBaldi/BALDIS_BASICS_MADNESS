package game.notes;

import haxe.Json;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.math.FlxPoint;

import core.Assets;
import core.Paths;

import data.AnimationData;

using StringTools;

class NoteSplash extends FlxSprite
{
    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic("game/notes/NoteSplash/default"), Paths.image(Paths.xml
            ("game/notes/NoteSplash/default")));

        var animations:Array<AnimationData> = new Array<AnimationData>();

        for (i in 0 ... Note.DIRECTIONS.length)
        {
            var dir:String = Note.DIRECTIONS[i].toLowerCase();

            for (i in 0 ... 2)
                animations.push({name: '${dir}${i}', prefix: 'note impact ${i} ${dir}', indices: []});
        }

        for (i in 0 ... animations.length)
        {
            var _animation:AnimationData = animations[i];

            _animation.frameRate ??= 24.0;

            _animation.looped ??= false;

            _animation.flipX ??= false;

            _animation.flipY ??= false;

            if (_animation.indices.length > 0.0)
                animation.addByIndices(_animation.name, _animation.prefix, _animation.indices, "", _animation.frameRate, _animation.looped, _animation.flipX, _animation.flipY);
            else
                animation.addByPrefix(_animation.name, _animation.prefix, _animation.frameRate, _animation.looped, _animation.flipX, _animation.flipY);
        }

        animation.onFinish.add((name:String) -> kill());

        scale.set(1.1, 1.1);

        updateHitbox();
    }

    public function play(direction:Int, reversed:Bool):Void
    {
        animation.play(Note.DIRECTIONS[direction].toLowerCase() + FlxG.random.int(0, 1), false, reversed);
    }
}