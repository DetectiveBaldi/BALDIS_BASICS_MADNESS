package data;

@:structInit
class LevelData
{
    public static var list:Array<LevelData> = new Array<LevelData>();

    public var week:WeekData;

    public var name:String;

    public var hiddenWithoutScore:Bool;

    public function new(week:WeekData, name:String):Void
    {
        this.week = week;

        this.name = name;

        hiddenWithoutScore = false;
    }

    public function getClsPath():String
    {
        var splt:Array<String> = name.split(" ");

        splt[0].toUpperCase();

        for (i in 1 ... splt.length)
        {
            var s:String = splt[i];

            splt[i] = s.substring(0, 1).toUpperCase();
        }

        return '${splt.join("")}L';
    }
}