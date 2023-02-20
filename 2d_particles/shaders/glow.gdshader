shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float czm_luminance(vec3 rgb)
{
    // Algorithm from Chapter 10 of Graphics Shaders.
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    return dot(rgb, W);
}

vec3 get_glow(sampler2D text, vec2 uv){
	return max(textureLod(text, uv, 2.0).rgb - 0.1, vec3(0.0));
}

void fragment() {
	vec2 pixel_size = SCREEN_PIXEL_SIZE;
	vec3 color_screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	
	vec3 glow_x_right = get_glow(SCREEN_TEXTURE, SCREEN_UV + vec2(pixel_size.x, 0.0));
	vec3 glow_x_left = get_glow(SCREEN_TEXTURE, SCREEN_UV + vec2(-pixel_size.x, 0.0));
	vec3 glow_y_top = get_glow(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -pixel_size.x));
	vec3 glow_y_bottom = get_glow(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, pixel_size.x));
	
	vec3 final_glow = (glow_x_right + glow_x_left + glow_y_top + glow_y_bottom) * 0.25;
	
	float lum = czm_luminance(color_screen);
	COLOR.rgb = color_screen + (final_glow * lum * 0.8);
}
