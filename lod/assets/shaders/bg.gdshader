shader_type spatial;
render_mode unshaded;

uniform vec3 border_color : source_color = vec3(0.0);
uniform vec3 center_color : source_color = vec3(0.08);

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	ALBEDO = vec3(mix(center_color, border_color, distance(vec2(0.5), UV)));
}
