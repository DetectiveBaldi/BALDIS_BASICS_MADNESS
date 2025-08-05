package data;

using util.ArrayUtil;

class Playlist
{
    public static function init():Void
    {
        // Baldi
        var week:WeekData = {name: "Baldi", nameSuffix: "'s Week", description: ""}

        week.description += 'You get a very suspicious note from your friend, asking you to get their "noteboos" ';

        week.description += "from a school you've never heard of before.\nWhat could go wrong?";

        week.levels.pushMany({week: week, name: "Warm Welcome"}, {week: week, name: "Revision"}, 
            {week: week, name: "Gain Ground"});
        
        WeekData.list.push(week);

        // Freeplay
        week = {name: "Freeplay", nameSuffix: "'s Week", description: ""}

        week.levels.pushMany({week: week, name: "Scribble"}, {week: week, name: "Setback"});

        week.hasTvPortrait = false;
        
        WeekData.list.push(week);

        // Bladder
        week = {name: "Bladder", nameSuffix: "'s Week", description: ""}

        week.levels.pushMany({week: week, name: "Walls"}, {week: week, name: "Lookalike"});

        week.hasTvPortrait = false;
        
        WeekData.list.push(week);

        // Rough Escape
        LevelData.list.push({week : null, name: "Rough Escape"});

        // Beginnings
        var level:LevelData = {week: null, name: "Beginnings"}

        level.hiddenWithoutScore = true;

        LevelData.list.push(level);
    }
}