shader_type canvas_item;
render_mode unshaded;

uniform vec4 shadow_color : source_color;
uniform float shadow_angle : hint_range(0, 360);
uniform float shadow_length : hint_range(0, 1000) = 300;
uniform float fade_margin : hint_range(0, 100) = 5;

void fragment() {
	
	float angle_radians = shadow_angle * 3.1416 / 360.0;
	vec2 shadow_direction = vec2(sin(angle_radians), cos(angle_radians));
	vec2 screen_position_sdf = screen_uv_to_sdf(SCREEN_UV);

	float amount = 0.0;
	while(amount < shadow_length) {
	    float distance = texture_sdf(screen_position_sdf);
	    amount += distance;
	    if (distance < 0.01) {
	        break;
	    }
	    screen_position_sdf += distance * shadow_direction;
	}

	float alpha = 1.0 - min(1.0, amount / shadow_length);
	if (amount < fade_margin) {
		alpha *= max(0.0, amount / fade_margin);
	}
	
	COLOR = vec4(shadow_color.rgb, alpha * shadow_color.a);
}
