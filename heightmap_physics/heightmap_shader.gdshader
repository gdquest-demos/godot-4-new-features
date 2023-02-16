shader_type spatial;

uniform sampler2D heightmap_texture;
uniform float height_ratio = 5.0;

void vertex() {
	vec4 texture_color = texture(heightmap_texture, UV);
	float grayscale = (texture_color.r + texture_color.g + texture_color.b)/3.0;
	VERTEX.y += grayscale * height_ratio;
}