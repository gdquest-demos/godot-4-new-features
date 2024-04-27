shader_type canvas_item;

uniform sampler2D noise_sampler : repeat_enable;
uniform sampler2D flame_gradient;
uniform float time_scale = 1.0;
uniform vec2 offset = vec2(0.0);

void fragment() {
	float n = texture(noise_sampler, (UV + vec2(0.0, TIME * time_scale)) * 0.35 + offset).x;
	float flame_shape = texture(TEXTURE, UV).a;
	COLOR.a = step(0.25, flame_shape * n * (UV.y * 1.25));
	COLOR.rgb = texture(flame_gradient, vec2(flame_shape * n, 0.0)).rgb;
}
