package shaders;

import flixel.system.FlxAssets.FlxShader;

class Desaturation extends FlxShader
{
    @:glFragmentSource("
        #pragma header

        #define texture flixel_texture2D

        #define fragColor gl_FragColor

        vec2 uv = openfl_TextureCoordv.xy;

        void main()
        {
            vec4 color = texture(bitmap, uv);

            if (color.a == 0.0)
                fragColor = vec4(0.0, 0.0, 0.0, 0.0);
            else
            {
                color = vec4(color.rgb / color.a, color.a);

                fragColor = vec4(vec3(dot(color.rgb, vec3(0.299, 0.587, 0.114))) * color.a, color.a);
            }
        }
    ")
    public function new():Void
    {
        super();
    }
}