shader_type spatial;

uniform vec3 top_color : source_color;
uniform vec3 base_color : source_color;
varying float y;

void vertex(){
	y = NORMAL.y;
}

void fragment() {
	ALBEDO = mix(base_color, top_color, smoothstep(0.3,0.7, y));
}
