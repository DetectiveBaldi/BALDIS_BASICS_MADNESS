package game.notes;

import haxe.Json;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.math.FlxPoint;

import core.AssetCache;
import core.Paths;

import data.AnimationData;

using StringTools;

class NoteSplash extends FlxSprite
{
    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("game/notes/NoteSplash/default"), Paths.image(Paths.xml
            ("game/notes/NoteSplash/default")));

        var animations:Array<AnimationData> = new Array<AnimationData>();

        for (i in 0 ... Note.DIRECTIONS.length)
        {
            var dir:String = Note.DIRECTIONS[i].toLowerCase();

            for (i in 0 ... 2)
                animations.push({name: '${dir}${i}', prefix: 'note impact ${i} ${dir}'});
        }

        for (i in 0 ... animations.length)
        {
            var animData:AnimationData = animations[i];

            animData.frameRate ??= 24.0;

            animData.looped ??= false;

            animData.flipX ??= false;

            animData.flipY ??= false;

            if (animData.indices != null)
                animation.addByIndices(animData.name, animData.prefix, animData.indices, "", animData.frameRate, animData.looped, animData.flipX, animData.flipY);
            else
                animation.addByPrefix(animData.name, animData.prefix, animData.frameRate, animData.looped, animData.flipX, animData.flipY);
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