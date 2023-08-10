shader_type canvas_item;

uniform float FloatParameter : hint_range(0, 5);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;



void fragment() {


	vec4 n_out2p0;
// Texture2D:2
	n_out2p0 = textureLod(SCREEN_TEXTURE, SCREEN_UV, FloatParameter);


// Output:0
	COLOR = n_out2p0;


}
