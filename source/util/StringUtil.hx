package util;

using StringTools;

class StringUtil
{
    public static function setCase(str:String, ?delimiter:String, strCase:StringCase):String
    {
        switch (strCase:StringCase)
        {
            case CAMEL:
            {
                var splt:Array<String> = str.split(delimiter ??= " ");

                for (i in 0 ... splt.length)
                {
                    var s:String = splt[i];

                    if (i == 0)
                        splt[i] = s.substring(0, 1).toLowerCase();
                    else
                        splt[i] = s.substring(0, 1).toUpperCase();

                    splt[i] += s.substring(1, s.length + 1);
                }

                return splt.join("");
            }

            case KEBAB:
                return str.toLowerCase().replace(delimiter ??= " ", "-");

            case PASCAL:
            {
                var splt:Array<String> = str.split(delimiter ??= " ");

                for (i in 0 ... splt.length)
                {
                    var s:String = splt[i];

                    splt[i] = s.substring(0, 1).toUpperCase() + s.substring(1, s.length + 1);
                }

                return splt.join("");
            }
        }
    }
    
    public static function reverse(str:String, delimiter:String, join:String):String
    {
        var splt:Array<String> = str.split(delimiter);

        splt.reverse();

        return splt.join(join);
    }
}

enum StringCase
{
    CAMEL;

    KEBAB;

    PASCAL;
}