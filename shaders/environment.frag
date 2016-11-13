uniform vec3 sun_pos;
uniform vec2 camera_pos;
uniform vec2 screen_size;
uniform float time;
uniform float viewport_scale;

const float SAMPLE_STEPS = 15;
const vec4 SUN_COLOR = vec4(1, 0.95, 0.85, 1);
const vec4 SKY_COLOR = vec4(0.541, 0.663, 0.839, 1);
const vec4 CLOUD_COLOR = vec4(1, 1, 1, 1);
const float SUN_RADIUS = 90;


// ***** Noise functions ******************************************************

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//
// Description : Array and textureless GLSL 2D/3D/4D simplex
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
//

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
     return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
  {
  const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
  const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

// First corner
  vec3 i  = floor(v + dot(v, C.yyy) );
  vec3 x0 =   v - i + dot(i, C.xxx) ;

// Other corners
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min( g.xyz, l.zxy );
  vec3 i2 = max( g.xyz, l.zxy );

  //   x0 = x0 - 0.0 + 0.0 * C.xxx;
  //   x1 = x0 - i1  + 1.0 * C.xxx;
  //   x2 = x0 - i2  + 2.0 * C.xxx;
  //   x3 = x0 - 1.0 + 3.0 * C.xxx;
  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
  vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

// Permutations
  i = mod289(i);
  vec4 p = permute( permute( permute(
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

// Gradients: 7x7 points over a square, mapped onto an octahedron.
// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
  float n_ = 0.142857142857; // 1.0/7.0
  vec3  ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

  vec4 x = x_ *ns.x + ns.yyyy;
  vec4 y = y_ *ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4( x.xy, y.xy );
  vec4 b1 = vec4( x.zw, y.zw );

  //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
  //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
  vec4 s0 = floor(b0)*2.0 + 1.0;
  vec4 s1 = floor(b1)*2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

  vec3 p0 = vec3(a0.xy,h.x);
  vec3 p1 = vec3(a0.zw,h.y);
  vec3 p2 = vec3(a1.xy,h.z);
  vec3 p3 = vec3(a1.zw,h.w);

//Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;

// Mix final noise value
  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),
                                dot(p2,x2), dot(p3,x3) ) );
}

float snoiseFractal(vec3 m) {
  return 0.5333333* snoise(m)
    +0.2666667* snoise(2.0*m)
    +0.1333333* snoise(4.0*m)
    +0.0666667* snoise(8.0*m);
}


// ***** Effect implementation ************************************************

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  vec4 texture_color = Texel(texture, texture_coords);
  vec2 texture_ratio = texture_coords/screen_coords;


  // ***** Sky color **********************************************************

  // Start with the default sky color
  vec4 sky_color = SKY_COLOR;

  float sun_intensity = 0;
  // Sun
  sun_intensity = min(1, pow(0.95, distance(screen_coords, sun_pos.xy)/viewport_scale - SUN_RADIUS));
  sky_color = mix(sky_color, SUN_COLOR, sun_intensity);

  // Clouds
  vec2 cloud_noise_pos = (camera_pos/5 + (screen_coords - screen_size/2)/viewport_scale).xy/1000;
  float cloud_noise = snoiseFractal(vec3(cloud_noise_pos, time/30));
  sky_color = mix(sky_color, CLOUD_COLOR, max(0, cloud_noise*5 - 0.4));


  // ***** Volumetric lighting ************************************************

  // Calculate volumetric lighting intensity
  float volumetric_intensity = 0;
  for (float i = rand(screen_coords); i < SAMPLE_STEPS; i++) {
    vec3 sample_coord = vec3(screen_coords, i*100);
    vec3 world_intersect_pos = normalize(sample_coord - sun_pos)*(-sun_pos.z) + sun_pos;
    float world_intersect_alpha = Texel(texture, world_intersect_pos.xy*texture_ratio).a;
    volumetric_intensity += (1 - world_intersect_alpha)/SAMPLE_STEPS;
  }
  // Apply animated simplex noise to volumetric lighting to make it spotty
  float lighting_noise = 0.25 + snoise(vec3(screen_coords*texture_ratio*2, time/1.5))/8;
  volumetric_intensity *= lighting_noise;
  // Dampen the volumetric lighting effect on the sky
  volumetric_intensity *= 0.5 + texture_color.a/2;


  // ***** Mix the final color ************************************************

  // Start with the original color passed in
  vec4 final_color = texture_color*color;

  // Render the sky
  final_color = mix(sky_color, final_color, texture_color.a);

  // Mix the volumetric light into the scene
  final_color = mix(final_color, SUN_COLOR, volumetric_intensity);

  return final_color;
}
