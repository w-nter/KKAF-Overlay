#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <mcc:emissives.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

// MCC start - add extra inputs
flat in int hideVertex;
in vec4 lightMapColor;
in vec4 normalLightValue;
// MCC end - add extra inputs

void main() {
    // MCC start - add nearby culling and emissive
    if (hideVertex == 1) {
        float alpha = textureLod(Sampler0, texCoord0, 0.0).a;
        
        // Discard if the alpha of the pixel is of value of 254, 251, 250, 201, 181, 180, 141, 140, 101, 100.
        // 254, 201, 101 are normal.
        // 251 is for emissive.
        if (alpha == 254.0 / 255.0 || alpha == 251.0 / 255.0 || alpha == 250.0 / 255.0 || alpha == 201.0 / 255.0 || alpha == 181.0 / 255.0 || alpha == 180.0 / 255.0 || alpha == 141.0 / 255.0 || alpha == 140.0 / 255.0 || alpha == 101.0 / 255.0 || alpha == 100.0 / 255.0) {
            discard;
        }
    }
    vec4 color = texture(Sampler0, texCoord0);
    color = applyLighting(getAlpha(color.a), color * vertexColor, normalLightValue, lightMapColor);
    color *= ColorModulator;
    // MCC end - add nearby culling and emissive
    if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
