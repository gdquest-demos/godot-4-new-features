shader_type canvas_item;

uniform sampler2D normal_map : hint_normal;
uniform vec3 color : source_color;

void fragment() {
    COLOR.a = texture(TEXTURE, UV).a;
	COLOR.rgb = color;
    NORMAL_MAP += texture(normal_map, UV).rgb;
}