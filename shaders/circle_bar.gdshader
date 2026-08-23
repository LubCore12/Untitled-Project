shader_type canvas_item;

uniform float circle_width: hint_range(0.0, 1.0, .01);
uniform float value: hint_range(0.0, 1.0, .01);
uniform vec3 background_color: source_color;
uniform vec3 health_color: source_color;

void fragment() {
	vec2 uv = 2. * UV - 1.;
	float circle_mask = step(length(uv), 1.) - step(length(uv), 1. - circle_width);
	float health_mask = step(atan(-uv.x, uv.y) + PI, value * TAU);
	COLOR.rgb = mix(background_color, health_color, health_mask);
	COLOR.a = circle_mask;
}
