package data;

import game.HighScore;

using util.ArrayUtil;

@:structInit
class WeekData
{
    public static var list:Array<WeekData> = new Array<WeekData>();

    public var name:String;

    public var nameSuffix:String;

    public var description:String;

    public var levels:Array<LevelData>;

    public var showInStoryMenu:Bool;

    public var showInFreeplayMenu:Bool;

    public var scoreRequirements:Map<String, Array<String>>;

    public function new(name:String, nameSuffix:String, description:String):Void
    {
        this.name = name;

        this.nameSuffix = nameSuffix;

        this.description = description;

        levels = new Array<LevelData>();

        showInStoryMenu = true;

        showInFreeplayMenu = true;

        scoreRequirements = new Map<String, Array<String>>();
    }

    public function getFormattedName():String
    {
        return '${name.split(" ").join("").toLowerCase()}w';
    }

    /**
     * Returns an exact copy of this `WeekData`. Level data is not recreated!
     * @return `WeekData`
     */
    public function copy():WeekData
    {
        var data:WeekData = {name: name, nameSuffix: nameSuffix, description: description}

        // TODO: Check that copying here is necessary.
        data.levels = levels.copy();

        data.showInStoryMenu = showInStoryMenu;

        data.showInFreeplayMenu = showInFreeplayMenu;

        data.scoreRequirements = scoreRequirements.copy();

        return data;
    }

    public function hasDifficulty(difficulty:String):Bool
    {
        return levels.first((lv:LevelData) -> lv.difficulty == difficulty) != null;
    }

    public function filterByDifficulty(difficulty:String):Array<LevelData>
    {
        return levels.filter((lv:LevelData) -> lv.difficulty == difficulty);
    }

    public function addScoreRequirement(name:String, difficulty:String):Void
    {
        var requirement:Array<String> = scoreRequirements[name] ??= new Array<String>();

        requirement.push(difficulty);
    }

    public function scoresValidated():Bool
    {
        for (k => v in scoreRequirements)
        {
            var requirement:Array<String> = v;

            for (diff in requirement)
            {
                if (HighScore.getWeekScore(k, diff).score == 0.0)
                    return false;
            }
        }

        return true;
    }
}