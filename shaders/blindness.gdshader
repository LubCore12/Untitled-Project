shader_type canvas_item;

uniform sampler2D blindness_texture;

void fragment() {
	vec4 blindness = texture(blindness_texture, UV);
	COLOR.a = blindness.r + 0.15;
	COLOR.rgb = vec3(0);
}
