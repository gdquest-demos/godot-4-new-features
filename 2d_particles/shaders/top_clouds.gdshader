shader_type canvas_item;

uniform sampler2D noise_sampler : repeat_enable;
uniform sampler2D noise_small_sampler : repeat_enable;
uniform float base_scale = 0.2;

void fragment() {
	vec2 ratio_uv = UV * vec2(1.0, 0.2) * base_scale;
	float noise = texture(noise_sampler, ratio_uv + vec2(TIME * 0.01, 0.0)).x;
	float noise_small = texture(noise_small_sampler, ratio_uv + vec2(-TIME * 0.001, 0.0)).x;
	
	float n = (noise * noise_small);
	
	COLOR.a *= smoothstep(1.0, 0.995, n + UV.y);
}
