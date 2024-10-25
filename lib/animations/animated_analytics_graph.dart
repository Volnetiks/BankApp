import 'dart:math';
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
    Offset highestPoint = findHighestPoint(path);
    Offset lowestPoint = findLowestPoint(path);
    final double lowestValue = values.reduce(min);
    final double highestValue = values.reduce(max);

    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractedPath =
          pathMetric.extractPath(0.0, pathMetric.length * animation.value);
      canvas.drawPath(extractedPath, painter);

      canvas.save();
      canvas.clipRect(
          Rect.fromLTRB(lowestPoint.dx, 0, highestPoint.dx, size.height));

      Paint innerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Colors.black;

      canvas.drawPath(extractedPath, innerPaint);

      canvas.restore();

      Paint paintCircle = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..strokeWidth = 3;

      if (extractedPath.getBounds().bottomRight.dx >= lowestPoint.dx) {
        paintCircle.style = PaintingStyle.fill;
        paintCircle.color = Colors.white;
        canvas.drawCircle(lowestPoint, 4, paintCircle);
        paintCircle.style = PaintingStyle.stroke;
        paintCircle.color = Colors.black;
        canvas.drawCircle(lowestPoint, 4, paintCircle);
      }

      if (extractedPath.getBounds().bottomRight.dx >= highestPoint.dx) {
        paintCircle.style = PaintingStyle.fill;
        paintCircle.color = Colors.white;
        canvas.drawCircle(highestPoint, 4, paintCircle);
        paintCircle.style = PaintingStyle.stroke;
        paintCircle.color = Colors.black;
        canvas.drawCircle(highestPoint, 4, paintCircle);
      }

      TextSpan lowestValueSpan = TextSpan(
          text: (lowestValue / 1000).toStringAsFixed(2),
          style: const TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500));
      TextPainter textPainter =
          TextPainter(text: lowestValueSpan, textDirection: TextDirection.ltr);

      textPainter.layout();

      Offset lowestTextOffset = Offset(
          lowestPoint.dx +
              (lowestPoint.dx > size.width / 2
                  ? (-textPainter.width - 25)
                  : 25),
          lowestPoint.dy - textPainter.height / 2);

      if (lowestTextOffset.dx + textPainter.width <=
          extractedPath.getBounds().bottomRight.dx) {
        textPainter.paint(canvas, lowestTextOffset);

        final lowestTextWidth = textPainter.width;

        TextSpan thousandsTextSpan = const TextSpan(
            text: "k", style: TextStyle(fontSize: 22, color: Colors.grey));

        textPainter.text = thousandsTextSpan;
        textPainter.layout();

        Offset thousandsOffset =
            Offset(lowestTextOffset.dx + lowestTextWidth, lowestTextOffset.dy);
        textPainter.paint(canvas, thousandsOffset);
      }

      TextSpan highestValueSpan = TextSpan(
          text: (highestValue / 1000).toStringAsFixed(2),
          style: const TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500));

      textPainter.text = highestValueSpan;
      textPainter.layout();

      Offset highestTextOffset = Offset(
          highestPoint.dx +
              (highestPoint.dx > size.width / 2
                  ? (-textPainter.width - 25)
                  : (25)),
          highestPoint.dy - textPainter.height);

      if (highestTextOffset.dx + textPainter.width <=
          extractedPath.getBounds().bottomRight.dx) {
        textPainter.paint(canvas, highestTextOffset);

        final highestTextWidth = textPainter.width;

        TextSpan thousandsTextSpan = const TextSpan(
            text: "k", style: TextStyle(fontSize: 22, color: Colors.grey));

        textPainter.text = thousandsTextSpan;
        textPainter.layout();

        Offset thousandsOffset = Offset(
            highestTextOffset.dx + highestTextWidth, highestTextOffset.dy);
        textPainter.paint(canvas, thousandsOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Offset findHighestPoint(Path path) {
    PathMetrics metrics = path.computeMetrics();
    double highestY = double.infinity;
    double xAtHighestY = 0;

    for (PathMetric metric in metrics) {
      for (double distance = 0; distance <= metric.length; distance += 1) {
        Tangent? tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          if (tangent.position.dy < highestY) {
            highestY = tangent.position.dy;
            xAtHighestY = tangent.position.dx;
          }
        }
      }
    }

    return Offset(xAtHighestY, highestY);
  }

  Offset findLowestPoint(Path path) {
    PathMetrics metrics = path.computeMetrics();
    double lowestY = double.negativeInfinity;
    double xAtLowestY = 0;

    for (PathMetric metric in metrics) {
      for (double distance = 0; distance <= metric.length; distance += 1) {
        Tangent? tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          if (tangent.position.dy > lowestY) {
            lowestY = tangent.position.dy;
            xAtLowestY = tangent.position.dx;
          }
        }
      }
    }

    return Offset(xAtLowestY, lowestY);
  }
}
