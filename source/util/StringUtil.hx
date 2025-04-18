package util;

using StringTools;

class StringUtil
{
    public static function setCase(str:String, strCase:StringCase):String
    {
        switch (strCase:StringCase)
        {
            case CAMEL:
            {
                var splt:Array<String> = str.split(str.contains("-") ? "-" : " ");

                for (i in 0 ... splt.length)
                {
                    var s:String = splt[i];

                    if (i == 0)
                        splt[i] = s.substring(0, 1).toLowerCase() + s.substring(1, s.length + 1);
                    else
                        splt[i] = s.substring(0, 1).toUpperCase() + s.substring(1, s.length + 1);
                }

                return splt.join(" ");
            }

            case KEBAB:
                return str.toLowerCase().replace(" ", "-");

            case PASCAL:
            {
                var splt:Array<String> = str.split(str.contains("-") ? "-" : " ");

                for (i in 0 ... splt.length)
                {
                    var s:String = splt[i];

                    splt[i] = s.substring(0, 1).toUpperCase() + s.substring(1, s.length + 1);
                }

                return splt.join(" ");
            }
        }
    }
}

enum StringCase
{
    CAMEL;

    KEBAB;

    PASCAL;
}