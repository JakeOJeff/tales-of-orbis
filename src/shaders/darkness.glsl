// shaders/darkness.glsl
uniform vec2 lightPos;      // center of the light in screen coordinates
uniform float lightRadius;  // radius of the light
uniform float ambient;      // ambient brightness (0 = full dark, 1 = no dark)

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord)
{
    float dist = distance(screenCoord, lightPos);

    float intensity = smoothstep(lightRadius, 0.0, dist);

    float brightness = clamp(ambient + intensity, 0.0, 1.0);

    // Get base color
    vec4 texColor = Texel(tex, texCoord);

    // Apply brightness
    return texColor * vec4(vec3(brightness), 1.0);
}
