package game.levels.baldiw;

import flixel.FlxG;
import flixel.FlxSprite;

import flixel.graphics.frames.FlxAtlasFrames;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;

import flixel.math.FlxMath;

import flixel.sound.FlxSound;

import flixel.text.FlxText;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import core.AssetCache;
import core.Options;
import core.Paths;

import data.AxisData;
import data.CharacterData;
import data.LevelData;

import game.events.SetCamFocusEvent;

import game.stages.baldiw.RevisionS;

import sound.SoundQueue;

using StringTools;

using util.ArrayUtil;
using util.MathUtil;
using util.PlayFieldTools;
using util.StringUtil;

class RevisionL extends PlayState
{
    public var revisionS:RevisionS;

    public var temperature:FlxSprite;

    public var quarter:FlxSprite;

    public var yctp:YCTPGroup;

    override function create():Void
    {
        stage = new RevisionS();

        revisionS = cast (stage, RevisionS);

        super.create();

        SetCamFocusEvent.dispatch(this, cameraPoint.getCenterX() - 300.0, cameraPoint.getCenterY(), null, 0.0, "linear");

        gameCamera.snapToTarget();

        cameraLock = FOCUS_CAM_POINT;

        gameCameraZoom = 1;

        temperature = new FlxSprite();

        gameCamera.color = 0xFF000000;
        temperature.color = 0xFF000000;

        playField.setVisible(false);

        playField.strumlines.visible = false;

        revisionS.entranceA2.visible = true;
        
        quarter = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/quarter"));
        quarter.active = false;
        quarter.scale.set(2, 2);
        quarter.setPosition(15.0, 350.0);
        revisionS.insert(revisionS.members.indexOf(opponents), quarter);

        tweens.tween(quarter, {y: quarter.y - 50}, conductor.beatLength * 4.0 * 0.001, 
            {
                ease: FlxEase.sineInOut, 
                type: PINGPONG
            }
        );

        var plr:Character = getPlayer("bf-face-back-left");
        plr.scale.set(4.5, 4.5);
        plr.updateHitbox();
        plr.setPosition(725.0, -30.0);

        var opp:Character = getOpponent("baldi-face-right");
        opp.scale.set(2.3, 2.3);
        opp.skipDance = true;
        opponents.setPosition(-70.0, 30.0);

        plrStrumline.botplay = true;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (yctp == null)
            return;

        @:privateAccess
        var musPath:String = AssetCache.getMusicPath(instrumental._sound);

        if (musPath.contains("Bad-Math"))
            return;

        if (yctp.loss)
        {
            var lastTime:Float = instrumental.time;

            instrumental.loadEmbedded(AssetCache.getMusic('${PlayState.level.getClassPath()}/Instrumental-Bad-Math'), 
                false, false, endSong);

            instrumental.play(lastTime);
        }
    }

