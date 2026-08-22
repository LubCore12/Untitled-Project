shader_type canvas_item;

uniform float size: hint_range(0.0, 1.0, .01);

void fragment() {
	float ratio = dFdy(UV.y) / dFdx(UV.x);
	vec2 ratio_uv = vec2(mix(0.5, UV.x, ratio), UV.y);
	float circle = step(distance(vec2(0.5), ratio_uv), size * 1.05);
	COLOR.a = circle;
}
