// Apply to a fullscreen ColorRect
// in a CanvasLayer above all other layers
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform int scanline_count = 90;
uniform float scanline_strength = 0.1;

uniform float aberration_amount = 0.2;
// Values used are very sensitive, so a small mult is required
uniform float aberration_mult = 0.002;

uniform float vignette_size = 0.3;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.4;
uniform float vignette_mult = 15.0;

uniform float noise_intensity = 0.025;

uniform float glow_strength = 1.0;
uniform int glow_radius: hint_range(0, 10) = 1;
uniform float glow_threshold: hint_range(0.0, 1.0) = 0.4;

vec3 desaturate (vec3 color){
	return vec3((color.r + color.g + color.b) / 3.0);
}

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

// Adds a vignette to the edges of the image
float vignette(vec2 uv){
	uv *= 1.0 - uv.xy;
	float vignette = uv.x * uv.y * vignette_mult;
	return pow(vignette, vignette_size * vignette_opacity);
}

void fragment() {
	// Base color
	vec3 col = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	
	// Chromatic aberration
	// Multiplier used because the values are very sensitive
	col.r = texture(screen_texture, SCREEN_UV + vec2(aberration_amount, 0.0) * aberration_mult).r;
	col.g = texture(screen_texture, SCREEN_UV - vec2(aberration_amount, 0.0) * aberration_mult).g;
	col.b = texture(screen_texture, SCREEN_UV).b;
	
	// Scanlines
	float y_step = 1.0 / float(scanline_count);
	if (mod(UV.y, y_step) < y_step / 2.0) {
		col = mix(col, vec3(0.0), scanline_strength);
	}
	
	// Vignette
	col.rgb *= vignette(SCREEN_UV);
	
	// Noise
	if (noise_intensity > 0.0) {
		col.rgb += clamp(random(SCREEN_UV + fract(TIME)).x, 0.0, 1.0) * noise_intensity;
	}
	
	// Glow
	vec3 glow = vec3(0.0);
	float count = 0.0;
	for (int x = -glow_radius; x <= glow_radius; x++) {
		for (int y = -glow_radius; y <= glow_radius; y++) {
			vec2 offset = vec2(float(x), float(y)) * SCREEN_PIXEL_SIZE;
			vec3 p_color = texture(screen_texture, SCREEN_UV + offset).rgb;
			float desat_value = desaturate(p_color).r;
			if (desat_value > glow_threshold) {
				glow += p_color;
			}
			count += 1.0;
		}
	}
	glow += 1.0 / count;

	col = mix(col, glow, glow_strength / 10.0);

    COLOR.rgb = col;
	COLOR.a = 1.0;
}