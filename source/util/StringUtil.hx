package util;

using StringTools;

class StringUtil
{
    public static function setCase(str:String, strCase:StringCase):String
    {
        switch (strCase:StringCase)
        {
            case KEBAB:
                return str.toLowerCase().replace(" ", "-");
        }
    }
}

enum StringCase
{
    KEBAB;
}