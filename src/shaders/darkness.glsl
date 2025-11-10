extern vec2 lightPos;
extern float lightRadius;
extern float ambient;
extern Image normalMap;

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord)
{
    // Distance falloff
    float dist = distance(screenCoord, lightPos);
    float attenuation = clamp(1.0 - dist / lightRadius, 0.0, 1.0);

    // Sample base color
    vec4 texColor = Texel(tex, texCoord);

    // Sample normal map (TreeNormal layer)
    vec3 normalColor = Texel(normalMap, texCoord).rgb;
    vec3 normal = normalize(normalColor * 2.0 - 1.0);

    // Compute light direction (towards viewer a bit)
    vec3 lightDir = normalize(vec3(lightPos - screenCoord, 400.0));

    // Diffuse lighting
    float diffuse = max(dot(normal, normalize(lightDir)), 0.0);

    // Colors
    vec3 ambientColor = vec3(1.0);
    vec3 lightColor = vec3(0.796, 0.510, 0.196);

    vec3 lighting = ambient * ambientColor + diffuse * lightColor * attenuation;

    return texColor * vec4(lighting, 1.0);
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