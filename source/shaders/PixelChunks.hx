package shaders;

import flixel.system.FlxAssets.FlxShader;

// Source: https://www.shadertoy.com/view/NtSXRm
class PixelChunks extends FlxShader
{
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
            
            vec2 tileVec = vec2(tileSize);

            vec2 edgePadding = mod(iResolution.xy * 0.5 - tileVec * 0.5, tileVec);

            vec2 tileIndex = ceil((fragCoord - edgePadding) / tileVec);

            fragColor = texture(iChannel0, (edgePadding + tileIndex * tileVec - tileVec * 0.5) / iResolution.xy);
        }
    ")
    public function new():Void
    {
        super();
    }
}