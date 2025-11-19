extern float iTime;

// --- Noise Helpers ---
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

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
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

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 sc) {
    vec4 texColor = Texel(tex, uv);
    if (texColor.a <= 0.0) return texColor;

    vec2 p = uv * 3.0;

    p.y -= iTime * 0.8;
    p.x += sin(iTime * 2.0 + uv.y * 10.0) * 0.05;

    float n = fbm(p);
    n = smoothstep(0.3, 1.0, n);

    float heat = smoothstep(0.0, 0.7, uv.y);

    vec3 fireColor =
        mix(vec3(0.1, 0.0, 0.0),
        mix(vec3(1.0, 0.2, 0.0),
            vec3(1.0, 1.0, 0.0),
            n),
        heat);

    vec3 finalColor = texColor.rgb * fireColor * (0.5 + n * 1.2);

    return vec4(finalColor, texColor.a);
}
