<?xml version="1.0" encoding="UTF-8"?>
<!--
    Fragment shader based on "Improved texture interpolation" by Iñigo Quílez

    Original description:
        http://www.iquilezles.org/www/articles/texture/texture.htm
-->

<shader language="GLSL">
<fragment filter="linear"><![CDATA[
	#ifdef GL_FRAGMENT_PRECISION_HIGH
	precision highp float;
	#else
	precision mediump float;
	#endif
	uniform vec2 rubyTextureSize;
	uniform sampler2D rubyTexture;
	varying vec2 vTexCoord;

	vec4 getTexel(vec2 p) {
		p = p * rubyTextureSize + vec2(0.5);

		vec2 i = floor(p);
		vec2 f = p - i;
		f = f * f * f * (f * (f * 6.0 - vec2(15.0)) + vec2(10.0));
		p = i + f;

		p = (p - vec2(0.5)) / rubyTextureSize;
		return texture2D(rubyTexture, p);
	}

    void main() {
		gl_FragColor = getTexel(vTexCoord);
    }
]]></fragment>
</shader>
