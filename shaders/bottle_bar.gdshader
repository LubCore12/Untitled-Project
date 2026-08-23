shader_type canvas_item;

uniform float value: hint_range(0.0, 1.0, .01);
uniform vec3 background_color: source_color;
uniform vec3 health_color: source_color;

void fragment() {
	vec2 uv = 2. * UV - 1.;
	float circle_mask = step(length(uv), 1.);
	float health_mask = step(distance(1., UV.y), value);
	
	float main_wave = sin((UV.x + TIME * 1.) * 10.) * 0.03 * cos(TIME * 2.) + (1. - value);
	main_wave = step(main_wave, UV.y);
	
	COLOR.rgb = mix(background_color, health_color, main_wave);
	COLOR.a = circle_mask;
}
