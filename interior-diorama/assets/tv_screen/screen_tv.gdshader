shader_type spatial;

uniform sampler2D screen_sampler;
uniform vec2 uv_scale = vec2(1.0);

void fragment() {
	
	vec2 deformed_uv = UV;
	deformed_uv.x += sin(UV.y * 3.14 * 20.0 + TIME) * 0.01;
	deformed_uv.x += sin(UV.y * 3.14 * 10.0 + TIME) * 0.02;
	
	float waves = (1.0 + sin(UV.y * 3.14 * 40.0 + TIME)) / 2.0;
	
	vec3 screen_color = texture(screen_sampler, deformed_uv).rgb;
	
	screen_color *= waves * 0.6 + 0.4;
	
	EMISSION = screen_color;
	ALBEDO = screen_color;
}
