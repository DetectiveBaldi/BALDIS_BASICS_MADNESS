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

    public function getLevelsPackage():String
    {
        return '${name.split(" ").join("").toLowerCase()}w';
    }

    /**
     * Returns an exact copy of `this` `WeekData`. Level data is not recreated!
     * @return `WeekData`
     */
    public function copy():WeekData
    {
        var data:WeekData = {name: name, nameSuffix: nameSuffix, description: description}

        // TODO: Make sure that copying is necessary.
        data.levels = levels.copy();

        data.requiresScoreToPlay = requiresScoreToPlay;

        data.showInStoryMenu = showInStoryMenu;

        data.showInFreeplayMenu = showInFreeplayMenu;

        data.hasTvPortrait = hasTvPortrait;

        return data;
    }
}