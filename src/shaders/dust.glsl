// fire.glsl
// Pixelated Monochrome Fire Shader for LÖVE 11.x

extern number time;
extern vec2 resolution;
extern number pixelSize; // e.g., 6.0
extern vec3 baseColor;   // e.g., vec3(1.0, 0.45, 0.1)

// Hash and noise helpers
float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 345.45));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash21(i + vec2(0.0, 0.0));
    float b = hash21(i + vec2(1.0, 0.0));
    float c = hash21(i + vec2(0.0, 1.0));
    float d = hash21(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord)
{
    vec2 uv = screenCoord / resolution;
    float aspect = resolution.x / resolution.y;

    // Pixelation
    vec2 grid = floor(screenCoord / pixelSize) + 0.5;
    vec2 sampleUV = grid / resolution;
    vec2 su = vec2(sampleUV.x * aspect, sampleUV.y);

    float y = sampleUV.y;
    vec2 np = vec2(su.x * 2.2, (su.y * 2.2) - time * 0.6); // speed change
    float n = fbm(np);
    float flick = fbm(np * 3.0 + vec2(0.0, time * 1.6)) * 0.35; // flick change

    float h = pow(clamp(1.0 - y * 1.25, 0.0, 1.0), 1.4);
    float i = max(0.0, n * 0.9 + flick) * h;
    float center = smoothstep(0.5, 0.0, abs(su.x - 0.5)) * 0.8;
    i += center * 0.1 * h;
    i = pow(i, 1.5);

    // Compute color based on intensity
    vec3 col = baseColor * i;

    // Make low-intensity (black) areas transparent
    float alpha = smoothstep(0.05, 0.3, i); // Lower first value = more transparent black
    col *= alpha; // Fade color with alpha too

    return vec4(col, alpha);
}
