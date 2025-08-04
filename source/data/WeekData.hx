package data;

import haxe.Json;

import haxe.ds.ArraySort;

import sys.FileSystem;

import core.Assets;

import data.LevelData;

@:structInit
class WeekData
{
    public static var list:Array<WeekData> = new Array<WeekData>();

    public var name:String;

    public var nameSuffix:String;

    public var description:String;

    public var levels:Array<LevelData>;

    public function getPackPath():String
    {
        return '${name.split(" ").join("").toLowerCase()}w';
    }
}