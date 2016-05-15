#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float HMIN, HMAX;
uniform float SMIN, SMAX;
uniform float VMIN, VMAX;

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void main (void) {
    vec4 color = texture2D(texture, vertTexCoord.st);
    vec3 hsv = rgb2hsv(color.rgb);

    if (
        HMIN <= hsv.x && hsv.x <= HMAX &&
        SMIN <= hsv.y && hsv.y <= SMAX &&
        VMIN <= hsv.z && hsv.z <= VMAX)
        gl_FragColor = color;
    else
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}
