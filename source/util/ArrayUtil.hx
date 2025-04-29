package util;

class ArrayUtil
{
    public static function pushMany<T>(arr:Array<T>, ...xyz:T):Void
    {
        for (i in 0 ... xyz.length)
            arr.push(xyz[i]);
    }

    public static function first<T>(arr:Array<T>, func:(T)->Bool = null):T
    {
        var result:T = null;

        if (arr.length == 0.0)
            return result;

        if (func == null)
            result = arr[0];
        else
        {
            for (i in 0 ... arr.length)
            {
                var field:T = arr[i];

                if (func(field))
                {
                    result = field;

                    break;
                }
            }
        }

        return result;
    }

    public static function last<T>(arr:Array<T>, func:(T)->Bool = null):T
    {
        var result:T = null;

        if (arr.length == 0.0)
            return result;

        if (func == null)
            result = arr[arr.length - 1];
        else
        {
            var index:Int = arr.length - 1;

            while (index >= 0.0)
            {
                var field:T = arr[index];

                if (func(field))
                {
                    result = field;

                    break;
                }

                index--;
            }
        }

        return result;
    }
}