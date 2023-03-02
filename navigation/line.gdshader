shader_type spatial;
render_mode  cull_disabled;
uniform sampler2D arrow_sampler : filter_linear;
uniform vec2 ratio = vec2(1.0);

uniform vec3 base_color : source_color;
uniform vec3 wave_color : source_color;


void fragment() {
	
	float uv_y = 0.0;
	float cut = (1.0 / 3.0);
	float cut_half = cut / ratio.x;
	
	if(UV.y < cut_half){
		uv_y = UV.y * ratio.x;
	}else if(UV.y < 1.0 - cut_half){
		uv_y = UV.y * cut_half + cut;
	}else {
		uv_y = UV.y * ratio.x - (ratio.x - 1.0);
	}
	
	float wave = (sin(TIME + UV.y * 5.0 * ratio.x) + 1.0) / 2.0;
	ALBEDO.rgb = mix(base_color, wave_color, step(0.8, wave));
	ALPHA = texture(arrow_sampler, vec2(uv_y, UV.x * ratio.y)).x;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
