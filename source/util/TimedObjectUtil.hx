package util;

import haxe.ds.ArraySort;

class TimedObjectUtil
{
    public static function sort(arr:Array<TimedObject>):Array<TimedObject>
    {
        ArraySort.sort(arr, (a:TimedObject, b:TimedObject) -> Std.int(a.time - b.time));

        return arr;
    }
}

typedef TimedObject =
{
    var time:Float;
}