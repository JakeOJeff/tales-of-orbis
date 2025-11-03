// blackhole.frag - GLSL for Love2D (effect shader)
extern vec2 center;      // center in screen pixels (x, y)
extern number radius;    // radius in pixels
extern number strength;  // overall pull strength (e.g. 0.6 - 2.0)
extern number twist;     // angular twist multiplier (e.g. 4.0)
extern vec2 screenSize;  // screen size in pixels
extern number time;      // optional, for animated noise

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Current screen pixel in pixels
    vec2 sc = screen_coords;
    vec2 dir = sc - center;
    float dist = length(dir);

    // If outside radius, sample normally
    if (dist >= radius || radius <= 0.0) {
        return Texel(texture, texture_coords) * color;
    }

    // normalized falloff (1.0 at center -> 0.0 at radius)
    float n = 1.0 - (dist / radius);
    // apply a smooth curve to the falloff to make effect softer at edges
    float falloff = n * n * (3.0 - 2.0 * n); // smoothstep-like

    // radial pull: pixels move towards center by amount proportional to falloff*strength
    // we use a quadratic falloff so the center is strongly affected
    float pull = strength * falloff * (0.5 + 0.5 * falloff);

    // twist: angular offset (radians) depending on falloff and twist parameter
    float angleOffset = twist * falloff;

    // convert to polar and modify
    float theta = atan(dir.y, dir.x) + angleOffset;
    float newR = dist - pull * radius * 0.5; // move closer to center

    // clamp new radius so we don't go negative
    newR = max(newR, 0.0);

    vec2 newDir = vec2(cos(theta), sin(theta)) * newR;
    vec2 newSC = center + newDir;

    // convert back to texture coords (0..1)
    vec2 newTC = newSC / screenSize;

    // Optional small radial chromatic aberration (sample RGB slightly differently)
    // You can comment these three lines and use a single Texel() call if you prefer.
    float ca = 0.003 * falloff; // chromatic offset scale
    vec4 colR = Texel(texture, newTC + vec2(ca, 0.0));
    vec4 colG = Texel(texture, newTC);
    vec4 colB = Texel(texture, newTC - vec2(ca, 0.0));
    vec4 sampled = vec4(colR.r, colG.g, colB.b, (colR.a + colG.a + colB.a) / 3.0);

    // optionally darken near center (a "sink" look)
    float darken = 0.25 * pow(falloff, 1.5);
    sampled.rgb = sampled.rgb * (1.0 - darken);

    return sampled * color;
}
