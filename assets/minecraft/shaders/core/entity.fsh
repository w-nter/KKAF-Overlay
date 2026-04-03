#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <mcc:emissives.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normalLightValue; // MCC - add input
flat in int isEmissive; // MCC - add input

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    // MCC start - add emissive lighting logic
    if (isEmissive == 1) {
        color = applyLighting(getAlpha(color.a), color * vertexColor, normalLightValue, lightMapColor);
    }
    // MCC end - add emissive lighting logic
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    // MCC start - edit for emissive logic
    if (isEmissive == 0) {
        color *= vertexColor * ColorModulator;
    } else {
        color *= ColorModulator;
    }
    // MCC end - edit for emissive logic
#ifndef NO_OVERLAY
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
    // MCC start - replace emissive detection
    if (isEmissive == 0) {
        color *= lightMapColor;
    }
    // MCC end - replace emissive detection
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
