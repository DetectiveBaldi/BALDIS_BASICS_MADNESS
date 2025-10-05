package group;

import openfl.display.BlendMode;

import flixel.FlxCamera;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.math.FlxMath;
import flixel.math.FlxRect;

import flixel.util.FlxDirectionFlags;

typedef BubbledSpriteGroup = BubbledTypedSpriteGroup<FlxSprite>;

class BubbledTypedSpriteGroup<T:FlxSprite> extends FlxTypedSpriteGroup<T>
{
	override function set_visible(val:Bool):Bool
	{
		if (visible != val)
			forceTransformChildren(visibleTransform, val);

		return super.set_visible(val);
	}

	override function set_active(val:Bool):Bool
	{
		if (active != val)
			forceTransformChildren(activeTransform, val);

		return super.set_active(val);
	}

	override function set_alive(val:Bool):Bool
	{
		if (alive != val)
			forceTransformChildren(aliveTransform, val);

		return super.set_alive(val);
	}

	override function set_x(val:Float):Float
	{
		if (x != val)
			forceTransformChildren(xTransform, val - x);

		return x = val;
	}

	override function set_y(val:Float):Float
	{
		if (y != val)
			forceTransformChildren(yTransform, val - y);

		return y = val;
	}

	override function set_angle(val:Float):Float
	{
		if (angle != val)
			forceTransformChildren(angleTransform, val - angle);

		return angle = val;
	}

	override function set_alpha(val:Float):Float
	{
		val = FlxMath.bound(val, 0.0, 1.0);

		if (alpha != val)
		{
			if (!directAlpha && alpha != 0.0)
				forceTransformChildren(alphaTransform, (alpha > 0.0) ? val / alpha : 0.0);
			else
				forceTransformChildren(directAlphaTransform, val);
		}

		return alpha = val;
	}

	override function set_facing(val:FlxDirectionFlags):FlxDirectionFlags
	{
		if (facing != val)
			forceTransformChildren(facingTransform, val);

		return facing = val;
	}

	override function set_flipX(val:Bool):Bool
	{
		if (flipX != val)
			forceTransformChildren(flipXTransform, val);

		return flipX = val;
	}

	override function set_flipY(val:Bool):Bool
	{
		if (flipY != val)
			forceTransformChildren(flipYTransform, val);

		return flipY = val;
	}

	override function set_moves(val:Bool):Bool
	{
		if (moves != val)
			forceTransformChildren(movesTransform, val);

		return moves = val;
	}

	override function set_immovable(val:Bool):Bool
	{
		if (immovable != val)
			forceTransformChildren(immovableTransform, val);

		return immovable = val;
	}

	override function set_solid(val:Bool):Bool
	{
		if (solid != val)
			forceTransformChildren(solidTransform, val);

		return super.set_solid(val);
	}

	override function set_color(val:Int):Int
	{
		if (color != val)
			forceTransformChildren(gColorTransform, val);

		return color = val;
	}

	override function set_blend(val:BlendMode):BlendMode
	{
		if (blend != val)
			forceTransformChildren(blendTransform, val);
		return blend = val;
	}

	override function set_clipRect(rect:FlxRect):FlxRect
	{
		if (exists)
			forceTransformChildren(clipRectTransform, rect);

		return super.set_clipRect(rect);
	}

	override function set_pixelPerfectRender(val:Bool):Bool
	{
		if (pixelPerfectRender != val)
			forceTransformChildren(pixelPerfectTransform, val);

		return super.set_pixelPerfectRender(val);
	}

	override function setPosition(newX:Float = 0.0, newY:Float = 0.0):Void
	{
		var deltaX:Float = newX - x;

		var deltaY:Float = newY - y;

		forceMultiTransformChildren([xTransform, yTransform], [deltaX, deltaY]);

		_skipTransformChildren = true;

		x = newX;

		y = newY;

		_skipTransformChildren = false;
	}

	// Bubbles down information to members and fixes type mismatches.
	@:generic
	public function forceTransformChildren<V>(func:T->V->Void, val:V):Void
	{
		if (_skipTransformChildren || group == null)
			return;

		for (i in 0 ... members.length)
		{
			var sprite:FlxSprite = members[i];

			if (sprite != null)
				func(cast sprite, val);
		}
	}

	// Bubbles down information to members regardless of their `exists` property.
	@:generic
	public function forceMultiTransformChildren<V>(funcs:Array<T->V->Void>, vals:Array<V>):Void
	{
		if (_skipTransformChildren || group == null)
			return;

		if (funcs.length > vals.length)
			return;

		for (i in 0 ... members.length)
		{
			var sprite:T = members[i];

			if (sprite != null)
			{
				for (j in 0 ... funcs.length)
				{
					var func:T->V->Void = funcs[j];

					var val:V = vals[j];

					func(sprite, val);
				}
			}
		}
	}
}