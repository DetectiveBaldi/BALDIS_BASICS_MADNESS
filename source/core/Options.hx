package core;

import flixel.FlxG;

class Options
{
    public static var autoPause(get, set):Bool;

    @:noCompletion
    static function get_autoPause():Bool
    {
        return FlxG.save.data.options.autoPause ??= true;
    }

    @:noCompletion
    static function set_autoPause(_autoPause:Bool):Bool
    {
        FlxG.save.data.options.autoPause = _autoPause;

        return autoPause;
    }

    public static var frameRate(get, set):Int;

    @:noCompletion
    static function get_frameRate():Int
    {
        return FlxG.save.data.options.frameRate ??= 60;
    }

    static function set_frameRate(_frameRate:Int):Int
    {
        FlxG.save.data.options.frameRate = _frameRate;

        return frameRate;
    }

    public static var gpuCaching(get, set):Bool;

    @:noCompletion
    static function get_gpuCaching():Bool
    {
        return FlxG.save.data.options.gpuCaching ??= false;
    }

    @:noCompletion
    static function set_gpuCaching(_gpuCaching:Bool):Bool
    {
        FlxG.save.data.options.gpuCaching = _gpuCaching;

        return gpuCaching;
    }

    public static var soundStreaming(get, set):Bool;

    @:noCompletion
    static function get_soundStreaming():Bool
    {
        return FlxG.save.data.options.soundStreaming ??= false;
    }

    @:noCompletion
    static function set_soundStreaming(_soundStreaming:Bool):Bool
    {
        FlxG.save.data.options.soundStreaming = _soundStreaming;

        return soundStreaming;
    }
    
    public static var persistentCache(get, set):Bool;

    @:noCompletion
    static function get_persistentCache():Bool
    {
        return FlxG.save.data.options.persistentCache ??= true;
    }
    
    @:noCompletion
    static function set_persistentCache(_persistentCache:Bool):Bool
    {
        FlxG.save.data.options.persistentCache = _persistentCache;

        return _persistentCache;
    }

    public static var controls(get, set):Map<String, Array<Int>>;

    @:noCompletion
    static function get_controls():Map<String, Array<Int>>
    {
        return FlxG.save.data.options.controls ??= 
        [
            "NOTE:LEFT" => getDefaultControl("NOTE:LEFT"),

            "NOTE:DOWN" => getDefaultControl("NOTE:DOWN"),
            
            "NOTE:UP" => getDefaultControl("NOTE:UP"),
            
            "NOTE:RIGHT" => getDefaultControl("NOTE:RIGHT"),
            
            "UI:PAUSE" => getDefaultControl("UI:PAUSE")
        ];
    }

    @:noCompletion
    static function set_controls(_controls:Map<String, Array<Int>>):Map<String, Array<Int>>
    {
        FlxG.save.data.options.controls = _controls;

        return controls;
    }

    public static var downscroll(get, set):Bool;

    @:noCompletion
    static function get_downscroll():Bool
    {
        return FlxG.save.data.options.downscroll ??= false;
    }

    @:noCompletion
    static function set_downscroll(_downscroll:Bool):Bool
    {
        FlxG.save.data.options.downscroll = _downscroll;

        return downscroll;
    }

    public static var middlescroll(get, set):Bool;

    @:noCompletion
    static function get_middlescroll():Bool
    {
        return FlxG.save.data.options.middlescroll ??= false;
    }

    @:noCompletion
    static function set_middlescroll(_middlescroll:Bool):Bool
    {
        FlxG.save.data.options.middlescroll = _middlescroll;

        return middlescroll;
    }

    public static var ghostTapping(get, set):Bool;

    @:noCompletion
    static function get_ghostTapping():Bool
    {
        return FlxG.save.data.options.ghostTapping ??= true;
    }

    @:noCompletion
    static function set_ghostTapping(_ghostTapping:Bool):Bool
    {
        FlxG.save.data.options.ghostTapping = _ghostTapping;

        return ghostTapping;
    }

    public static var gameModifiers(get, set):Map<String, Dynamic>;

    @:noCompletion
    static function get_gameModifiers():Map<String, Dynamic>
    {
        return FlxG.save.data.options.gameModifiers ??= new Map<String, Dynamic>();
    }

    @:noCompletion
    static function set_gameModifiers(_gameModifiers:Map<String, Dynamic>):Map<String, Dynamic>
    {
        FlxG.save.data.options.gameModifiers = _gameModifiers;

        return gameModifiers;
    }

    public static function init():Void
    {
        FlxG.save.data.options ??= {};
    }

    // Used for migrating and adding new controls without needing to reset save data!

    public static function getDefaultControl(name:String):Array<Int>
    {
        var defControl:Array<Int> = [];

        switch (name:String)
        {
            case "NOTE:LEFT":
                defControl = [65, 37];

            case "NOTE:DOWN":
                defControl = [83, 40];

            case "NOTE:UP":
                defControl = [87, 38];

            case "NOTE:RIGHT":
                defControl = [68, 39];

            case "UI:PAUSE":
                defControl = [13, 27];
        }

        return defControl;
    }
}