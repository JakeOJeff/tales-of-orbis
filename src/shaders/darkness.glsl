    uniform vec2 lightPos;      // Light position in pixels
    uniform float lightRadius;   // Radius of the light
    uniform float softness;      // Softness of the light edge
    uniform vec3 darknessColor;  // Color of the darkness (default black)
    
    vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords) {
        // Calculate distance from current pixel to light center
        float dist = distance(screenCoords, lightPos);
        
        // Calculate light intensity based on distance
        float intensity = 1.0 - smoothstep(lightRadius - softness, lightRadius, dist);
        
        // Get the original texture color
        vec4 texColor = Texel(texture, texCoords);
        
        // Mix between darkness and the lit texture
        vec3 finalColor = mix(darknessColor, texColor.rgb, intensity);
        
        return vec4(finalColor, texColor.a) * color;
    }