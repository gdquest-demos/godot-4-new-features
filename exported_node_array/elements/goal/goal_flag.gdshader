shader_type spatial;
render_mode cull_disabled, shadows_disabled;

uniform vec3 albedo_color : source_color;

void vertex() {
	float g = VERTEX.x;
	VERTEX.z += sin((TIME * 2.0) - g * 2.0 * PI) * 0.2 * g;
}

void fragment() {
	ALBEDO = albedo_color;
}