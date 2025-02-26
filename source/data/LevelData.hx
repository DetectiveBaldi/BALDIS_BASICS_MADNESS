package data;

// Contains several fields not available in configuration files.

@:structInit
class LevelData
{
    public var week:String;

    public var name:String;

    public var id:Int;
}

typedef RawLevelData =
{
    public var name:String;

    public var id:Int;
}