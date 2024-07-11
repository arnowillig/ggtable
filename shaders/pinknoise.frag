uniform lowp float iTime;
uniform lowp vec2 iResolution;
varying highp vec2 qt_TexCoord0;

float colormap_red(float x) {
    if (x < 0.0) {
	return 54.0 / 255.0;
    } else if (x < 20049.0 / 82979.0) {
	return (829.79 * x + 54.51) / 255.0;
    } else {
	return 1.0;
    }
}

float colormap_red3(float x) {
    // Change color mappings to dark green
    if (x < 0.0) {
	return 0.0; // Dark green component
    } else if (x < 20049.0 / 82979.0) {
	return 0.0; // Dark green component
    } else {
	return 0.0; // Dark green component
    }
}
float colormap_green3(float x) {
    // Change color mappings to turquoise
    if (x < 20049.0 / 82979.0) {
	return 0.0;
    } else if (x < 327013.0 / 810990.0) {
	return (1.0 * x + 0.5); // Adjusted for turquoise
    } else if (x <= 1.0) {
	return (0.4 * x + 0.5); // Adjusted for turquoise
    } else {
	return 1.0;
    }
}
float colormap_blue3(float x) {
    // Change color mappings to blue
    if (x < 0.0) {
	return 54.0 / 255.0; // Blue component
    } else if (x < 7249.0 / 82979.0) {
	return (0.8 * x + 0.2); // Adjusted for blue
    } else if (x < 20049.0 / 82979.0) {
	return 127.0 / 255.0; // Blue component
    } else if (x < 327013.0 / 810990.0) {
	return (0.6 * x + 0.4); // Adjusted for blue
    } else {
	return 1.0;
    }
}


float colormap_green(float x) {
    if (x < 20049.0 / 82979.0) {
	return 0.0;
    } else if (x < 327013.0 / 810990.0) {
	return (8546482679670.0 / 10875673217.0 * x - 2064961390770.0 / 10875673217.0) / 255.0;
    } else if (x <= 1.0) {
	return (103806720.0 / 483977.0 * x + 19607415.0 / 483977.0) / 255.0;
    } else {
	return 1.0;
    }
}

float colormap_blue(float x) {
    if (x < 0.0) {
	return 54.0 / 255.0;
    } else if (x < 7249.0 / 82979.0) {
	return (829.79 * x + 54.51) / 255.0;
    } else if (x < 20049.0 / 82979.0) {
	return 127.0 / 255.0;
    } else if (x < 327013.0 / 810990.0) {
	return (792.02249341361393720147485376583 * x - 64.364790735602331034989206222672) / 255.0;
    } else {
	return 1.0;
    }
}

vec4 colormap(float x) {
    return vec4(colormap_red(x), colormap_green(x), colormap_blue(x), 1.0);
}

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
	mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
	mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res*res;
}

const mat2 mtx = mat2( 0.80,  0.60, -0.60,  0.80 );

float fbm( vec2 p )
{
    float f = 0.0;

    f += 0.500000*noise( p + iTime  ); p = mtx*p*2.02;
    f += 0.031250*noise( p ); p = mtx*p*2.01;
    f += 0.250000*noise( p ); p = mtx*p*2.03;
    f += 0.125000*noise( p ); p = mtx*p*2.01;
    f += 0.062500*noise( p ); p = mtx*p*2.04;
    f += 0.015625*noise( p + sin(iTime) );

    return f/0.96875;
}

float pattern( in vec2 p )
{
    return fbm( p + fbm( p + fbm( p ) ) );
}

void main() {
    vec2 uv = qt_TexCoord0.xy * iResolution.xy / iResolution.y;
    float shade = pattern(uv);
    gl_FragColor = vec4(colormap(shade).rgb, shade);
}
