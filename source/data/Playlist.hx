package data;

using util.ArrayUtil;

class Playlist
{
    public static function init():Void
    {
        // Baldi
        var week:WeekData = {name: "Baldi", nameSuffix: " Style", description: ""}

        week.description += 'You get a very suspicious note from your friend, asking you to get their "noteboos" ';

        week.description += "from a school you've never heard of before.\nWhat could go wrong?";

        week.levels.pushMany({week: week, name: "Warm Welcome"}, {week: week, name: "Revision"}, 
            {week: week, name: "Gain Ground"});
        
        WeekData.list.push(week);

        // Classic

        week = {name: "Classic", nameSuffix: " Style", description: ""}

        week.description += 'While you try to avoid Baldi, his friends come in play and ';
        
        week.description += "try to stop you from your objective! Be careful, you don't wanna get caught...";

        week.levels.pushMany({week: week, name: "Playmate"}, {week: week, name: "Walls"},
        {week: week, name: "Literature"}, {week: week, name: "Scribble"}, {week: week, name: "Warm Welcome"}, 
        {week: week, name: "Lookalike"}, {week: week, name: "Rough Escape"});

        week.hasTvPortrait = true;

        WeekData.list.push(week);

        // Bladder
        week = {name: "Bladder", nameSuffix: "'s Week", description: ""}

        week.description += 'Out of pure curiosity, you slap a Portal Poster on a wall ';

        week.description += "you think seemed strange and ended up finding Bladder!\nDo you have what it takes to beat him?";

        week.levels.pushMany({week: week, name: "Walls"}, {week: week, name: "Lookalike"});

        week.hasTvPortrait = true;
        
        WeekData.list.push(week);

        // Rough Escape
        LevelData.list.push({week : null, name: "Rough Escape"});

        // Scribble
        var level:LevelData = {week: null, name: "Scribble"}

        LevelData.list.push(level);

        // Setback
        level = {week: null, name: "Setback"}

        LevelData.list.push(level);

        // Literature
        level = {week: null, name: "Literature"}

        LevelData.list.push(level);

        // Mishap
        level = {week: null, name: "Mishap"}

        LevelData.list.push(level);

        // Beginnings
        level = {week: null, name: "Beginnings"}

        level.showInMysteryMenu = true;

        LevelData.list.push(level);

        // Uncanon
        var level:LevelData = {week: null, name: "Uncanon"}

        level.showInMysteryMenu = true;

        LevelData.list.push(level);

        // Two
        level = {week: null, name: "Two"}

        level.showInMysteryMenu = true;

        LevelData.list.push(level);

        // Overseer
        var level:LevelData = {week: null, name: "Overseer"}

        level.showInMysteryMenu = true;

        LevelData.list.push(level);
    }
}