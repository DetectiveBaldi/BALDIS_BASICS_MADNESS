package shaders;

import openfl.filters.ColorMatrixFilter;

// We need to abstract over `ColorMatrixFilter` because we can't extend it.
@:forward()
abstract Desaturation(ColorMatrixFilter) to ColorMatrixFilter
{
    public function new():Void
    {
        this = new ColorMatrixFilter([0.299, 0.587, 0.114, 0.0, 0.0, 0.299, 0.587, 0.114, 0.0, 0.0, 0.299, 0.587, 0.114, 0.0,
            0.0, 0.0, 0.0, 0.0, 1.0, 0.0]);
    }   
}