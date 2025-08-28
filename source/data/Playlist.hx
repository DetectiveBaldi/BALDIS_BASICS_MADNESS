package data;

using util.ArrayUtil;

class Playlist
{
    public static function init():Void
    {
        // Baldi Week
        var week:WeekData = {name: "Baldi", nameSuffix: " Style", description: ""}

        week.description += 'You get a very suspicious note from your friend, asking you to get their "noteboos" ';

        week.description += "from a school you've never heard of before.\nWhat could go wrong?";

        week.levels.pushMany({week: week, name: "Warm Welcome"}, {week: week, name: "Revision"}, 
            {week: week, name: "Gain Ground"});
        
        WeekData.list.push(week);

        // Classic Week
        week = {name: "Classic", nameSuffix: " Style", description: ""}

        week.description += 'While you try to avoid Baldi, his friends come in play and ';
        
        week.description += "try to stop you from your objective! Be careful, you don't wanna get caught...";

        week.levels.pushMany({week: week, name: "Playmate"}, {week: week, name: "Detention"},
            {week: week, name: "Standoff"}, {week: week, name: "Adrenaline"}, {week: week, name: "Hugs"});

        // Hard Difficulty
        week.levels.pushMany({week: week, name: "Rough Escape", difficulty: "Hard"});

        week.hasTvPortrait = true;

        WeekData.list.push(week);

        // Bladder Week
        week = {name: "Bladder", nameSuffix: " Style", description: ""}

        week.description += 'Out of pure curiosity, you slap a Portal Poster on a wall ';

        week.description += "you think seemed strange and ended up finding Bladder!\nDo you have what it takes to beat him?";

        week.levels.pushMany({week: week, name: "Walls"}, {week: week, name: "Lookalike"});

        week.hasTvPortrait = true;
        
        WeekData.list.push(week);

        // Scribble
        var level:LevelData = {week: null, name: "Scribble"}

        LevelData.list.push(level);

        // Setback
        level = {week: null, name: "Setback"}

        LevelData.list.push(level);

        // Literature
        level = {week: null, name: "Literature"}

        LevelData.list.push(level);

        // Bloxy Cola
        level = {week: null, name: "Bloxy Cola"}

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