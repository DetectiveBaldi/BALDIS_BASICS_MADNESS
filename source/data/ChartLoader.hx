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
        var rawMetaPath:String = path + (path.endsWith("/") ? "meta" : "/meta");

        if (FileSystem.exists(Paths.json(rawMetaPath)))
        {
            var rawChartPath:String = (path.endsWith("/") ? path : '${path}/') + FileSystem.readDirectory(path).first((_path:String) -> _path.startsWith("chart")).replace(".json", "");

            var diff:String = rawChartPath.contains("-") ? rawChartPath.split("-").last() : "normal";

            return FunkinConverter.parse(rawChartPath, rawMetaPath, diff);
        }
        else
        {
            var rawChartPath:String = path + (path.endsWith("/") ? "chart" : "/chart");

            var rawChart:Dynamic = Json.parse(Assets.getText(Paths.json(rawChartPath)));

            if (Reflect.hasField(rawChart, "format"))
                return PsychConverter.parse(rawChartPath.substring(0, rawChartPath.length - 6));
            else
                return Chart.parse(Json.parse(Assets.getText(Paths.json(rawChartPath))));
        }
    }
}