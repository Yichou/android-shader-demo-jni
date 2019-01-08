<?xml version="1.0" encoding="UTF-8"?>

<shader language="GLSL">
  <fragment><![CDATA[
    #ifdef GL_FRAGMENT_PRECISION_HIGH
    precision highp float;
    #else
    precision mediump float;
    #endif
    uniform sampler2D rubyTexture;
	varying vec2 vTexCoord;

    void main() {
		const vec3 coef = vec3(0.299, 0.587, 0.114);
		vec4 color = texture2D(rubyTexture, vTexCoord);
		gl_FragColor.rgb = vec3(dot(color.rgb, coef));
    }
  ]]></fragment>
</shader>
