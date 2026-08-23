shader_type canvas_item;

uniform float value: hint_range(0.0, 1.0, .01);
uniform vec3 background_color: source_color;
uniform vec3 health_color: source_color;

void fragment() {
	float line_mask = step(distance(UV.x, 0.0), value);
	COLOR.rgb = mix(background_color, health_color, line_mask);
}
