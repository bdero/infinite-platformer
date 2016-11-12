uniform vec3 sun_pos;

const float SAMPLE_STEPS = 30;
const vec4 SUN_COLOR = vec4(1, 1, 1, 1);

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  vec2 texture_ratio = texture_coords/screen_coords;
  float intensity = 0;

  for (float i = 0; i < 1; i += 1/SAMPLE_STEPS) {
    vec3 sample_coord = vec3(screen_coords, i*3000);
    vec3 world_intersect = normalize(sample_coord - sun_pos)*(-sun_pos.z) + sun_pos;
    intensity += (1 - Texel(texture, vec2(world_intersect)*texture_ratio).a)/SAMPLE_STEPS;
  }
  if (distance(screen_coords, vec2(sun_pos)) < 10) {
    return vec4(1, 0, 0, 1);
  }

  vec4 texturecolor = Texel(texture, texture_coords);
  return mix(texturecolor*color, SUN_COLOR, intensity/2);
}
