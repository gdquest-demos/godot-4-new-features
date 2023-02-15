shader_type spatial;
uniform sampler2D camera_sampler : filter_linear_mipmap;
void fragment() {

	vec3 camera_texture = texture(camera_sampler, UV).rgb;
	EMISSION.rgb = camera_texture;
}
