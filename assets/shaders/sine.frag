#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

const float PI_2 = 6.28318530717;

uniform vec2 resolution;
uniform float amplitude;
uniform float frequency;
uniform float time;
uniform vec3 color;

out vec4 fragColor;

void main() {
  vec2 xy = FlutterFragCoord().xy;
  
  float mid = resolution.y / 2;
  float y;
  
  float xDistFromEnd = min(xy.x / 200, (resolution.x - xy.x) / 200);
  float decay = clamp(xDistFromEnd, 0.0f, 1.0f);
  y = mid + decay * (sin(frequency * (time + xy.x / resolution.x) * PI_2) * mid * amplitude);
  
  float yDistFromCenter = abs(xy.y - y);
  
  float alpha = clamp(1.0f - yDistFromCenter, 0.0f, 1.0f);

  alpha *= xDistFromEnd;

  fragColor = vec4(color, alpha);
}