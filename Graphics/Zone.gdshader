shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void fragment() {
	vec2 uv = UV;
	
    uv.y += sin(TIME)/10.0;
	uv.x -= cos(TIME)/10.0;
	COLOR = mix(texture(SCREEN_TEXTURE, uv, 1.0), vec4(0.224, 0.361, 0.596, 1.0), .9);
}
