shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float brightness : hint_range(0.0, 3.0) = 1.2; // Controls brightness
uniform float alpha : hint_range(0.0, 1.0) = 0.5; // Transparency level

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Apply brightness adjustment
    tex_color.rgb *= brightness;
    
    // Apply transparency
    tex_color.a *= alpha;

    // Sample the screen texture
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Multiply Blend Mode: Multiply texture with background color
    COLOR = tex_color * screen_color;
}