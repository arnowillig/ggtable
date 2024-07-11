uniform lowp float qt_Opacity;
uniform lowp float iTime;
uniform lowp vec2 iResolution;
varying highp vec2 qt_TexCoord0;
uniform sampler2D source;

const float speed = 0.025;

vec3 hsv2rgb(lowp vec3 c) {
	lowp vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	lowp vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main(void) {
	lowp vec2 p =  qt_TexCoord0 * 8.0 - vec2(20.0);
	lowp vec2 i = p;
	lowp float c = 1.0;
	lowp float inten = .05;
	for (int n = 0; n < 3; n++) {
		lowp float t = speed * iTime * (1.0 - (3.0 / lowp float(n+1)));
		i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0 / length(vec2(p.x / (sin(i.x+t) / inten), p.y / (cos(i.y+t) / inten)));
	}
	c = 1.5 - sqrt(c / 3.0);

	lowp vec4 effectColor = vec4(hsv2rgb(vec3(speed * iTime, 0.3, 0.1)) * (1.0 / (1.0 - (c + 0.05)) / 2.0), 1.0);
	lowp vec4 bgColor = texture2D(source, qt_TexCoord0);
	gl_FragColor = mix(bgColor, effectColor, qt_Opacity);
}
