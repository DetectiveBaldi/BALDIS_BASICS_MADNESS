package shaders;

import flixel.system.FlxAssets.FlxShader;

class PixelChunks extends FlxShader
{
    // https://www.shadertoy.com/view/NtSXRm
    
    @:glFragmentSource("
        #pragma header

        #define fragColor gl_FragColor

        #define texture flixel_texture2D

        #define iChannel0 bitmap

        uniform float tileSize;

        vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;

        vec2 iResolution = openfl_TextureSize;

        vec2 uv = openfl_TextureCoordv.xy;

        void main()
        {
            if (tileSize == 0.0)
            {
                fragColor = texture(bitmap, uv);

                return;
            }
            
            vec2 _tileSize = vec2(tileSize);

            vec2 edgePadding = mod(iResolution.xy * 0.5 - _tileSize * 0.5, _tileSize);

            vec2 tileIndex = ceil((fragCoord - edgePadding) / _tileSize);

            fragColor = texture(iChannel0, (edgePadding + tileIndex * _tileSize - _tileSize * 0.5) / iResolution.xy);
        }
    ")

    public function new():Void
    {
       super();
    }
}