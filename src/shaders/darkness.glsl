extern vec2 lightPos;      
extern float lightRadius; 

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords)
{
    float dist = distance(screenCoords, lightPos);
    float intensity = clamp(1.0 - (dist / lightRadius), 0.0, 1.0);
    vec4 texColor = Texel(texture, texCoords);
    float brightness = mix(0.5, 1.0, intensity);

    return vec4(texColor.rgb * brightness, texColor.a);
}
