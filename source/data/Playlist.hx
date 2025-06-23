package data;

using util.ArrayUtil;

class Playlist
{
    public static function init():Void
    {
        var week:WeekData = {name: "Baldi", description: "", levels: new Array<LevelData>()}

        week.description += 'You get a very suspicious note from your friend, asking you to get their "noteboos" ';

        week.description += "from a school you've never heard of before.\nWhat could go wrong?";

        week.levels.pushMany(new LevelData(week, "Warm Welcome", false), new LevelData(week, "Revision", false), 
            new LevelData(week, "Gain Ground", false));

        WeekData.list.push(week);

        LevelData.list.push(new LevelData(null, "Rough Escape", false));

        LevelData.list.push(new LevelData(null, "Beginnings", true));
    }
}