package util;

import haxe.ds.ArraySort;

class TimingUtil
{
    public static function sortTimed<T:TimedObject>(v:Array<T>):Void
    {
        ArraySort.sort(v, (a:T, b:T) -> Std.int(a.time - b.time));
    }
}

typedef TimedObject =
{
    var time:Float;
}