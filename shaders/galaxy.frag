#version 310 es

precision mediump float;  // Add default precision for float

layout(set = 0, binding = 0) uniform UBO {
    lowp float qt_Opacity;
    lowp float iTime;
    lowp vec2 iResolution;
};

layout(set = 0, binding = 1) uniform sampler2D source;

layout(location = 0) in highp vec2 qt_TexCoord0;

layout(location = 0) out vec4 fragColor;

const float speed = 0.1;  // Initialize const variable

float field1(in vec3 p, float s) {
    float strength = 7. + .03 * log(1.e-6 + fract(sin(iTime) * 4373.11));
    float accum = s / 4.;
    float prev = 0.;
    float tw = 0.;
    for (int i = 0; i < 26; ++i) {
	float mag = dot(p, p);
	p = abs(p) / mag + vec3(-.5, -.4, -1.5);
	float w = exp(-float(i) / 7.);
	accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
	tw += w;
	prev = mag;
    }
    return max(0., 5. * accum / tw - .7);
}

float field2(in vec3 p, float s) {
    float strength = 7. + .03 * log(1.e-6 + fract(sin(iTime) * 4373.11));
    float accum = s / 4.;
    float prev = 0.;
    float tw = 0.;
    for (int i = 0; i < 18; ++i) {
	float mag = dot(p, p);
	p = abs(p) / mag + vec3(-.5, -.4, -1.5);
	float w = exp(-float(i) / 7.);
	accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
	tw += w;
	prev = mag;
    }
    return max(0., 5. * accum / tw - .7);
}

vec3 nrand3(vec2 co) {
    vec3 a = fract(cos(co.x * 8.3e-3 + co.y) * vec3(1.3e5, 4.7e5, 2.9e5));
    vec3 b = fract(sin(co.x * 0.3e-3 + co.y) * vec3(8.1e5, 1.0e5, 0.1e5));
    vec3 c = mix(a, b, 0.5);
    return c;
}

void main() {
    vec2 uv = 2. * qt_TexCoord0 - 1.;
    vec2 uvs = uv * iResolution.xy / max(iResolution.x, iResolution.y);
    vec3 p = vec3(uvs / 4., 0) + vec3(1., -1.3, 0.);
    p += .2 * vec3(sin(speed * iTime / 16.), sin(speed * iTime / 12.), sin(speed * iTime / 128.));

    float freqs[4];

    freqs[0] = texture(source, vec2(0.01, 0.25)).x;
    freqs[1] = texture(source, vec2(0.07, 0.25)).x;
    freqs[2] = texture(source, vec2(0.15, 0.25)).x;
    freqs[3] = texture(source, vec2(0.30, 0.25)).x;

    float t = field1(p, freqs[2]);
    float v = (1. - exp((abs(uv.x) - 1.) * 6.)) * (1. - exp((abs(uv.y) - 1.) * 6.));

    // Second Layer
    vec3 p2 = vec3(uvs / (4. + sin(speed * iTime * 0.11) * 0.2 + 0.2 + sin(speed * iTime * 0.15) * 0.3 + 0.4), 1.5) + vec3(2., -1.3, -1.);
    p2 += 0.25 * vec3(sin(speed * iTime / 16.), sin(speed * iTime / 12.), sin(speed * iTime / 128.));
    float t2 = field2(p2, freqs[3]);
    vec4 c2 = mix(.4, 1., v) * vec4(1.3 * t2 * t2 * t2, 1.8 * t2 * t2, t2 * freqs[0], t2);

    vec2 seed1 = p.xy * 2.0;
    seed1 = floor(seed1 * iResolution.x);
    vec3 rnd = nrand3(seed1);
    vec4 starcolor = vec4(pow(rnd.y, 40.0));

    vec2 seed2 = p2.xy * 2.0;
    seed2 = floor(seed2 * iResolution.x);
    vec3 rnd2 = nrand3(seed2);
    starcolor += vec4(pow(rnd2.y, 40.0));

    lowp vec4 effectColor = qt_Opacity * mix(freqs[3] - .3, 1., v) * vec4(1.5 * freqs[2] * t * t * t, 1.2 * freqs[1] * t * t, freqs[3] * t, 1.0) + c2 + starcolor;
    lowp vec4 bgColor = texture(source, qt_TexCoord0);
    fragColor = mix(bgColor, effectColor, qt_Opacity);
}
