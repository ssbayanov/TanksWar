 shader_type canvas_item;

uniform bool grayscale = false;
uniform bool coldscale = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	if (grayscale) { 
		COLOR.rbg = vec3(dot(COLOR.rgb, vec3(0.299, 0.587, 0.114)));
	}
}