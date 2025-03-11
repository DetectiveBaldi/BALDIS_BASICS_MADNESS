package menus.options;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxTween;

import flixel.util.FlxColor;

import flixel.util.typeLimit.NextState;

import flixel.addons.display.FlxBackdrop;

import core.Assets;
import core.Paths;

import effects.TransitionState;

import menus.options.items.BaseOptionItem;
import menus.options.items.BoolOptionItem;
import menus.options.items.ControlOptionItem;
import menus.options.items.HeaderOptionItem;
import menus.options.items.NumericOptionItem.IntOptionItem;

using util.ArrayUtil;

class OptionsMenu extends TransitionState
{
    public var nextState:NextState;

    public var background:FlxSprite;

    public var backdrop:FlxBackdrop;

    public var gradient:FlxSprite;

    public var cornerCutout:FlxSprite;

    public var gear:FlxSprite;

    public var options:FlxTypedSpriteGroup<BaseOptionItem>;

    public var descriptor:FlxSprite;

    public var descText:FlxText;

    public var option(default, set):Int;

    @:noCompletion
    function set_option(_option:Int):Int
    {
        option = _option;

        for (i in 0 ... options.members.length)
        {
            var _option:BaseOptionItem = options.members[i];

            _option.alpha = option == i ? 1.0 : 0.5;

            var selectable:Bool = option == i;

            if (_option is BoolOptionItem)
                cast (_option, BoolOptionItem).selectable = selectable;

            if (_option is ControlOptionItem)
                cast (_option, ControlOptionItem).selectable = selectable;

            if (_option is IntOptionItem)
                cast(_option, IntOptionItem).selectable = selectable;
        }

        FlxTween.cancelTweensOf(descriptor);

        if (options.members[option] is HeaderOptionItem)
            FlxTween.tween(descriptor, {alpha: 0.5}, 0.5);
        else
            FlxTween.tween(descriptor, {alpha: 1.0}, 0.5);

        return option;
    }

    public var tune:FlxSound;

    public function new(_nextState:NextState):Void
    {
        super();

        nextState = _nextState;
    }

