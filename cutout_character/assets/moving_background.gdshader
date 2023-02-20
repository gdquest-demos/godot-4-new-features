shader_type canvas_item;

uniform sampler2D pattern_sampler : repeat_enable, filter_linear_mipmap;
uniform vec3 bg_color : source_color;
uniform vec3 pattern_color : source_color;
uniform float scale = 2.0;
uniform float ratio = 1.0;

uniform vec2 direction = vec2(0.025);

void fragment() {
	vec2 offset = TIME * direction;
	COLOR.rgb = mix(pattern_color, bg_color, texture(pattern_sampler, UV * vec2(1.0, ratio) * scale + offset).x);
}
