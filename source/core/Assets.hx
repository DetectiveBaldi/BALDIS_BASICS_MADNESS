package core;

import sys.io.File;

import lime.media.AudioBuffer;

import lime.media.vorbis.VorbisFile;

import openfl.display.BitmapData;

import openfl.media.Sound;

import flixel.FlxG;
import flixel.FlxState;

import flixel.graphics.FlxGraphic;

import flixel.sound.FlxSound;

import core.Options;

using StringTools;

using util.ArrayUtil;

class Assets
{
    public static var lastState:Class<FlxState>;

    public static var graphics:Map<String, FlxGraphic>;

    public static var sounds:Map<String, Sound>;

    public static var music:Map<String, Sound>;

    public static function init():Void
    {
        graphics = new Map<String, FlxGraphic>();

        sounds = new Map<String, Sound>();

        music = new Map<String, Sound>();

        FlxG.signals.preStateSwitch.add(() -> lastState = Type.getClass(FlxG.state) );

        FlxG.signals.preStateCreate.add((nxt:FlxState) -> { if (lastState != Type.getClass(nxt)) clearCaches(); });
    }

    public static function getGraphic(path:String, raw = false, gpuCaching:Bool = true):FlxGraphic
    {
        if (!raw)
            path = Paths.image(Paths.png(path));

        if (graphics.exists(path))
            return graphics[path];

        var graphic:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(path));
        
        if (Options.gpuCaching && gpuCaching)
            graphic.bitmap.disposeImage();

        graphic.persist = true;

        graphics[path] = graphic;

        return graphics[path];
    }

    public static function removeGraphic(path:String):Void
    {
        if (!graphics.exists(path))
            return;

        var graphic:FlxGraphic = graphics[path];

        if (graphic.useCount > 0.0)
            return;

        FlxG.bitmap.remove(graphic);

        graphics.remove(path);
    }

    public static function getSound(path:String, raw = false):Sound
    {
        if (!raw)
            path = Paths.sound(Paths.ogg(path));

        if (sounds.exists(path))
            return sounds[path];

        sounds[path] = Sound.fromFile(path);

        return sounds[path];
    }

    public static function getMusic(path:String, raw:Bool = false, stream:Bool = true):Sound
    {
        if (!raw)
            path = Paths.music(Paths.ogg(path));

        if (music.exists(path))
            return music[path];

        if (stream)
            music[path] = Sound.fromAudioBuffer(AudioBuffer.fromVorbisFile(VorbisFile.fromFile(path)));
        else
            music[path] = Sound.fromFile(path);

        return music[path];
    }

    public static function getAudioPath(mus:Bool, aud:Sound):String
    {
        var map:Map<String, Sound> = mus ? music : sounds;

        for (k => v in map)
            if (aud == v)
                return k;

        return null;
    }

    public static function removeAudio(mus:Bool, path:String):Void
    {
        var map:Map<String, Sound> = mus ? music : sounds;

        if (!map.exists(path))
            return;

        var aud:Sound = map[path];

        @:privateAccess
        if (FlxG.sound.defaultSoundGroup.sounds.first((snd:FlxSound) -> snd.active && snd._sound == aud) != null)
                return;

        aud.close();

        openfl.utils.Assets.cache.removeSound(path);

        map.remove(path);
    }
    
    public static function clearCaches():Void
    {
        for (k => v in graphics)
            removeGraphic(k);

        for (k => v in sounds)
            removeAudio(false, k);

        for (k => v in music)
            removeAudio(true, k);
    }

    public static function getText(path:String):String
    {
        return File.getContent(path);
    }
}