    override function create():Void
    {
        super.create();

        FlxG.mouse.visible = true;

        background = new FlxSprite(0.0, 0.0, Assets.getGraphic(Paths.png("assets/images/menus/OptionsMenu/background")));

        background.active = false;

        background.antialiasing = true;

        background.color = background.color.getDarkened(0.25);

        add(background);

        backdrop = new FlxBackdrop(Assets.getGraphic(Paths.png("assets/images/menus/OptionsMenu/backdrop")));

        backdrop.antialiasing = true;

        backdrop.alpha = 0.35;

        backdrop.color = backdrop.color.getDarkened(0.25);

        backdrop.velocity.set(15.0, 15.0);

        add(backdrop);

        gradient = new FlxSprite(Assets.getGraphic(Paths.png("assets/images/menus/OptionsMenu/gradient")));

        gradient.active = false;

        gradient.antialiasing = true;

        gradient.color = gradient.color.getDarkened(0.25);

        add(gradient);

        cornerCutout = new FlxSprite();

        cornerCutout.antialiasing = true;

        cornerCutout.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.png("assets/images/menus/OptionsMenu/cornerCutout")), Paths.xml("assets/images/menus/OptionsMenu/cornerCutout"));

        cornerCutout.animation.addByPrefix("cornerCutout", "cornerCutout", 12.0);

        cornerCutout.animation.play("cornerCutout");

        cornerCutout.scale.set(0.85, 0.85);

        cornerCutout.updateHitbox();

        cornerCutout.setPosition(-125.0, -65.0);

        add(cornerCutout);

        gear = new FlxSprite(Assets.getGraphic(Paths.png("assets/images/menus/OptionsMenu/gear")));

        gear.active = false;

        gear.antialiasing = true;

        gear.setPosition(-gear.width * 0.45, -gear.height * 0.45);

        add(gear);

        FlxTween.angle(gear, 0.0, 360.0, 10.0, {type: LOOPING});

        options = new FlxTypedSpriteGroup<BaseOptionItem>();

        add(options);

        addHeaderOption("Window");

        var bool:BoolOptionItem = addBoolOption("Auto Pause", "If checked, the game will freeze when window focus is lost.", "autoPause");

        bool.onUpdate.add((value:Bool) -> 
        {
            FlxG.autoPause = value;

            FlxG.console.autoPause = value;
        });

        var int:IntOptionItem = addIntOption("Frame Rate", "How often the game ticks each second.", "frameRate", 60, 244, 1);

        int.onUpdate.add((value:Int) ->
        {
            if (value > FlxG.updateFramerate)
            {
                FlxG.updateFramerate = value;

                FlxG.drawFramerate = value;
            }
            else
            {
                FlxG.drawFramerate = value;

                FlxG.updateFramerate = value;
            }
        });

        addHeaderOption("Asset Management");

        addBoolOption("GPU Caching", "If checked, bitmap pixel data is disposed from RAM\nwhere applicable (requires restarting the application).", "gpuCaching");

        addBoolOption("Sound Streaming", "If checked, audio is loaded progressively\nwhere applicable (requires restarting the application).", "soundStreaming");

        addBoolOption("Persistent Cache", "If unchecked, the graphic and sound caches will be\ninvalidated on scene switch.", "persistentCache");

        addHeaderOption("Controls");

        addControlOption("Left Note", "Controls for the first note in the strumline.", "NOTE:LEFT");

        addControlOption("Down Note", "Controls for the second note in the strumline.", "NOTE:DOWN");

        addControlOption("Up Note", "Controls for the third note in the strumline.", "NOTE:UP");

        addControlOption("Right Note", "Controls for the fourth note in the strumline.", "NOTE:RIGHT");

        addControlOption("Pause", "Controls associated with opening the pause menu.", "UI:PAUSE");

        addHeaderOption("Gameplay");

        addBoolOption("Downscroll", "If checked, flips the strumlines' vertical position.", "downscroll");

        addBoolOption("Middlescroll", "If checked, centers the playable strumline and\nhides the opponent's.", "middlescroll");

        addBoolOption("Ghost Tapping", "If unchecked, pressing an input with no notes\non screen will cause damage.", "ghostTapping");

        descriptor = new FlxSprite();

        descriptor.antialiasing = true;

        descriptor.color = descriptor.color.getDarkened(0.15);

        descriptor.frames = FlxAtlasFrames.fromSparrow(Assets.getGraphic(Paths.png("assets/images/menus/OptionsMenu/descriptor")), Paths.xml("assets/images/menus/OptionsMenu/descriptor"));

        descriptor.animation.addByPrefix("descriptor", "descriptor", 12.0);

        descriptor.animation.play("descriptor");

        descriptor.scale.set(0.85, 0.85);

        descriptor.setPosition(-150.0, 550.0);

        add(descriptor);

        descText = new FlxText(0.0, 0.0, descriptor.width, options.members[option].description, 28);

        descText.antialiasing = true;

        descText.color = FlxColor.BLACK;

        descText.font = Paths.ttf("assets/fonts/Ubuntu Regular");

        descText.alignment = CENTER;

        descText.setPosition(descriptor.getMidpoint().x - descText.width * 0.5, descriptor.getMidpoint().y - descText.height * 0.5 - 25.0);

        add(descText);

        option = 0;

        tune = FlxG.sound.load(Assets.getSound(Paths.ogg("assets/music/menus/OptionsMenu/tune")), 0.0, true);

        tune.fadeIn(1.0, 0.0, 1.0);

        tune.play();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.DOWN)
        {
            option = FlxMath.wrap(option + 1, 0, options.members.length - 1);

            var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

            scroll.onComplete = scroll.kill;
        }

        if (FlxG.keys.justPressed.UP)
        {
            option = FlxMath.wrap(option - 1, 0, options.members.length - 1);

            var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

            scroll.onComplete = scroll.kill;
        }

        if (FlxG.keys.justPressed.PAGEDOWN)
        {
            var _option:HeaderOptionItem = cast options.group.getFirst((__option:BaseOptionItem) -> Std.isOfType(__option, HeaderOptionItem) && options.members.indexOf(__option) > option);

            if (_option != null)
            {
                option = options.members.indexOf(_option);

                var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

                scroll.onComplete = scroll.kill;
            }
        }

        if (FlxG.keys.justPressed.PAGEUP)
        {
            var _option:HeaderOptionItem = cast options.group.getLast((__option:BaseOptionItem) -> Std.isOfType(__option, HeaderOptionItem) && options.members.indexOf(__option) < option);

            if (_option != null)
            {
                option = options.members.indexOf(_option);

                var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

                scroll.onComplete = scroll.kill;
            }
        }

        if (FlxG.keys.justPressed.END)
        {
            if (option != options.members.length - 1.0)
            {
                option = options.members.length - 1;

                var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

                scroll.onComplete = scroll.kill;
            }
        }

        if (FlxG.keys.justPressed.HOME)
        {
            if (option != 0.0)
            {
                option = 0;

                var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

                scroll.onComplete = scroll.kill;
            }
        }

        if (FlxG.mouse.wheel == -1.0)
        {
            option = FlxMath.wrap(option + 1, 0, options.members.length - 1);

            var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

            scroll.onComplete = scroll.kill;
        }

        if (FlxG.mouse.wheel == 1.0)
        {
            option = FlxMath.wrap(option - 1, 0, options.members.length - 1);

            var scroll:FlxSound = FlxG.sound.play(Assets.getSound(Paths.ogg("assets/sounds/menus/OptionsMenu/scroll"), false), 0.35);

            scroll.onComplete = scroll.kill;
        }

        if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.PAGEDOWN || FlxG.keys.justPressed.PAGEUP || FlxG.keys.justPressed.END || FlxG.keys.justPressed.HOME || FlxG.mouse.wheel != 0.0)
            descText.text = options.members[option].description;

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(nextState);

        var targetY:Float = 0.0;

        for (i in 0 ... option)
            targetY -= (i < options.members.length - 2.0 ? options.members[i].height : 0.0);

        options.y = FlxMath.lerp(options.y, targetY, FlxMath.getElapsedLerp(0.15, elapsed));
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.mouse.visible = false;
    }

    public function addBoolOption(title:String, description:String, option:String):BoolOptionItem
    {
        var newest:BaseOptionItem = options.members.newest();

        var bool:BoolOptionItem = new BoolOptionItem(0.0, 0.0, title, description, option);

        bool.setPosition(FlxG.width - bool.width + 75.0, newest == null ? 50.0 : newest.y + newest.height);

        options.add(bool);

        return bool;
    }

    public function addControlOption(title:String, description:String, option:String):ControlOptionItem
    {
        var newest:BaseOptionItem = options.members.newest();

        var control:ControlOptionItem = new ControlOptionItem(0.0, 0.0, title, description, option);

        control.setPosition(FlxG.width - control.width + 100.0, newest == null ? 50.0 : newest.y + newest.height);

        options.add(control);

        return control;
    }

    public function addHeaderOption(title:String):HeaderOptionItem
    {
        var newest:BaseOptionItem = options.members.newest();

        var header:HeaderOptionItem = new HeaderOptionItem(0.0, 0.0, title, "");

        header.setPosition(FlxG.width - header.width + 165.0, newest == null ? 50.0 : newest.y + newest.height);

        options.add(header);

        return header;
    }

    public function addIntOption(title:String, description:String, option:String, min:Int, max:Int, step:Int):IntOptionItem
    {
        var newest:BaseOptionItem = options.members.newest();

        var int:IntOptionItem = new IntOptionItem(0.0, 0.0, title, description, option, min, max, step);

        int.setPosition(FlxG.width - int.width + 125.0, newest == null ? 50.0 : newest.y + newest.height);

        options.add(int);

        return int;
    }
}