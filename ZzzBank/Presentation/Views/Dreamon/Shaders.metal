//
//  Shaders.metal
//  Swift6
//
//  Created by wayblemac02 on 5/12/25.
//

#include <metal_stdlib>
using namespace metal;

float3 getColor(float t) {
  if (t == 0) {
    return float3(0.4823529412, 0.831372549, 0.8549019608);
  }
  if (t == 1) {
    return float3(0.4117647059, 0.4117647059, 0.8470588235);
  }
  if (t == 2) {
    return float3(0.9411764706, 0.3137254902, 0.4117647059);
  }
  if (t == 3) {
    return float3(0.2745098039, 0.4901960784, 0.9411764706);
  }
  if (t == 4) {
    return float3(0.0784313725, 0.862745098, 0.862745098);
  }
  if (t == 5) {
    return float3(0.7843137255, 0.6274509804, 0.5490196078);
  }
  return float3(0.0);
}

float glow(float x, float str, float dist){
    return dist / pow(x, str);
}

float harmonicSDF(float2 uv, float a, float offset, float f, float phi) {
  return abs((uv.y - offset) + cos(uv.x * f + phi) * a);
}

[[ stitchable ]]
half4 harmonicColorEffect(
  float2 pos,
  half4 color,
  float4 bounds,
  float wavesCount,
  float time,
  float amplitude,
  float mixCoeff
) {
  float2 uv = pos / float2(bounds.z, bounds.w);
  uv -= float2(0.5, 0.5);

  float a = cos(uv.x * 3.0) * amplitude * 0.2;
  float offset = sin(uv.x * 12.0 + time) * a * 0.1;
  float frequency = mix(3.0, 12.0, mixCoeff);
  float glowWidth = mix(0.6, 0.9, mixCoeff);
  float glowIntensity = mix(0.02, 0.01, mixCoeff);

  float3 finalColor = float3(0.0);

  for (float i = 0.0; i < wavesCount; i++) {
    float phase = time + i * M_PI_F / wavesCount;
    float sdfDist = glow(harmonicSDF(uv, a, offset, frequency, phase), glowWidth, glowIntensity);

    float3 waveColor = mix(float3(1.0), getColor(i), mixCoeff);

    finalColor += waveColor * sdfDist;
  }

  return half4(half3(finalColor), 1.0);
}
