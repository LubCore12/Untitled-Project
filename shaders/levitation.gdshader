shader_type canvas_item;

uniform float strength: hint_range(2.0, 5.0, .01);
uniform float x_speed: hint_range(1.0, 3.0, .01);
uniform float y_speed: hint_range(1.0, 3.0, .01);

void vertex() {
	VERTEX.x += sin(TIME * x_speed) * strength;
	VERTEX.y += sin(TIME * y_speed) * strength;
}
