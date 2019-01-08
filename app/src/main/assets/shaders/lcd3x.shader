<?xml version="1.0" encoding="UTF-8"?>
<!--
   Author: Gigaherz
   License: Public domain
-->

<shader language="GLSL">
<vertex><![CDATA[
	uniform vec2 rubyTextureSize;
	attribute vec2 aPosition;
	attribute vec2 aTexCoord;
	varying vec2 vTexCoord;
	varying vec2 omega;

	void main() {
		gl_Position = vec4(aPosition, 0.0, 1.0);
		vTexCoord = aTexCoord;
		omega = 3.141592654 * 2.0 * rubyTextureSize;
	}
]]></vertex>

<fragment filter="nearest" output_width="300%" output_height="300%"><![CDATA[
	#ifdef GL_FRAGMENT_PRECISION_HIGH
	precision highp float;
	#else
	precision mediump float;
	#endif
	uniform sampler2D rubyTexture;
	varying vec2 vTexCoord;
	varying vec2 omega;

	/* configuration (higher values mean brighter image but reduced effect depth) */
	const float brighten_scanlines = 16.0;
	const float brighten_lcd = 8.0;

	const vec3 offsets = 3.141592654 * vec3(1.0/2.0,1.0/2.0 - 2.0/3.0,1.0/2.0-4.0/3.0);

	void main() {
		vec2 angle = vTexCoord * omega;

		float yfactor = (brighten_scanlines + sin(angle.y)) / (brighten_scanlines + 1.0);
		vec3 xfactors = (brighten_lcd + sin(angle.x + offsets)) / (brighten_lcd + 1.0);

		gl_FragColor.rgb = yfactor * xfactors * texture2D(rubyTexture, vTexCoord).rgb;
	}
]]></fragment>
</shader>
