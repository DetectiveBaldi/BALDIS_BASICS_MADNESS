package util;

using StringTools;

class FileTools
{
    public static function openFolder(path:String):Void
    {
        Sys.command('explorer', [path.replace('/', '\\')]);
    }
}