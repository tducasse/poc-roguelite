shader_type canvas_item;

uniform bool active = false;

void fragment() {
	vec4 previousColor = texture(TEXTURE, UV);
	vec4 whiteColor = vec4(1.0, 1.0, 1.0, previousColor.a);
	COLOR = active ? whiteColor : previousColor;
}