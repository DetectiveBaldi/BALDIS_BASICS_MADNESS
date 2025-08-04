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

    public var requiresScoreToPlay:Bool;

    public var showInStoryMenu:Bool;

    public var showInFreeplayMenu:Bool;

    public function new(name:String, nameSuffix:String, description:String):Void
    {
        this.name = name;

        this.nameSuffix = nameSuffix;

        this.description = description;

        levels = new Array<LevelData>();

        requiresScoreToPlay = false;

        showInStoryMenu = true;

        showInFreeplayMenu = true;
    }

    public function getPackPath():String
    {
        return '${name.split(" ").join("").toLowerCase()}w';
    }
}