shader_type canvas_item;

uniform vec4 custom_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
	COLOR = custom_color;
}