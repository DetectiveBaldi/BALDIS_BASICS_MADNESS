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

    public function addToQueue(sound:FlxSound):Void
    {
        if (list.length == 0.0)
        {
            sound.onComplete = queueNext;

            sound.play();

            onUpdate.dispatch(sound);
        }

        list.push(sound);
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

    public function flushQueue(stopCurrent:Bool):Void
    {
        if (list.length == 0.0)
            return;

        if (stopCurrent)
        {
            var snd:FlxSound = list[0];

            snd.stop();

            snd.onComplete = null;
        }

        list.resize(0);
    }

    public function queueNext():Void
    {
        if (list.length == 0.0)
            return;

        var lst:FlxSound = list[0];

        lst.onComplete = null;

        list.shift();

        if (list.length == 0.0)
            return;

        var nxt:FlxSound = list[0];

        nxt.onComplete = queueNext;

        nxt.play(true);

        onUpdate.dispatch(nxt);
    }

    public function destroy():Void
    {
        flushQueue(true);

        list = null;

        onUpdate = cast FlxDestroyUtil.destroy(onUpdate);
    }
}