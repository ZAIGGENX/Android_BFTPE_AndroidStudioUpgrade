// Fragment Shader

precision mediump float;

// texture variables
uniform vec4 vColor; 
uniform sampler2D texture1; // color texture
uniform sampler2D texture2; // normal map texture
varying float tex;
varying vec2 tCoord;

varying vec3 vNormal;
varying vec3 EyespaceNormal;

// Light
uniform vec4 lightPos;
uniform vec4 lightColor;

// material
uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

// eye pos
uniform vec3 eyePos;

// from vertex shader
varying vec3 lightDir, eyeVec;

// dot function between two vectors
float Dot(vec3 v1, vec3 v2) {
	return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
}

void main() { 

	// Just to show them being used
	//vec4 a = lightPos;
    vec4 b = lightColor;
    vec4 c = matAmbient;
    vec4 d = matDiffuse;
    vec4 e = matSpecular;
    vec3 g = eyePos;
    float f = matShininess;

	float distSqr = Dot(lightDir, lightDir);
	float att = clamp(1.0 - 0.001 * sqrt(distSqr), 0.0, 1.0);
	vec3 L = lightDir * inversesqrt(distSqr);

	// get the base color
	vec4 baseColor = texture2D(texture1, tCoord);

	// get the normal from the normal map - change from [0,1] to [-1,1]
	vec3 N = normalize( texture2D(texture2, tCoord).xyz * 2.0 - 1.0);

	vec3 oldN = normalize(EyespaceNormal);
    vec3 E = normalize(eyeVec); 
    
    // Reflect the vector. Use this or reflect(incidentV, N);
    vec3 reflectV = reflect(-L, N);

    // Get lighting terms
    vec4 ambientTerm;
    //if (tex >= 1.0) {
    	ambientTerm = baseColor;
    //}
    //else
    	//ambientTerm = matAmbient * lightColor;

    vec4 diffuseTerm = baseColor * matDiffuse * max(Dot(N, L), 0.0);
    vec4 specularTerm = matSpecular * pow(max(Dot(reflectV, E), 0.0), matShininess);

	gl_FragColor =  (ambientTerm + diffuseTerm + specularTerm) * att;
}
