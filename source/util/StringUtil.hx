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
                var split:Array<String> = str.split(delimiter);

                for (i in 0 ... split.length)
                {
                    var s:String = split[i];

                    s = s.substring(0, 1);

                    if (i == 0)
                        split[i] = s.toLowerCase();
                    else
                        split[i] = s.toUpperCase();

                    split[i] += s.substring(1, s.length + 1);
                }

                return split.join("");
            }

            case KEBAB:
                return str.toLowerCase().replace(delimiter, "-");

            case PASCAL:
            {
                var split:Array<String> = str.split(delimiter);

                for (i in 0 ... split.length)
                {
                    var s:String = split[i];

                    split[i] = s.substring(0, 1).toUpperCase() + s.substring(1, s.length + 1);
                }

                return split.join("");
            }
        }
    }

    public static function parseInt(str:String):Int
    {
        str = str.toLowerCase();

        var constants:Map<String, Int> = ["zero" => 0, "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5,
            "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9];
        
        if (constants.exists(str))
            return constants[str];

        return Std.parseInt(str) ?? -1;
    }
}

enum StringCase
{
    CAMEL;

    KEBAB;

    PASCAL;
}