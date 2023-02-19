shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec4 start_color : source_color;
uniform vec4 end_color : source_color;
uniform float zoom = 1.0;
uniform float blur_amount = 0.0;
uniform float alpha_blend = 0.0;

void fragment() {
	float normalized_zoom = (1.0 + 1.0 - zoom);
	
	vec3 screen_color = textureLod(SCREEN_TEXTURE, (SCREEN_UV - 0.5) * normalized_zoom + 0.5, blur_amount).rgb;
	vec3 gradient = mix(start_color.rgb, end_color.rgb, UV.y);
	float gradient_value = mix(start_color.a, end_color.a, UV.y);
	
	COLOR.rgb = mix(screen_color, gradient, gradient_value * alpha_blend);
}