    override function stepHit(step:Int):Void
    {
        super.stepHit(step);

        if (step == 0)
        {
            tweens.color(temperature, conductor.beatLength * 12.0 * 0.001, temperature.color, 0xFFFFFFFF,
                {onUpdate: (_tween:FlxTween) -> {gameCamera.color = temperature.color;}});
        }

        if (step == 128)
        {
            if (Options.flashingLights)
                hudCamera.flash(FlxColor.WHITE, conductor.beatLength * 4.0 * 0.001, null, true);

            SetCamFocusEvent.dispatch(this, cameraPoint.getCenterX() + 50.0, cameraPoint.getCenterY(), null, 0.0, "linear");

            gameCameraZoom = 0.7;

            playField.setVisible(true);

            playField.strumlines.visible = true;

            var opp:Character = getOpponent("baldi-face-right");
            opp.skipDance = false;

            plrStrumline.botplay = Options.botplay;
        }

        if (step == 664)
        {
            getTransitionSprite(conductor.beatLength * 2.0 * 0.001, OUT, null);
        }

        if (step == 672)
        {
            getTransitionSprite(conductor.beatLength * 2.0 * 0.001, IN, null);

            var oppStrumlineX:Float = oppStrumline.strums.x;

            var plrStrumlineX:Float = plrStrumline.strums.x;

            tweens.tween(oppStrumline.strums, {x: plrStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            tweens.tween(plrStrumline.strums, {x: oppStrumlineX}, conductor.beatLength * 2.0 * 0.001, {ease: FlxEase.quartOut});

            gameCameraZoom = 0.8;

            tweens.cancelTweensOf(this, ["gameCameraZoom"]);
            
            SetCamFocusEvent.dispatch(this, cameraPoint.getCenterX() + 100.0, cameraPoint.getCenterY() + 50.0, null,
                0.0, "linear");

            gameCamera.snapToTarget();

            revisionS.entranceA2.visible = false;
            revisionS.entranceA3.visible = true;

            quarter.kill();

            var plr:Character = getPlayer("bf-face-back-left");
            plr.visible = false;
        
            var opp:Character = getOpponent("baldi-face-right");
            opp.visible = false;

            var plr:Character = new Character(this, 0.0, 0.0, Character.getConfig("bf-face-right"));
            plr.scale.set(3.0, 3.0);
            plr.setPosition(0.0, 190.0);
            players.add(plr);
        
            var opp:Character = new Character(this, 0.0, 0.0, Character.getConfig("baldi-face-left"));
            opp.scale.set(3.2, 3.2);
            opp.setPosition(840.0, 45.0);
            opponents.add(opp);

            opponent = opp;

            updateHealthBar("opponent");
        }
    
        if (step == 1184)
        {
            playField.setVisible(false);

            playField.strumlines.visible = false;

            cameraPoint.centerTo();
            gameCamera.snapToTarget();

            gameCameraZoom = 1;
        
            revisionS.entranceA3.visible = false;

            var plr:Character = getPlayer("bf-face-right");
            plr.visible = false;

            var opp:Character = getOpponent("baldi-face-left");
            opp.visible = false;

            var padBack:FlxSprite = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/thinkpad-background"));

            padBack.active = false;

            padBack.scale.set(2.0, 2.0);

            padBack.updateHitbox();

            padBack.screenCenter();

            revisionS.insert(revisionS.members.indexOf(opponents), padBack);
    
            yctp = new YCTPGroup();

            yctp.screenCenter();

            add(yctp);

            getTransitionSprite(conductor.beatLength * 2.0 * 0.001, IN, null);
        }

        if (step == 1200.0 || step == 1328.0 || step == 1456.0 || step == 1584.0)
        {
            if (step != 1200.0)
                yctp.skipProblem();

            if (step != 1584.0)
                yctp.nextProblem(step == 1456.0);
        }

        if (step == 1216.0 || step == 1344.0 || step == 1536.0)
        {
            if (Options.botplay)
                yctp.checkSubmission();
        }
    }
}

class YCTPGroup extends FlxSpriteGroup
{
    public var keys:FlxKeyboard;

    public var baldi:FlxSprite;

    public var pad:FlxSprite;

    public var indicators:FlxSpriteGroup;

    public var buttonKeys:Map<String, FlxSprite>;

    public var buttons:FlxSpriteGroup;

    public var okButton:FlxSprite;

    public var sndQueue:SoundQueue;

    public var problemText:FlxText;

    public var questionText:FlxText;

    public var submission:String;

    public var submissionText:FlxText;

    public var problemIndex:Int;

    public var totalCorrect:Int;

    public var totalIncorrect:Int;

    public var totalSolved(get, never):Int;

    @:noCompletion
    function get_totalSolved():Int
        return totalCorrect + totalIncorrect;

    public var val1:Int;

    public var val2:Int;

    public var op1:String;

    public var op2:String;

    public var negative:Bool;

    public var corrupted:Bool;

    public var victory(get, never):Bool;

    @:noCompletion
    function get_victory():Bool
        return totalIncorrect == 0.0;

    public var loss(get, never):Bool;

    @:noCompletion
    function get_loss():Bool
        return totalIncorrect != 0.0;

    public var fail(get, never):Bool;
    
    @:noCompletion
    function get_fail():Bool
        return totalIncorrect == 3.0;

    public var victoryQuotes:Array<String>;

    public var lossQuotes:Array<String>;

    public var failQuotes:Array<String>;

    public var mouseVis:Bool;

    #if FLX_DEBUG
    public var debugToggleKeys:Array<FlxKey>;
    #end

    public function new(x:Float = 0.0, y:Float = 0.0):Void
    {
        super(x, y);

        FlxG.keys.enabled = false;

        keys = new FlxKeyboard();

        FlxG.inputs.addInput(keys);

        mouseVis = FlxG.mouse.visible;

        if (!Options.botplay)
        {
            FlxG.mouse.visible = true;

            FlxG.mouse.load(AssetCache.getGraphic("shared/cursor-default").bitmap);
        }

        #if FLX_DEBUG
        debugToggleKeys = FlxG.debugger.toggleKeys.copy();

        FlxG.debugger.toggleKeys = null;

        FlxG.debugger.visible = false;
        #end

        baldi = new FlxSprite();

        baldi.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("shared/baldi-thinkpad"), 
            Paths.image(Paths.xml("shared/baldi-thinkpad")));
        
        baldi.animation.addByPrefix("idle", "idle", 24.0, false);
        
        baldi.animation.addByPrefix("frown", "frown", 24.0, false);

        baldi.animation.addByPrefix("buzz", "line-buzz", 24.0, false);

        for (i in 1 ... 4)
            baldi.animation.addByPrefix('praise${i}', 'line-praise${i}', 24.0, false);

        baldi.animation.addByPrefix("problem", "line-problem", 24.0, false);

        baldi.animation.addByPrefix("divided", "line-divided", 24.0, false);

        baldi.animation.addByPrefix("minus-equals", "line-minus-equals", 24.0, false);

        baldi.animation.addByPrefix("zero", "line-zero", 24.0, false);

        baldi.animation.addByPrefix("seven", "line-seven", 24.0, false);

        baldi.animation.addByPrefix("symbol", "line-symbol", 24.0, false);
        
        baldi.scale.set(2.0, 2.0);

        baldi.updateHitbox();

        baldi.setPosition(185.0, 480.0);

        add(baldi);

        pad = new FlxSprite(0.0, 0.0, AssetCache.getGraphic("shared/thinkpad"));

        pad.active = false;

        pad.scale.set(2.0, 2.0);

        pad.updateHitbox();

        add(pad);

        indicators = new FlxSpriteGroup();

        add(indicators);

        var indicatorPos:Array<AxisData<Float>> =
        [
            {x: 195.0, y: 261.0},

            {x: 190.0, y: 334.0},
            
            {x: 190.0, y: 410.0}
        ];

        for (i in 0 ... 3)
        {
            var indicator:FlxSprite = new FlxSprite();

            indicator.active = false;

            indicator.visible = false;

            indicator.loadGraphic(AssetCache.getGraphic("shared/numpad-indicators"), true, 24, 24);

            indicator.animation.add("indicator", [0, 1], 0.0, false);

            indicator.animation.play("indicator");

            indicator.scale.set(2.0, 2.0);

            indicator.updateHitbox();

            var position:AxisData<Float> = indicatorPos[i];

            indicator.setPosition(position.x, position.y);

            indicators.add(indicator);
        }

        buttons = new FlxSpriteGroup();

        buttons.setPosition(pad.x + pad.width - 280.0, pad.y + 245.0);

        add(buttons);

        var buttonOrder:Array<String> = ["seven", "eight", "nine", "four", "five", "six", "one", "two", "three",
            "clear", "zero", "minus"];

        for (i in 0 ... buttonOrder.length)
        {
            var button:FlxSprite = new FlxSprite();

            button.active = false;

            button.frames = FlxAtlasFrames.fromSparrow(AssetCache.getGraphic("shared/numpad-button-sheet"), 
                Paths.image(Paths.xml("shared/numpad-button-sheet")));

            var name:String = buttonOrder[i];

            var deselectedAnim:String = '${name}-deselected';

            var selectedAnim:String = '${name}-selected';

            button.animation.addByPrefix(deselectedAnim, deselectedAnim, 0.0, false);

            button.animation.addByPrefix(selectedAnim, selectedAnim, 0.0, false);

            button.animation.play(deselectedAnim);

            button.scale.set(2.0, 2.0);

            button.updateHitbox();

            button.setPosition(button.width + 65.0 * (i % 3.0), 65.0 * (Std.int(i / 3.0)));

            buttons.add(button);
        }

        okButton = new FlxSprite();

        okButton.loadGraphic(AssetCache.getGraphic("shared/numpad-ok-button"), true, 64, 64);

        okButton.animation.add("ok-deselected", [0], 0.0, false);

        okButton.animation.add("ok-selected", [1], 0.0, false);

        okButton.animation.play("ok-deselected");

        okButton.scale.set(2.0, 2.0);

        okButton.updateHitbox();

        okButton.setPosition(buttons.width * 0.5, buttons.height + 2.0);

        buttons.add(okButton);

        sndQueue = new SoundQueue();

        sndQueue.onUpdate.add((sound:FlxSound) ->
        {
            @:privateAccess
            var sndPath:String = AssetCache.getSoundPath(sound._sound);
            
            sndPath = sndPath.substring(0, sndPath.length - 4);

            if (sndPath.contains("Buzz"))
            {
                baldi.animation.play("buzz", true);

                return;
            }

            if (sndPath.contains("Praise"))
            {
                var splt:String = sndPath.split("_").last();

                baldi.animation.play(splt.toLowerCase(), true);

                return;
            }

            if (sndPath.contains("Problem"))
            {
                baldi.animation.play("problem", true);

                return;
            }

            if (sndPath.contains("Divided"))
            {
                baldi.animation.play("divided", true);

                return;
            }

            if (sndPath.contains("Minus") || sndPath.contains("Equals"))
            {
                baldi.animation.play("minus-equals", true);

                return;
            }

            if (sndPath.contains("0"))
            {
                baldi.animation.play("zero", true);

                return;
            }

            if (sndPath.contains("7"))
            {
                baldi.animation.play("seven", true);

                return;
            }

            baldi.animation.play("symbol", true);
        });

        problemText = new FlxText(0.0, 0.0, 360.0, "");

        problemText.color = FlxColor.BLACK;

        problemText.size = 36;

        problemText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        problemText.alignment = LEFT;

        problemText.setPosition(300.0, 260.0);

        add(problemText);

        questionText = new FlxText(0.0, 0.0, 360.0, "");

        questionText.color = FlxColor.BLACK;

        questionText.size = 36;

        questionText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        questionText.alignment = LEFT;

        questionText.setPosition(300.0, 360.0);

        add(questionText);

        submission = "";

        submissionText = new FlxText(0.0, 0.0, 360.0, "");

        submissionText.color = FlxColor.BLACK;

        submissionText.size = 42;

        submissionText.font = Paths.font(Paths.ttf("Comic Sans MS"));

        submissionText.alignment = LEFT;

        submissionText.setPosition(375.0, 515.0);

        add(submissionText);

        problemIndex = 0;

        totalCorrect = 0;

        totalIncorrect = 0;

        negative = false;

        corrupted = false;

        victoryQuotes = ["WOW! YOU EXIST!"];

        lossQuotes = ["I HEAR EVERY DOOR YOU OPEN", "I GET ANGRIER FOR EVERY PROBLEM YOU GET WRONG"];

        failQuotes = ["I HEAR MATH THAT BAD"];
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        var firstJustPressed:Int = keys.firstJustPressed();

        if (Options.botplay)
            firstJustPressed = -1;

        switch (firstJustPressed:Int)
        {
            case FlxKey.BACKSPACE:
            {
                if (submission.length > 0.0)
                    submission = submission.substring(0, submission.length - 1);
                else
                    negative = false;

                updateSubmissionText();
            }

            case FlxKey.MINUS:
                updateSubmission(-1);
            
            case FlxKey.ENTER:
            {
                if (submission != "" || negative)
                    checkSubmission();
            }

            default:
            {
                var keyStr:String = FlxKey.toStringMap[firstJustPressed];

                var keyInt:Null<Int> = keyStr.parseInt();

                if (keyInt != null)
                    updateSubmission(keyInt);
            }
        }

        for (i in 0 ... buttons.members.length)
        {
            var button:FlxSprite = buttons.members[i];

            var name:String = button.animation.name.split("-").first();

            if (FlxG.mouse.overlaps(button))
            {
                if (Options.botplay)
                    continue;

                if ((FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight))
                {
                    switch (name:String)
                    {
                        case "clear":
                        {
                            submission = "";

                            negative = false;

                            updateSubmissionText();
                        }

                        case "minus":
                            updateSubmission(-1);
                        
                        case "ok":
                        {
                            if (submission != "" || negative)
                                checkSubmission();
                        }
                        
                        default:
                            updateSubmission(name.toLowerCase().parseInt());
                    }
                }
                
                button.animation.play('${name}-selected');
            }
            else
                button.animation.play('${name}-deselected');
        }
    }

    override function destroy():Void
    {
        super.destroy();

        FlxG.keys.enabled = true;

        FlxG.inputs.remove(keys);

        keys.destroy();

        sndQueue.destroy();

        FlxG.mouse.visible = mouseVis;

        #if FLX_DEBUG
        FlxG.debugger.toggleKeys = debugToggleKeys;

        debugToggleKeys = null;
        #end
    }

    public function nextProblem(corrupt:Bool):Void
    {
        problemIndex += 1;

        corrupted = corrupt;

        problemText.text = 'Solve Math Q${problemIndex}';

        var ops:Array<String> = ["+", "-"];

        if (corrupt)
        {
            ops.push("*");

            val1 = FlxG.random.int(1000000000, FlxMath.MAX_VALUE_INT);

            val2 = FlxG.random.int(1000000000, FlxMath.MAX_VALUE_INT);

            op1 = FlxG.random.getObject(ops);

            op2 = FlxG.random.getObject(ops);

            questionText.text = "" + val1 + "" + op1 + "" + val2 + "" + op2 + "" +
                Date.now().toString() + "" + FlxG.random.int(1000000000, FlxMath.MAX_VALUE_INT) + "=?";

            @:privateAccess
            {
                questionText._defaultFormat.leading = -48;

                questionText.updateDefaultFormat();
            }
        }
        else
        {
            val1 = FlxG.random.int(0, 9);

            val2 = FlxG.random.int(0, 9);

            op1 = FlxG.random.getObject(ops);

            questionText.text = '${val1}${op1}${val2}=?';
        }

        if (totalCorrect == totalSolved)
        {
            sndQueue.queue(FlxG.sound.load(AssetCache.getSound('shared/BAL_Problem${problemIndex}')));

            if (corrupt)
            {
                sndQueue.queue(FlxG.sound.load(AssetCache.getSound("shared/BAL_Buzz")));

                sndQueue.queue(FlxG.sound.load(AssetCache.getSound('shared/BAL_${lengthenOp(op1)}Short')));

                sndQueue.queue(FlxG.sound.load(AssetCache.getSound("shared/BAL_Buzz")));

                sndQueue.queue(FlxG.sound.load(AssetCache.getSound('shared/BAL_${lengthenOp(op2)}Short')));

                sndQueue.queue(FlxG.sound.load(AssetCache.getSound("shared/BAL_Buzz")));
            }
            else
            {
                sndQueue.queue(FlxG.sound.load(AssetCache.getSound('shared/BAL_${val1}')));

                sndQueue.queue(FlxG.sound.load(AssetCache.getSound('shared/BAL_${lengthenOp(op1)}')));

                sndQueue.queue(FlxG.sound.load(AssetCache.getSound('shared/BAL_${val2}')));
            }

            sndQueue.queue(FlxG.sound.load(AssetCache.getSound('shared/BAL_Equals')));
        }
    }

    public function skipProblem():Void
    {
        sndQueue.clearQueue(true);

        clearSubmission();

        if (problemIndex == totalSolved)
            return;

        if (baldi.animation.name != "frown")
            baldi.animation.play("frown");

        updateIndicator(false);

        totalIncorrect++;

        if (corrupted)
            showQuote();
    }

    public function updateSubmission(num:Int):Void
    {
        if (num >= 0.0)
        {
            if (submission.length < 9.0)
                submission += Std.string(num);

            updateSubmissionText();
        }
        else
        {
            negative = !negative;

            updateSubmissionText();
        }
    }

    public function updateSubmissionText():Void
    {
        if (negative)
            submissionText.text = '-${submission}';
        else
            submissionText.text = submission;
    }

    public function checkSubmission():Void
    {
        if (problemIndex == totalSolved)
            return;

        if ( #if debug true #else !PlayState.isWeek #end && submission == "31718")
        {
            PlayState.loadLevel(LevelData.list.first((lv:LevelData) -> lv.name == "Beginnings"));

            baldi.animation.play("idle");

            updateIndicator(false);

            sndQueue.clearQueue(true);

            problemText.text = "THIS IS WHERE IT ALL BEGAN";

            questionText.text = "";

            clearSubmission();

            return;
        }

        questionText.text = '${val1}${op1}${val2}';

        var numSubmission:Null<Int> = submission.parseInt();

        var multiplier:Int = 1;

        if (negative)
            multiplier *= -1;

        var answer:Int = switch (op1:String)
        {
            case "+":
                val1 + val2;
            
            case "-":
                val1 - val2;

            case "*":
                val1 * val2;
            
            case "/":
                Math.floor(val1 / val2);

            default:
                throw "Unrecognized pattern.";
        }

        var numToCheck:Null<Float> = numSubmission * multiplier;

        var answerValidated:Bool = numToCheck != null && numToCheck == answer;

        if (Options.botplay && problemIndex != 3.0)
            answerValidated = true;
        
        if (answerValidated)
        {
            questionText.text += '=${answer}';

            totalCorrect++;

            if (totalCorrect == totalSolved)
            {
                sndQueue.clearQueue(true);

                sndQueue.queue(FlxG.sound.load(AssetCache.getSound("shared/BAL_Praise" + FlxG.random.int(1, 3))));
            }

            updateIndicator();
        }
        else
        {
            questionText.text += '≠${negative ? "-" : ""}${submission}';

            if (baldi.animation.name != "frown")
                baldi.animation.play("frown");

            sndQueue.clearQueue(true);

            totalIncorrect++;

            updateIndicator(false);
        }

        if (corrupted)
            showQuote();

        clearSubmission();
    }

    public function clearSubmission():Void
    {
        val1 = 0;

        val2 = 0;

        op1 = "";

        op2 = "";

        negative = false;

        submission = "";

        updateSubmissionText();
    }

    public function showQuote():Void
    {
        problemText.text = FlxG.random.getObject(victory ? victoryQuotes : fail ? failQuotes : lossQuotes);

        problemText.size = 32;

        questionText.text = "";
    }

    public function getButton(name:String):FlxSprite
    {
        return buttons.members.first((button:FlxSprite) -> button.animation.name.startsWith(name));
    }

    public function updateIndicator(correct:Bool = true):Void
    {
        var indicator:FlxSprite = indicators.members[problemIndex - 1];

        indicator.visible = true;

        indicator.animation.curAnim.curFrame = correct ? 0 : 1;
    }

    public function lengthenOp(op:String):String
    {
        return switch (op:String)
        {
            case "+": "Plus";
            
            case "-": "Minus";
            
            case "*": "Times";
            
            case "/": "Divided";

            default:
                throw "Unrecognized pattern.";
        }
    }
}