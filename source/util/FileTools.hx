package util;

using StringTools;

@:nullSafety
class FileTools
{
    public static function openFolder(path:String):Void
    {
        Sys.command('explorer', [path.replace('/', '\\')]);
    }
}