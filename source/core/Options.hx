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

    public static var flashing(get, set):Bool;

    @:noCompletion
    static function get_flashing():Bool
    {
        return FlxG.save.data.options.flashing ??= true;
    }

    @:noCompletion
    static function set_flashing(_flashing:Bool):Bool
    {
        FlxG.save.data.options.flashing = _flashing;

        return flashing;
    }

    public static var shaders(get, set):Bool;

    @:noCompletion
    static function get_shaders():Bool
    {
        return FlxG.save.data.options.shaders ??= true;
    }

    @:noCompletion
    static function set_shaders(_shaders:Bool):Bool
    {
        FlxG.save.data.options.shaders = _shaders;

        return shaders;
    }

    public static var controls(get, set):Map<String, Array<Int>>;

    @:noCompletion
    static function get_controls():Map<String, Array<Int>>
    {
        return FlxG.save.data.options.controls ??= 
        [
            "NOTE:LEFT" => [65, 37],

            "NOTE:DOWN" => [83, 40],
            
            "NOTE:UP" => [87, 38],
            
            "NOTE:RIGHT" => [68, 39],
            
            "UI:PAUSE" => [13, 27]
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

    public static var automatedInputs(get, set):Bool;

    @:noCompletion
    static function get_automatedInputs():Bool
    {
        return FlxG.save.data.options.automatedInputs ??= false;
    }

    @:noCompletion
    static function set_automatedInputs(_automatedInputs:Bool):Bool
    {
        FlxG.save.data.options.automatedInputs = _automatedInputs;

        return automatedInputs;
    }

    public static function init():Void
    {
        FlxG.save.data.options ??= {};
    }
}