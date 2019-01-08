<?xml version="1.0" encoding="UTF-8"?>

<shader language="GLSL">
  <vertex><![CDATA[
    uniform vec2 rubyTextureSize;
    attribute vec2 aPosition;
	attribute vec2 aTexCoord;
	varying vec4 vTexCoord[5];

    void main() {
      vec2 dg1 = 0.5 / rubyTextureSize;
      vec2 dg2 = vec2(-dg1.x, dg1.y);
      vec2 dx = vec2(dg1.x, 0.0);
      vec2 dy = vec2(0.0, dg1.y);

      vTexCoord[0].xy = aTexCoord;
      vTexCoord[1].xy = aTexCoord - dg1;
      vTexCoord[1].zw = aTexCoord - dy;
      vTexCoord[2].xy = aTexCoord - dg2;
      vTexCoord[2].zw = aTexCoord + dx;
      vTexCoord[3].xy = aTexCoord + dg1;
      vTexCoord[3].zw = aTexCoord + dy;
      vTexCoord[4].xy = aTexCoord + dg2;
      vTexCoord[4].zw = aTexCoord - dx;

      gl_Position = vec4(aPosition, 0.0, 1.0);
    }
  ]]></vertex>

  <fragment filter="nearest" output_width="200%" output_height="200%"><![CDATA[
    #ifdef GL_FRAGMENT_PRECISION_HIGH
    precision highp float;
    #else
    precision mediump float;
    #endif
    uniform sampler2D rubyTexture;
	varying vec4 vTexCoord[5];

    const float mx = 0.325;      // start smoothing wt.
    const float k = -0.250;      // wt. decrease factor
    const float max_w = 0.25;    // max filter weigth
    const float min_w =-0.05;    // min filter weigth
    const float lum_add = 0.25;  // effects smoothing

    void main() {
      vec3 c00 = texture2D(rubyTexture, vTexCoord[1].xy).xyz; 
      vec3 c10 = texture2D(rubyTexture, vTexCoord[1].zw).xyz; 
      vec3 c20 = texture2D(rubyTexture, vTexCoord[2].xy).xyz; 
      vec3 c01 = texture2D(rubyTexture, vTexCoord[4].zw).xyz; 
      vec3 c11 = texture2D(rubyTexture, vTexCoord[0].xy).xyz; 
      vec3 c21 = texture2D(rubyTexture, vTexCoord[2].zw).xyz; 
      vec3 c02 = texture2D(rubyTexture, vTexCoord[4].xy).xyz; 
      vec3 c12 = texture2D(rubyTexture, vTexCoord[3].zw).xyz; 
      vec3 c22 = texture2D(rubyTexture, vTexCoord[3].xy).xyz; 
      vec3 dt = vec3(1.0, 1.0, 1.0);

      float md1 = dot(abs(c00 - c22), dt);
      float md2 = dot(abs(c02 - c20), dt);

      float w1 = dot(abs(c22 - c11), dt) * md2;
      float w2 = dot(abs(c02 - c11), dt) * md1;
      float w3 = dot(abs(c00 - c11), dt) * md2;
      float w4 = dot(abs(c20 - c11), dt) * md1;

      float t1 = w1 + w3;
      float t2 = w2 + w4;
      float ww = max(t1, t2) + 0.001;

      c11 = (w1 * c00 + w2 * c20 + w3 * c22 + w4 * c02 + ww * c11) / (t1 + t2 + ww);

      float lc1 = k / (0.12 * dot(c10 + c12 + c11, dt) + lum_add);
      float lc2 = k / (0.12 * dot(c01 + c21 + c11, dt) + lum_add);

      w1 = clamp(lc1 * dot(abs(c11 - c10), dt) + mx, min_w, max_w);
      w2 = clamp(lc2 * dot(abs(c11 - c21), dt) + mx, min_w, max_w);
      w3 = clamp(lc1 * dot(abs(c11 - c12), dt) + mx, min_w, max_w);
      w4 = clamp(lc2 * dot(abs(c11 - c01), dt) + mx, min_w, max_w);

      gl_FragColor.rgb = w1 * c10 + w2 * c21 + w3 * c12 + w4 * c01 + (1.0 - w1 - w2 - w3 - w4) * c11;
    }
  ]]></fragment>
</shader>
