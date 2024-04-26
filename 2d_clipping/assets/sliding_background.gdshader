shader_type canvas_item;

uniform sampler2D pattern_sampler : repeat_enable, filter_linear_mipmap;
uniform vec3 bg_color : source_color;
uniform vec3 pattern_color : source_color;
uniform float pattern_size = 256.0;

void fragment() {
	vec2 uv = FRAGCOORD.xy / pattern_size;
	COLOR.rgb = mix(pattern_color, bg_color, texture(pattern_sampler, uv + TIME * 0.05).x);
}
