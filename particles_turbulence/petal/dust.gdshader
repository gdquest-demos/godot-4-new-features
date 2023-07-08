shader_type spatial;

void fragment() {
	ALPHA = clamp(1.0 - distance(UV, vec2(0.5)) * 2.0, 0.0, 1.0);
 
	EMISSION = vec3(1.0) * 1.25;
}
