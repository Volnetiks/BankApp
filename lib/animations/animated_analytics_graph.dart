import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedAnalyticsGraph extends CustomPainter {
  final Animation<double> animation;
  final Path Function(Size size, List<double> values) createPath;
  final List<double> values;
  final Paint painter;

  AnimatedAnalyticsGraph(
      {required this.animation,
      required this.createPath,
      required this.values,
      required this.painter})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = createPath(size, values);
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractedPath =
          pathMetric.extractPath(0.0, pathMetric.length * animation.value);
      canvas.drawPath(extractedPath, painter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
