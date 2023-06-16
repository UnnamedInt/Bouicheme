shader_type canvas_item;

uniform float saturation: hint_range(0.0, 1.0, 0.1);
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void fragment() {
    vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	float dist = texture_sdf(screen_uv_to_sdf(SCREEN_UV));
	
	if (dist > 0.0) {
		COLOR.rgb = mix(vec3(dot(tex_color.rgb, vec3(0.299, 0.587, 0.114))), tex_color.rgb, saturation);
		COLOR.a = tex_color.a;
	} else {
		vec2 uv = UV;
	
	    uv.y += sin(TIME*1.5)/100.0;
		uv.x -= cos(TIME*1.5)/100.0;
		COLOR = mix(texture(SCREEN_TEXTURE, uv, 1.0), vec4(0.224, 0.361, 0.596, 1.0), .5);
	}
}