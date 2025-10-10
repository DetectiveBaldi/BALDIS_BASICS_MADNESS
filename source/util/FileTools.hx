package util;

using StringTools;

class FileTools
{
    public static function openFolder(path:String):Void
    {
        #if sys
        Sys.command('explorer', [path.replace('/', '\\')]);
        #end
    }
}