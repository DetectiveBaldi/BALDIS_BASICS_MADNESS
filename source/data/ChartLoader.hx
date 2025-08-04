package data;

import haxe.Json;

import sys.FileSystem;

import core.Assets;
import core.Paths;

import data.ChartConverters;

using StringTools;

using util.ArrayUtil;

class ChartLoader
{
    public static function parse(path:String):Chart
    {
        var metaPath:String = path + (path.endsWith("/") ? "meta" : "/meta");

        if (FileSystem.exists(Paths.json(metaPath)))
        {
            var chartPath:String = (path.endsWith("/") ? path : '${path}/') +
                FileSystem.readDirectory(path).first((pat:String) -> pat.startsWith("chart")).replace(".json", "");

            var difficulty:String = chartPath.contains("-") ? chartPath.split("-").last() : "normal";

            return FunkinConverter.parse(chartPath, metaPath, difficulty);
        }
        else
        {
            var chartPath:String = path + (path.endsWith("/") ? "chart" : "/chart");

            var chart:Dynamic = Json.parse(Assets.getText(Paths.json(chartPath)));

            if (Reflect.hasField(chart, "format"))
                return PsychConverter.parse(chartPath.substring(0, chartPath.length - 6));
            else
                return chart;
        }
    }
}