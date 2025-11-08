//************************************************************************************************************************/ 
// Xaos CRT shader
// created by Frank J Chao
// under license GPL 3.0
// 
// This shader is to simulate CRT post process effects towards its usage with Doplhin emulator
// 
//************************************************************************************************************************/

void main() {
    
    //********************************************************************************************************************/
    // Lens distortion
    //********************************************************************************************************************/

    // Determine zoomed coords
    float2 coords = GetCoordinates() - float2(0.5f, 0.5f); // origin to center of the screen
    //float2 scaled_coords = float2(coords.x*0.75f, coords.y*0.75f); // scales coords
    float DistFromCenter = length(coords);
    float2 lens_coords = coords*(0.937f+0.1177f*DistFromCenter); // lens distortion
    float2 sample_coords = lens_coords + float2(0.5f, 0.5f); // resets the origin to the corner of the screen

    //*********************************************************************************************************************/
    // Contrast, Saturation and blur
    //*********************************************************************************************************************/
    float2 blurRadius = 5.0f*GetInvResolution();
    float cutValue = 0.37f;
    float renormRange = 1.0f/(1.0f-cutValue);
    float4 BlurAccum = float4(0,0,0,0);
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(1.0f,0.0f));
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(1.0f,1.0f));
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(0.0f,1.0f));
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(-1.0f,1.0f));
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(-1.0f,0.0f));
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(-1.0f,-1.0f));
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(0.0f,-1.0f));
    BlurAccum += SampleLocation(sample_coords+blurRadius*float2(1.0f,-1.0f));
    float4 FinalBlur = renormRange*clamp(float4(0.125f*BlurAccum-float4(cutValue)), float4(0,0,0,0),float4(1,1,1,1));
    // The subtracting of the cut value uniform vector 4 has the added effect of increasing saturation of bright areas

    float4 BaseRender = SampleLocation(sample_coords);
    float contrast_alpha = 1.4f;
    float bright_beta = 0.25f;
    float4 ContrastRender = float4(contrast_alpha)*(BaseRender-float4(1.0f))+float4(1.0f)+float4(bright_beta);
    
    //**********************************************************************************************************************
    // Scanlines and Vignette
    //**********************************************************************************************************************
    float VignetteY = smoothstep(0.0f, 0.5f, 1.0f-abs(2.0f*lens_coords.y));
    float VignetteX = smoothstep(0.0f, 0.5f, 1.0f-abs(2.0f*lens_coords.x));
    //float Vignette = 1.0f-1.7f*DistFromCenter;
    //float Vignette = 2*DistFromCenter;
    float Vignette = 0.7f+0.3f*VignetteY*VignetteX;

    float ScanlinesY = 0.7f+0.7f*sin(4.0f*528.0f*sample_coords.y);
    float ScanlinesX = 1.2f+0.7f*sin(4.0f*640.0f*sample_coords.x);
    float Scanlines = clamp(0.5f+0.5f*ScanlinesY*ScanlinesX, 0.0f, 1.0f);
    float4 MaskEffects = float4 (clamp(1.2f*Scanlines*Vignette, 0.0f, 1.0f));
    //**********************************************************************************************************************

    //Debugging*************************************************************************************************************
    //float2 TestGrid = fract(sample_coords*10.0f);
    float2 TestGrid = fract(sample_coords*10.0f);
    //float4 Debug = float4(TestGrid.x, TestGrid.y, 0.0f, 1.0);
    float4 Debug = float4 (clamp(1.2f*Scanlines*Vignette, 0.0f, 1.0f));
    //**********************************************************************************************************************


    float4 FinalColor = (0.9f*ContrastRender+0.5f*FinalBlur)*MaskEffects;
    //SetOutput(Debug);
    SetOutput(FinalColor);
}