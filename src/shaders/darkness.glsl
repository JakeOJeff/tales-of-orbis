extern vec2 lightPos;
extern float lightRadius;
extern float ambient;

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    float dist = distance(screenCoord, lightPos);
    float intensity = clamp(1.0 - dist / lightRadius, 0.0, 1.0);

    vec4 texColor = Texel(tex, texCoord);

    // ambient light (white)
    vec3 ambientColor = vec3(1.0, 1.0, 1.0);

    // light color (orange)
    vec3 lightColor = vec3(0.79, 0.5, 0.19);

    // total brightness = ambient + orange light influence
    vec3 finalLight = ambient * ambientColor + intensity * lightColor;

    return texColor * vec4(finalLight, 1.0);
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