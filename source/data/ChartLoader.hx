package data;

import haxe.Json;

import sys.FileSystem;

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
        {
            var filesList:Array<String> = FileSystem.readDirectory(path);

            var chartFile:String = filesList.first((file:String) -> file.startsWith("chart"));

            var chartFilePath:String = '${path}/' + chartFile;

            var difficulty:String = "normal";

            if (chartFilePath.contains("-"))
            {
                var split:Array<String> = chartFilePath.split("-");

                difficulty = split.last();
            }

            return FunkinConverter.parse(chartFilePath, metaFilePath, difficulty);
        }
        else
        {
            var chartFilePath:String = '${path}/chart.json';

            var chart:Dynamic = Json.parse(AssetCache.getText(chartFilePath));

            if (Reflect.hasField(chart, "format"))
                return PsychConverter.parse(chartFilePath, '${path}/credits.txt');
            else
                return chart;
        }
    }
}