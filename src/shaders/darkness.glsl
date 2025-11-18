uniform vec2 lightPos;    
uniform float lightRadius;
uniform float lightIntensity;  // Controls overall brightness
uniform float fadeSoftness;    // Controls how soft the falloff is

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords) {
    float dist = distance(screenCoords, lightPos);
    vec4 texColor = texture2D(texture, texCoords);
    
    // Smooth falloff using inverse square law (more natural light behavior)
    float normalizedDist = dist / lightRadius;
    float attenuation = 1.0 / (1.0 + normalizedDist * normalizedDist);
    
    // Apply soft fade at the edges
    float fade = smoothstep(0.0, fadeSoftness, 1.0 - normalizedDist);
    
    // Combine attenuation with fade and intensity
    float finalBrightness = attenuation * fade * lightIntensity;
    
    // Apply the lighting to the texture color
    vec3 litColor = texColor.rgb * finalBrightness;
    
    return vec4(litColor, texColor.a);
}

    // uniform vec2 lightPos;    
    // uniform float lightRadius;  

    // vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords) {
    //     float dist = distance(screenCoords, lightPos);
    //     vec4 texColor = texture2D(texture, texCoords);
    //     if (dist < lightRadius) {
    //         return vec4(texColor.rgb, 1);
    //     }
    //     else {
    //         return vec4(0, 0, 0, 1);
    //     }

    // }