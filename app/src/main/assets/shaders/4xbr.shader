<?xml version="1.0" encoding="UTF-8"?>
<!--
   Hyllian's 4xBR Shader
   
   Copyright (C) 2011 Hyllian/Jararaca - sergiogdb@gmail.com

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-->

<shader language="GLSL">
<vertex><![CDATA[
	uniform vec2 rubyTextureSize;
	attribute vec2 aPosition;
	attribute vec2 aTexCoord;
	varying vec2 vTexCoord[3];

	void main() {
		vec2 ps = 1.0 / rubyTextureSize;
		vTexCoord[0] = aTexCoord;
		vTexCoord[1] = vec2(0.0, -ps.y); // B
		vTexCoord[2] = vec2(-ps.x, 0.0); // D

		gl_Position = vec4(aPosition, 0.0, 1.0);
	}
]]></vertex>

<fragment filter="nearest" output_width="400%" output_height="400%"><![CDATA[
	#ifdef GL_FRAGMENT_PRECISION_HIGH
	precision highp float;
	#else
	precision mediump float;
	#endif
	uniform sampler2D rubyTexture;
	uniform vec2 rubyTextureSize;
	varying vec2 vTexCoord[3];

	const vec3 dtt = vec3(65536.0, 255.0, 1.0);

	float reduce(vec3 color) {
		return dot(color, dtt);
	}
	
	void main() {
		vec2 fp = fract(vTexCoord[0]*rubyTextureSize);
	
		vec2 g1 = vTexCoord[1]*(step(0.5,fp.x)+step(0.5, fp.y)-1.0) + vTexCoord[2]*(step(0.5,fp.x) - step(0.5, fp.y));
		vec2 g2 = vTexCoord[1]*(step(0.5,fp.y) - step(0.5, fp.x)) + vTexCoord[2]*(step(0.5,fp.x)+step(0.5, fp.y)-1.0);
	
		vec3 B = texture2D(rubyTexture, vTexCoord[0] +g1   ).xyz;
		vec3 C = texture2D(rubyTexture, vTexCoord[0] +g1-g2).xyz;
		vec3 D = texture2D(rubyTexture, vTexCoord[0]    +g2).xyz;
		vec3 E = texture2D(rubyTexture, vTexCoord[0]       ).xyz;
		vec3 F = texture2D(rubyTexture, vTexCoord[0]    -g2).xyz;
		vec3 G = texture2D(rubyTexture, vTexCoord[0] -g1+g2).xyz;
		vec3 H = texture2D(rubyTexture, vTexCoord[0] -g1   ).xyz;
		vec3 I = texture2D(rubyTexture, vTexCoord[0] -g1-g2).xyz;
	
		vec3 E11 = E;
		vec3 E15 = E;
			
		float b = reduce(B);
		float c = reduce(C);
		float d = reduce(D);
		float e = reduce(E);
		float f = reduce(F);
		float g = reduce(G);
		float h = reduce(H);
		float i = reduce(I);	

		if (h==f && h!=e && ( e==g && (h==i || e==d) || e==c && (h==i || e==b) )) {
			E11 = E11*0.5+F*0.5;
			E15 = F;
		}

		gl_FragColor.rgb = (fp.x < 0.50) ? ((fp.x < 0.25) ? ((fp.y < 0.25) ? E15: (fp.y < 0.50) ? E11: (fp.y < 0.75) ? E11: E15) : ((fp.y < 0.25) ? E11: (fp.y < 0.50) ? E  : (fp.y < 0.75) ? E  : E11)) : ((fp.x < 0.75) ? ((fp.y < 0.25) ? E11: (fp.y < 0.50) ? E  : (fp.y < 0.75) ? E   : E11) : ((fp.y < 0.25) ? E15: (fp.y < 0.50) ? E11: (fp.y < 0.75) ? E11 : E15));
	}
]]></fragment>
</shader>
