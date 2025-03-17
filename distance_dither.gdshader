shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform float distance_fade_min : hint_range(0.0, 4096.0, 0.01) = 4.0;
uniform float distance_fade_max : hint_range(0.0, 4096.0, 0.01) = 10.0;

uniform vec2 uv1_scale = vec2(1.0);
uniform vec2 uv1_offset = vec2(0.0);

global uniform float _time_step;

void vertex() {
	UV = UV * uv1_scale + uv1_offset;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo_tex.rgb;
	const vec3 magic = vec3(0.06711056, 0.00583715, 52.9829189);
	float fade_distance = length(VERTEX);
	float fade = clamp(smoothstep(distance_fade_min, distance_fade_max, fade_distance), 0.0, 1.0);
	float res = fract(magic.z * fract(dot(FRAGCOORD.xy, magic.xy * _time_step)));
	ALPHA = res;
	ALPHA_SCISSOR_THRESHOLD = max(1.0-fade, res);
}
