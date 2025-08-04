package util;

using StringTools;

class StringUtil
{
    public static function setCase(str:String, delimiter:String = " ", strCase:StringCase):String
    {
        switch (strCase:StringCase)
        {
            case CAMEL:
            {
                var splt:Array<String> = str.split(delimiter);

                for (i in 0 ... splt.length)
                {
                    var s:String = splt[i];

                    s = s.substring(0, 1);

                    if (i == 0)
                        splt[i] = s.toLowerCase();
                    else
                        splt[i] = s.toUpperCase();

                    splt[i] += s.substring(1, s.length + 1);
                }

                return splt.join("");
            }

            case KEBAB:
                return str.toLowerCase().replace(delimiter, "-");

            case PASCAL:
            {
                var splt:Array<String> = str.split(delimiter);

                for (i in 0 ... splt.length)
                {
                    var s:String = splt[i];

                    splt[i] = s.substring(0, 1).toUpperCase() + s.substring(1, s.length + 1);
                }

                return splt.join("");
            }
        }
    }

    public static function parseInt(str:String):Int
    {
        str = str.toLowerCase();

        var constantTen:Map<String, Int> = ["zero" => 0, "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5,
            "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9];
        
        if (constantTen.exists(str))
            return constantTen[str];

        return Std.parseInt(str) ?? -1;
    }
}

enum StringCase
{
    CAMEL;

    KEBAB;

    PASCAL;
}