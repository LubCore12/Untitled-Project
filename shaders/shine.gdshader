shader_type canvas_item;

uniform float angle = -70.0;
uniform float x_pos = 1.8;
uniform float y_pos = 0.0;
uniform float thikness = 0.07;

void fragment() {
	vec2 uv = 2. * UV - 1.;
	
	float slope = tan(angle);
	float line = (uv.y + y_pos) - slope * (uv.x + x_pos);
	float distance_to_line = abs(line) / sqrt(1.0 + pow(slope, 2));
	float shine_mask = step(distance_to_line, thikness);
	COLOR.rgb = mix(COLOR.rgb, vec3(1.), shine_mask);
}
