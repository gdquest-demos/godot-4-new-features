shader_type canvas_item;

uniform vec3 wall_color : source_color;
uniform vec3 window_color : source_color;
uniform vec4 light_color : source_color;

void fragment() {
	vec3 atlas = texture(TEXTURE, UV).rgb;
	float lights = atlas.r;
	vec3 walls = mix(wall_color, window_color, clamp(atlas.r + atlas.g, 0.0, 1.0));
	COLOR.rgb = walls;
	COLOR.rgb += lights * light_color.rgb * light_color.a;
}
