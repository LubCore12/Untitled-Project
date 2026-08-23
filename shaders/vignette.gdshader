shader_type canvas_item;

uniform float strength: hint_range(0.0, 1.0, .01);
uniform sampler2D vignette_texture;
uniform vec3 vignette_color: source_color;

void fragment() {
	vec2 uv = 2. * UV - 1.;
	vec4 vignette = texture(vignette_texture, UV);
	float circle_mask = length(uv);
	COLOR.rgb = vignette_color;
	COLOR.a = circle_mask - vignette.r - (1.1 - strength * 1.1);
}
