package funkin.game.shaders;

import flixel.system.FlxAssets.FlxShader;

class AdjustColor
{
	public var shader(default, null):AdjustColorShader = new AdjustColorShader();
	public var hue(default, set):Float = 0;
	public var saturation(default, set):Float = 0;
	public var brightness(default, set):Float = 0;
	public var contrast(default, set):Float = 0;
	
	private function set_hue(value:Float)
	{
		if (value == hue) return hue;
		
		hue = value;
		shader.u_hue.value[0] = hue;
		return hue;
	}
	
	private function set_saturation(value:Float)
	{
		if (value == saturation) return saturation;
		
		saturation = value;
		shader.u_saturation.value[0] = saturation;
		return saturation;
	}
	
	private function set_brightness(value:Float)
	{
		if (value == brightness) return brightness;
		
		brightness = value;
		shader.u_brightness.value[0] = brightness;
		return brightness;
	}

	private function set_contrast(value:Float)
	{
		if (value == contrast) return contrast;
		
		contrast = value;
		shader.u_contrast.value[0] = contrast;
		return contrast;
	}
	
	public function new()
	{
		shader.u_hue.value = [0];
		shader.u_saturation.value = [0];
		shader.u_brightness.value = [0];
		shader.u_contrast.value = [0];
	}
}

class AdjustColorShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		// this shader is a slighly edited recreation of the Animate/Flash "Adjust Color" filter,
		// which was kindly provided and written by Rozebud https://github.com/ThatRozebudDude ( thank u rozebud :) )
		// Adapted from Andrey-Postelzhuks shader found here: https://forum.unity.com/threads/hue-saturation-brightness-contrast-shader.260649/
		// Hue rotation stuff is from here: https://www.w3.org/TR/filter-effects/#feColorMatrixElement

		uniform float u_hue;
		uniform float u_saturation;
		uniform float u_brightness;
		uniform float u_contrast;

		const vec3 grayscaleValues = vec3(0.3098039215686275, 0.607843137254902, 0.0823529411764706);
		const float e = 2.718281828459045;

		vec3 applyHueRotate(vec3 aColor, float aHue){
			float angle = radians(aHue);

			mat3 m1 = mat3(0.213, 0.213, 0.213, 0.715, 0.715, 0.715, 0.072, 0.072, 0.072);
			mat3 m2 = mat3(0.787, -0.213, -0.213, -0.715, 0.285, -0.715, -0.072, -0.072, 0.928);
			mat3 m3 = mat3(-0.213, 0.143, -0.787, -0.715, 0.140, 0.715, 0.928, -0.283, 0.072);
			mat3 m = m1 + cos(angle) * m2 + sin(angle) * m3;

			return m * aColor;
		}

		vec3 applySaturation(vec3 aColor, float value){
			if(value > 0.0){ value = value * 3.0; }
			value = (1.0 + (value / 100.0));
			vec3 grayscale = vec3(dot(aColor, grayscaleValues));
			return clamp(mix(grayscale, aColor, value), 0.0, 1.0);
		}

		vec3 applyContrast(vec3 aColor, float value){
			value = (1.0 + (value / 100.0));
				if(value > 1.0){
					value = (((0.00852259 * pow(e, 4.76454 * (value - 1.0))) * 1.01) - 0.0086078159) * 10.0; //Just roll with it...
					value += 1.0;
				}
		return clamp((aColor - 0.25) * value + 0.25, 0.0, 1.0);
		}

		vec3 applyHSBCEffect(vec3 color){

			//Brightness
			color = color + ((u_brightness) / 255.0);

			//Hue
			color = applyHueRotate(color, u_hue);

			//Contrast
			color = applyContrast(color, u_contrast);

			//Saturation
		color = applySaturation(color, u_saturation);

		return color;
		}

		void main(){

			vec4 textureColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

			// Un-multiply alpha if the texture is premultiplied
		// Lime premultiplies alphas before sending it to render, so we want to accomodate header. This fixes some antialiased edges appearing darker
		vec3 unpremultipliedColor = textureColor.a > 0.0 ? textureColor.rgb / textureColor.a : textureColor.rgb;

			// Apply effects to the unpremultiplied color
			vec3 outColor = applyHSBCEffect(unpremultipliedColor);

			gl_FragColor = vec4(outColor * textureColor.a, textureColor.a);
		}')
	public function new()
	{
		super();
	}
}
