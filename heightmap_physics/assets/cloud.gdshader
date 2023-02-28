shader_type spatial;

uniform sampler2D noise_sampler;

void vertex(){
	float noise = texture(noise_sampler, VERTEX.xy + TIME * 0.05).x;
	VERTEX += (NORMAL * noise) * 0.05;
}

void fragment() {
	ALBEDO = vec3(0.2);
}
