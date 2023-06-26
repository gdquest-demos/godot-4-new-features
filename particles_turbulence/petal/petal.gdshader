shader_type spatial;
render_mode cull_disabled;

uniform sampler2D albedo_sampler : source_color, filter_linear_mipmap;
uniform sampler2D normal_sampler : hint_normal, filter_linear_mipmap;

uniform sampler2D color_gradient : source_color, repeat_enable;
uniform sampler2D shine_gradient : repeat_enable;
varying vec4 c;

void vertex() {
	float r = TIME * 4.0 + INSTANCE_CUSTOM.x * COLOR.x;
	VERTEX = mat3(
		vec3(0.0, 1.0, 0.0),
		vec3(cos(r), 0.0, sin(r)),
		vec3(-sin(r), 0.0, cos(r))
	) * VERTEX;
	c = INSTANCE_CUSTOM;
}

void fragment() {
	vec4 albedo = texture(albedo_sampler, UV);
	ALBEDO = albedo.rgb * texture(color_gradient, vec2(c.z, 0.0)).rgb;
	ALPHA = albedo.a;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
	NORMAL_MAP = texture(normal_sampler, UV).xyz;	
	ROUGHNESS = 0.8;
	SPECULAR = 0.25;
	float v = texture(shine_gradient, vec2(c.y + TIME * 0.01, 0.0)).x;
	EMISSION = ALBEDO * v * 1.5;
}
