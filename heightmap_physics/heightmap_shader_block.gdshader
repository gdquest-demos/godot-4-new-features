shader_type spatial;

uniform sampler2D heightmap_texture;
uniform float height_ratio = 0.5;

uniform vec3 base_color : source_color;

void vertex() {
	vec4 texture_color = texture(heightmap_texture, UV);
	float grayscale = (texture_color.r + texture_color.g + texture_color.b)/3.0;
	 VERTEX.y += grayscale * height_ratio * COLOR.r * smoothstep(
	 	0.5, 0.0,
		distance(vec2(0.5), UV)
	);
}

void fragment(){
	ALBEDO = base_color;
	ALBEDO = NORMAL;
}