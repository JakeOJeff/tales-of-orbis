// Pixelated Monochrome Fire (GLSL - Shadertoy / WebGL)
// Paste into Shadertoy as the Fragment Shader (uses iTime, iResolution).
// Adjust pixelSize, speed, intensity, baseColor as needed.

#ifdef GL_ES
precision mediump float;
#endif

uniform float iTime;
uniform vec2 iResolution;

// Config
const float pixelSize = 6.0;      // size of each pixel block (in screen pixels). Increase for stronger pixelation.
const float speed = 1.2;          // animation speed
const float turbulence = 2.2;     // noise frequency multiplier
const float contrast = 1.6;       // shapes the crispness
const float glow = 1.6;           // overall brightness multiplier
const vec3 baseColor = vec3(1.0, 0.45, 0.1); // fire color (will be used uniformly) - change to any RGB

// --- hashing / noise (iq style) ---
float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 345.45));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // smoothstep
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash21(i + vec2(0.0, 0.0));
    float b = hash21(i + vec2(1.0, 0.0));
    float c = hash21(i + vec2(0.0, 1.0));
    float d = hash21(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float amp = 0.5;
    float freq = 1.0;
    // 5 octaves
    for (int i = 0; i < 5; i++) {
        v += amp * noise(p * freq);
        freq *= 2.0;
        amp *= 0.5;
    }
    return v;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized UV from 0..1
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Correct aspect so fire doesn't stretch
    float aspect = iResolution.x / iResolution.y;
    vec2 aUV = vec2(uv.x * aspect, uv.y);

    // Pixelation: compute grid coords
    vec2 pixelCount = iResolution.xy / pixelSize;            // how many blocks across/vertically
    vec2 gridUV = floor(fragCoord.xy / pixelSize) + 0.5;     // center of the block (in pixels)
    vec2 sampleUV = gridUV * (1.0 / iResolution.xy);         // back to normalized coords

    // Use sampleUV for everything so whole block has same color
    vec2 sUV_aspect = vec2(sampleUV.x * aspect, sampleUV.y);

    // Make vertical coordinate biased so fire rises: 0 at bottom, 1 at top
    float y = sampleUV.y;

    // Animate: move noise upward over time
    vec2 noisePos = vec2(sUV_aspect.x * turbulence, (sUV_aspect.y * turbulence) - iTime * speed);

    // Base fbm for turbulent shape
    float n = fbm(noisePos);

    // Add finer quick flicker (higher-frequency noise)
    float flicker = fbm(noisePos * 3.0 + vec2(0.0, iTime * 2.5)) * 0.35;

    // Shape the flame by stronger intensity near bottom and tapering toward top
    // invert y so 1.0 at bottom: (1 - y) is how close to bottom
    float heightFactor = pow(clamp(1.0 - y * 1.25, 0.0, 1.0), 1.4);

    // Create flame intensity combining noise, flicker and height factor
    float intensity = max(0.0, n * 0.9 + flicker) * heightFactor;

    // Add a soft core near the center (a vertical bias), optional
    float centerBias = smoothstep(0.5, 0.0, abs(sUV_aspect.x - 0.5)) * 0.8;
    intensity += centerBias * 0.35 * heightFactor;

    // Sharpen contrast
    intensity = pow(intensity, contrast);

    // Optional subtle upward trail (smear)
    float trail = fbm(vec2(sUV_aspect.x * turbulence, (sUV_aspect.y - 0.15) * turbulence - iTime * speed * 0.8)) * 0.25;
    intensity = max(intensity, trail * heightFactor);

    // Final color: single base color multiplied by intensity and glow
    vec3 color = baseColor * intensity * glow;

    // gamma / clamp
    color = clamp(color, 0.0, 1.0);

    fragColor = vec4(color, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
