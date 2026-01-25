uniform vec2 lightPos;    
uniform float lightRadius;
uniform float lightIntensity;
uniform float fadeSoftness;
uniform float ambientLight;    // 0.02 - 0.1 range works well

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords) {
    float dist = distance(screenCoords, lightPos);
    vec4 texColor = texture2D(texture, texCoords);
    
    float normalizedDist = dist / lightRadius;
    float attenuation = 1.0 / (1.0 + normalizedDist * normalizedDist);
    float fade = smoothstep(0.0, fadeSoftness, 1.0 - normalizedDist);
    
    // Main light brightness
    float mainBrightness = attenuation * fade * lightIntensity;
    
    // Ambient light that's always present but very faint
    float ambient = ambientLight;
    
    // Combine - the max() ensures we never go below ambient level
    float finalBrightness = max(mainBrightness, ambient);
    
    // Apply light color to the brightness
    vec3 tintedLight = vec3(1.0, 0.870, 0.403) * finalBrightness;
    
    // Multiply texture color with the tinted light
    vec3 litColor = texColor.rgb * tintedLight;
    return vec4(litColor, texColor.a);
}
