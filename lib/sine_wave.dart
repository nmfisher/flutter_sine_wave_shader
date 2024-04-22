import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_shaders/flutter_shaders.dart';
import 'dart:ui' as ui;

class SineWave extends StatefulWidget {
  final double frequency;
  final double amplitude;
  final Color color;
  // final Color backgroundColor;

  const SineWave({
    super.key,
    required this.frequency,
    required this.amplitude,
    required this.color,
    // required this.backgroundColor
  });

  @override
  State<StatefulWidget> createState() {
    return _SineWaveState();
  }
}

class _SineWaveState extends State<SineWave>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  double time = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 16), (_) {
      time += 0.01;
      if (time > 1) {
        time = 0;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/sine_wave_shader/assets/shaders/sine.frag',
      (context, shader, child) => CustomPaint(
        // size: MediaQuery.of(context).size,
        foregroundPainter: ShaderPainter(
          frequency: widget.frequency,
          amplitude: widget.amplitude,
          shader: shader,
          color: widget.color,
          time: time,
        ),
        // child: Container(
        //   color: widget.backgroundColor,
        // )
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final double time;
  final Color color;

  ShaderPainter(
      {required this.shader,
      required this.color,
      this.amplitude = 1.0,
      this.frequency = 1.0,
      this.time = 0});
  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.save();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, amplitude);
    shader.setFloat(3, frequency);
    shader.setFloat(4, time);
    shader.setFloat(5, color.red / 255.0);
    shader.setFloat(6, color.green / 255.0);
    shader.setFloat(7, color.blue / 255.0);

    final paint = Paint()
      ..shader = shader
      ..blendMode = BlendMode.darken;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
