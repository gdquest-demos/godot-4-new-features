shader_type canvas_item;

uniform float zoom = 1.0;
uniform float radius = 0.25;
uniform vec2 ratio = vec2(1.0, 1.0);
uniform vec2 texture_ratio = vec2(1.0, 1.0);

uniform vec3 gradient_color : source_color = vec3(1.0);
uniform float gradient_opacity = 0.0;

void fragment() {
	vec2 ratio_uv = UV * ratio;
	
	float d = length(max(abs(ratio_uv - vec2(0.5) * ratio) + radius - vec2(0.5) * ratio,0.0)) - radius;
	float mask = smoothstep(0.005, -0.0025, d);
	
	float normalized_zoom = (1.0 + 1.0 - zoom);
	COLOR.rgb = texture(TEXTURE, (UV - 0.5) * normalized_zoom * texture_ratio * ratio + 0.5).rgb;
	COLOR.rgb = mix(COLOR.rgb, gradient_color, step(-0.025, d) * gradient_opacity);
	COLOR.a *= mask;
}
