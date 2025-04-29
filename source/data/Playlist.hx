package data;

using util.ArrayUtil;

class Playlist
{
    public static function init():Void
    {
        var week:WeekData = {name: "Baldi", description: "", levels: new Array<LevelData>()}

        week.description += 'You get a very suspicious note from your friend, asking you to get their "noteboos" ';

        week.description += "from a school you've never heard of before.\nWhat could go wrong?";

        week.levels.pushMany(new LevelData(week, "Warm Welcome"), new LevelData(week, "Revision"), 
            new LevelData(week, "Gain Ground"));

        WeekData.list.push(week);

        LevelData.list.push(new LevelData(null, "Rough Escape"));
    }
}