uniform lowp float qt_Opacity;
varying highp vec2 qt_TexCoord0;
uniform lowp float iTime;
uniform lowp vec2 iResolution;

vec3 palette(float t) {
	vec3 a = vec3(0.5, 0.5, 0.5);
	vec3 b = vec3(0.5, 0.5, 0.5);
	vec3 c = vec3(1.0, 1.0, 1.0);
	vec3 d = vec3(0.263, 0.416, 0.557);
	return a + b * cos(6.28318 * (c * t + d));
}

void main() {
	vec2 uv = (gl_FragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;
	vec2 uv0 = uv;
	vec3 finalColor = vec3(0.0);

	for (float i = 0.0; i < 5.0; i++) {
		uv = fract(uv * 1.5) - 0.5;
		float d = length(uv) * exp(-length(uv0));
		vec3 col = palette(length(uv0) + i * 0.4 + iTime * 0.04);
		d = sin(d * 8.0 + 0.1 * iTime) / 8.0;
		d = abs(d);
		d = pow(0.01 / d, 1.2);
		finalColor += col * d;
	}
	gl_FragColor = vec4(finalColor, 1.0) * qt_Opacity;
}
