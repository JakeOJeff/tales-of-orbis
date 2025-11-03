extern float time;

vec4 effect(vec4 color, Image texture,vec2 tCoords,vec2 sCoords){
    vec2 t= tCoords;

    float px=(t.x-0.5)*32;
    float py=(t.y-0.5)*32;
    float pix1= cos(sqrt(px*px+py*py)+time);
    px=(t.x)*32;
    py=(t.y)*32;
    float pix2= cos(sqrt(px*px+py*py)+time*1.4)+0.5;
    px=(t.x)*32;
    py=(t.y-1)*32;
    float pix3= cos(sqrt(px*px+py*py)-time)+0.5;
    px=(t.x-1)*32;
    py=(t.y-1)*32;
    float pix4= cos(sqrt(px*px+py*py)-time)+0.5;

    float pixel=pix1+pix2+pix3+pix4-0.2;
    if (pixel>=1.5){
        return vec4(0.369,0.8,0.969,1);
    }
    else if (pixel>=0.5){
        return vec4(0.361,0.439,1.0,1);
        
    }
    else{
        return vec4(0.133,0.071,0.231,1);
    }
}