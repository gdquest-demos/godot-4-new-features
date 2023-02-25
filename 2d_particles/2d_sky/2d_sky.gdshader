shader_type canvas_item;

uniform vec3 top_color : source_color;
uniform vec3 bottom_color : source_color;

uniform float seed = 0.0;
uniform float chance = 0.95;
uniform float base_scale = 40.0;
uniform float star_count = 40.0;

// Credits: Random and Rotate method from godotshaders.com
// https://godotshaders.com/snippet/rotate/

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

vec4 get_stars(vec2 coord, vec2 offset, float base_seed){
	vec2 frag_coord_offset = coord + offset;
	
	vec2 pos = fract(1.0 / star_count * frag_coord_offset);
	float cell_id = random(round(1.0 / star_count * frag_coord_offset + 0.5) + base_seed);
	
	float stars_mask = 0.0;
	vec3 stars_color = vec3(0.0);
	
	if(cell_id > chance){
		float clamped_id = (map(cell_id, chance, 1.0, 0.0, 1.0));
		stars_color = vec3(1.0);
		
		pos.x += sin(clamped_id * 10.0) * 0.1;
		pos.y += cos(clamped_id * 15.0) * 0.1;
		
		float scale = base_scale + (sin(clamped_id * 40.0 + TIME * 2.0) * 0.15);
		vec2 scaled_pos = (pos - 0.5) * scale + 0.5;
		float star_id = floor(clamped_id * 3.0);
		vec2 star_uv = (scaled_pos + vec2(star_id, 0.0)) / vec2(3.0, 1.0);
		// stars_mask = texture(star_tile_sampler, star_uv).x;
		stars_mask = smoothstep(1.0, 0.0, distance(vec2(0.5), scaled_pos));
	}
	return vec4(stars_color, stars_mask);
}

void fragment() {
	vec4 stars_1 = get_stars(FRAGCOORD.xy, vec2(0.0), seed);
	vec3 sky_color = mix(top_color, bottom_color, UV.y);
	COLOR.rgb = sky_color + stars_1.a;
}
