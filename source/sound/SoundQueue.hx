package sound;

import flixel.FlxBasic;

import flixel.sound.FlxSound;

import flixel.util.FlxSignal;

class SoundQueue extends FlxBasic
{
    public var list:Array<FlxSound>;

    public var onNextSnd:FlxSignal;
    
    public function new():Void
    {
        super();

        visible = false;

        list = new Array<FlxSound>();

        onNextSnd = new FlxSignal();
    }

    override function destroy():Void
    {
        super.destroy();

        flushQueue(true);

        list = null;
    }

    public function addToQueue(sound:FlxSound):Void
    {       
        list.push(sound);

        if (list.length == 1.0)
        {
            sound.onComplete = queueNext;

            sound.play();

            onNextSnd.dispatch();
        }
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

        onNextSnd.dispatch();
    }
}