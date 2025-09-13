package util;

import haxe.ds.ArraySort;

class TimingUtil
{
    public static function sortTimed<T:TimedObject>(objects:Array<T>):Void
    {
        ArraySort.sort(objects, (a:T, b:T) -> Std.int(a.time - b.time));
    }
}

typedef TimedObject =
{
    var time:Float;
}