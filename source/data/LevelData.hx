package data;

@:structInit
class LevelData
{
    public static function fromRaw(raw:RawLevelData):LevelData
    {
        return {week: "", name: raw.name};
    }

    public var week:String;

    public var name:String;
}

typedef RawLevelData =
{
    public var name:String;
}