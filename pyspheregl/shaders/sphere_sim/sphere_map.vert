

// These are sent to the fragment shader
out vec2 texCoord;      // UV coordinates of texture
out float alpha;        // Mask to remove out of circle texture
out float illumination; // brightness of point
out vec2 sphere;        // polar sphere coords
layout(location=0) in vec2 position;
uniform float rotate;
uniform float tilt;

void main()
{
    // convert screen co-ordinates (in aximuthal) to polar
    vec2 polar = az_to_polar(position);
    sphere = polar;

    // apply longitude rotation 
    polar.x -= rotate;
    
    // compute the cartesian coordinate
    vec4 pos = vec4(spherical_to_cartesian(polar),1);

    // rotate by the tilt
    pos = rotationMatrix(vec3(1,0,0), -tilt) * pos;
    
    // set the position
    gl_Position.xzy = pos.xyz;


    // cut off all portions outside of the circle and at the rear of the sphere
    float radius = sqrt((position.x*position.x)+(position.y*position.y));
    alpha = 1.0-smoothstep(0.95,1.0, radius);    
    alpha *= smoothstep(0.0, 0.1, gl_Position.z);

    // illuminate
    illumination = gl_Position.z;
    
    gl_Position.w = 1;
    // tex-coords are just 0-1, 0-1
    texCoord = position / 2.0 + 0.5;
}