<?xml version="1.0" encoding="UTF-8"?>
<!--
    Scanline shader
    Author: Themaister
    This code is hereby placed in the public domain.
-->
<shader language="GLSL">
   <vertex><![CDATA[
     uniform vec2 rubyTextureSize;
     uniform vec2 rubyInputSize;
     uniform vec2 rubyOutputSize;
     attribute vec2 aPosition;
	 attribute vec2 aTexCoord;
	 varying vec2 vTexCoord;
     varying vec2 omega;

     void main()
     {
	gl_Position = vec4(aPosition, 0.0, 1.0);
	vTexCoord = aTexCoord;
	omega = vec2(3.1415 * rubyOutputSize.x * rubyTextureSize.x / rubyInputSize.x, 2.0 * 3.1415 * rubyTextureSize.y);
     }
     ]]></vertex>

   <fragment><![CDATA[
     #ifdef GL_FRAGMENT_PRECISION_HIGH
     precision highp float;
     #else
     precision mediump float;
     #endif

     uniform sampler2D rubyTexture;
	 varying vec2 vTexCoord;
     varying vec2 omega;

     const float base_brightness = 0.95;
     const vec2 sine_comp = vec2(0.05, 0.15);

     void main ()
     {
	vec4 c11 = texture2D(rubyTexture, vTexCoord);

	vec4 scanline = c11 * (base_brightness + dot(sine_comp * sin(vTexCoord * omega), vec2(1.0)));
	gl_FragColor = clamp(scanline, 0.0, 1.0);
     }
     ]]></fragment>
</shader>
