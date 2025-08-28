package data;

import haxe.Json;

import sys.FileSystem;
import sys.io.File;

import core.AssetCache;
import core.Paths;

import data.ChartConverters;

using StringTools;

using util.ArrayUtil;

class ChartLoader
{
    public static function readPath(path:String):Chart
    {
        var metaFilePath:String = '${path}/meta.json';

        if (FileSystem.exists(metaFilePath))
            return FunkinConverter.run('${path}/chart.json', metaFilePath, "normal");
        else
        {
            var chartFilePath:String = '${path}/chart.json';

            var chart:Dynamic = Json.parse(File.getContent(chartFilePath));

            if (Reflect.hasField(chart, "song"))
                return PsychConverter.run(chartFilePath, '${path}/credits.txt');
            else
                return chart;
        }
    }
}