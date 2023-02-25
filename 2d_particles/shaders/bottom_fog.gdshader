shader_type canvas_item;

void fragment() {
	COLOR.a *= UV.y;
}
