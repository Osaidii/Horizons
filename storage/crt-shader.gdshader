shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;



uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform bool disable;
uniform float curvature = 5.0;
uniform float blur = 0.25;
uniform float line_alpha = 0.1;
uniform float line_subtleness = 0.9;
uniform float vignette_multiplier = 2.0;
uniform float vignette_border = 6.0;
uniform float hori_res;
uniform float vert_res;

void fragment() {
	// Set Center and Warping
	vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
	vec2 uv_offset = centered_uv.yx / curvature;
	vec2 warped_uv = centered_uv + centered_uv * uv_offset * uv_offset;
	
	// Cutoff Wierd Textures
	vec3 cutoff = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0));
	
	// Add Scan Lines and Vignette
	vec3 scanlines = vec3(sin(2.0 * warped_uv.y * (vert_res / 5.0)) * line_alpha + line_subtleness);
	vec3 vignette = vec3(length(pow(abs(centered_uv), vec2(vignette_border)) / 3.0));
	
	// Display Shader on Screen
	vec3 screen_color = textureLod(screen_texture, (warped_uv + 1.0) / 2.0, blur).rgb * cutoff * scanlines;
	screen_color -= vignette * vignette_multiplier;
	if (disable == false)
		COLOR = vec4(screen_color, 1.0);
	else
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
}
