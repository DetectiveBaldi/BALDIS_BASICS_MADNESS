package sound;

import flixel.sound.FlxSound;

import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal.FlxTypedSignal;

class SoundQueue
{
    public var list:Array<FlxSound>;

    public var onUpdate:FlxTypedSignal<FlxSound->Void>;
    
    public function new():Void
    {
        list = new Array<FlxSound>();

        onUpdate = new FlxTypedSignal<FlxSound->Void>();
    }

    public function queue(sound:FlxSound):Void
    {
        if (list.length == 0.0)
        {
            sound.onComplete = updateQueue;

            sound.play();

            onUpdate.dispatch(sound);
        }

        list.push(sound);
    }

    public function remove(sound:FlxSound):Void
    {
        if (!list.contains(sound))
            return;

        var isPlaying:Bool = list[0] == sound;

        if (isPlaying)
            updateQueue();
        else
            list.remove(sound);
    }

    public function pause():Void
    {
        if (list.length == 0.0)
            return;

        list[0].pause();
    }

    public function resume():Void
    {
        if (list.length == 0.0)
            return;
        
        list[0].resume();
    }

    public function clearQueue(stopCurrent:Bool):Void
    {
        if (list.length == 0.0)
            return;

        if (stopCurrent)
        {
            var soundToStop:FlxSound = list[0];

            soundToStop.stop();

            soundToStop.onComplete = null;
        }

        list.resize(0);
    }

    public function updateQueue():Void
    {
        if (list.length == 0.0)
            return;

        var lastSound:FlxSound = list[0];

        lastSound.onComplete = null;

        list.shift();

        if (list.length == 0.0)
            return;

        var newSound:FlxSound = list[0];

        newSound.onComplete = updateQueue;

        newSound.play(true);

        onUpdate.dispatch(newSound);
    }

    public function destroy():Void
    {
        clearQueue(true);

        list = null;

        onUpdate = cast FlxDestroyUtil.destroy(onUpdate);
    }
}