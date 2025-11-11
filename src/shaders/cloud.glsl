extern float iTime;
extern vec2 iResolution;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float total = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        total += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    // Pixelation amount
    float pixelSize = 8.0; // bigger = chunkier pixels
    vec2 uv = floor(sc / pixelSize) * pixelSize / iResolution;

    // Move the clouds
    vec2 p = uv * 2.0;
    p.x += iTime * 0.05;
    float n = fbm(p * 3.0);

    // Quantize noise for "steppy" texture
    n = floor(n * 5.0) / 5.0; // chunky cloud steps

    // Colors
    vec3 skyColor = vec3(0.04, 0.02, 0.15);
    vec3 cloudColor = vec3(0.23, 0.13, 0.76);

    float clouds = smoothstep(0.4, 0.7, n);
    clouds = floor(clouds * 4.0) / 4.0; // quantize alpha blend

    vec3 finalColor = mix(skyColor, cloudColor, clouds);
    return vec4(finalColor, 1.0);
}
