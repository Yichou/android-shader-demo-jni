<?xml version="1.0" encoding="UTF-8"?>

<shader language="GLSL">
  <fragment filter="nearest" history="7"
      output_width="100%" output_height="100%"><![CDATA[
    #ifdef GL_FRAGMENT_PRECISION_HIGH
    precision highp float;
    #else
    precision mediump float;
    #endif
    uniform sampler2D rubyTexture;
	uniform sampler2D historyTexture[7];
	varying vec2 vTexCoord;

	const float response_time = 0.45;

    void main() {
		float k = response_time;
		vec4 color = texture2D(historyTexture[6], vTexCoord);
		color += (texture2D(historyTexture[5], vTexCoord) - color) * k;
		k *= response_time;
		color += (texture2D(historyTexture[4], vTexCoord) - color) * k;
		k *= response_time;
		color += (texture2D(historyTexture[3], vTexCoord) - color) * k;
		k *= response_time;
		color += (texture2D(historyTexture[2], vTexCoord) - color) * k;
		k *= response_time;
		color += (texture2D(historyTexture[1], vTexCoord) - color) * k;
		k *= response_time;
		color += (texture2D(historyTexture[0], vTexCoord) - color) * k;
		k *= response_time;
		color += (texture2D(rubyTexture, vTexCoord) - color) * k;

		gl_FragColor = color;
    }
  ]]></fragment>
</shader>
