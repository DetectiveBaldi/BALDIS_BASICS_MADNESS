package data;

@:structInit
class WeekData
{
    public static var list:Array<WeekData> = new Array<WeekData>();

    public var name:String;

    public var nameSuffix:String;

    public var description:String;

    public var levels:Array<LevelData>;

    public var requiresScoreToPlay:Bool;

    public var showInStoryMenu:Bool;

    public var showInFreeplayMenu:Bool;

    public var hasTvPortrait:Bool;

    public function new(name:String, nameSuffix:String, description:String):Void
    {
        this.name = name;

        this.nameSuffix = nameSuffix;

        this.description = description;

        levels = new Array<LevelData>();

        requiresScoreToPlay = true;

        showInStoryMenu = true;

        showInFreeplayMenu = true;

        hasTvPortrait = true;
    }

    public function getPackPath():String
    {
        return '${name.split(" ").join("").toLowerCase()}w';
    }
}