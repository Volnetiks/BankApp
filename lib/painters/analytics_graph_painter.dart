import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnalyticsGraphPainter extends CustomPainter {
  final List<double> values;

  AnalyticsGraphPainter({super.repaint, required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final lowestValue = values.reduce(min);
    final highestValue = values.reduce(max);

    double maxCornerRadius = 120;

    List<Offset> pointsCoordinates = [];

    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final (index, value) in values.indexed) {
      Offset pointCoordinates = Offset(
          (size.width / (values.length - 1)) * index,
          size.height -
              ((value - lowestValue) / (highestValue - lowestValue)) *
                  size.height);

      pointsCoordinates.add(pointCoordinates);
    }

    Path path = Path()
      ..moveTo(pointsCoordinates.first.dx, pointsCoordinates.first.dy);

    for (int i = 1; i < pointsCoordinates.length - 1; i++) {
      final p0 = pointsCoordinates[i - 1];
      final p1 = pointsCoordinates[i];
      final p2 = pointsCoordinates[i + 1];

      final segment1Length = (p1 - p0).distance;
      final segment2Length = (p2 - p1).distance;
      final angle = calculateAngle(p0, p1, p2);

      double cornerRadius = getDynamicCornerRadius(
          angle, segment1Length, segment2Length, maxCornerRadius);

      final tangentLength = calculateTangentLength(angle, cornerRadius);
      final adjustedTangentLength1 = max(tangentLength, segment1Length / 2);
      final adjustedTangentLength2 = max(tangentLength, segment2Length / 2);

      final beforeCorner = getPointAtDistance(p1, p0, adjustedTangentLength1);
      final afterCorner = getPointAtDistance(p1, p2, adjustedTangentLength2);

      final control1 = Offset(
        (beforeCorner.dx + p1.dx) / 2,
        (beforeCorner.dy + p1.dy) / 2,
      );

      final control2 = Offset(
        (afterCorner.dx + p1.dx) / 2,
        (afterCorner.dy + p1.dy) / 2,
      );

      if (i == 1) {
        path.lineTo(beforeCorner.dx, beforeCorner.dy);
      }

      path.cubicTo(
        control1.dx,
        control1.dy,
        p1.dx,
        p1.dy,
        control2.dx,
        control2.dy,
      );

      if (i == pointsCoordinates.length - 2) {
        path.lineTo(pointsCoordinates.last.dx, pointsCoordinates.last.dy);
      } else {
        path.lineTo(afterCorner.dx, afterCorner.dy);
      }
    }

    canvas.drawPath(path, paint);

    Offset actualHighest = findHighestPoint(path);
    Offset actualLowest = findLowestPoint(path);

    canvas.save();
    canvas.clipRect(
        Rect.fromLTRB(actualLowest.dx, 0, actualHighest.dx, size.height));

    paint.color = Colors.black;
    paint.strokeWidth = 5;

    canvas.drawPath(path, paint);

    canvas.restore();

    Paint paintCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    canvas.drawCircle(actualHighest, 4, paintCircle);
    canvas.drawCircle(actualLowest, 4, paintCircle);

    paintCircle.style = PaintingStyle.stroke;
    paintCircle.color = Colors.black;

    canvas.drawCircle(actualHighest, 4, paintCircle);
    canvas.drawCircle(actualLowest, 4, paintCircle);

    TextSpan lowestValueSpan = TextSpan(
        text: (lowestValue / 1000).toStringAsFixed(2),
        style: const TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500));
    TextPainter textPainter =
        TextPainter(text: lowestValueSpan, textDirection: TextDirection.ltr);

    textPainter.layout();

    Offset lowestTextOffset = Offset(
        actualLowest.dx +
            (actualLowest.dx > size.width / 2 ? (-textPainter.width - 25) : 25),
        actualLowest.dy - textPainter.height / 2);

    double lowestTextWidth = textPainter.width;

    textPainter.paint(canvas, lowestTextOffset);

    TextSpan highestValueSpan = TextSpan(
        text: (highestValue / 1000).toStringAsFixed(2),
        style: const TextStyle(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500));

    textPainter.text = highestValueSpan;
    textPainter.layout();

    Offset highestTextOffset = Offset(
        actualHighest.dx +
            (actualHighest.dx > size.width / 2
                ? (-textPainter.width - 25)
                : (25)),
        actualHighest.dy - textPainter.height);

    double highestTextWidth = textPainter.width;

    textPainter.paint(canvas, highestTextOffset);

    TextSpan thousandsTextSpan = const TextSpan(
        text: "k", style: TextStyle(fontSize: 22, color: Colors.grey));

    textPainter.text = thousandsTextSpan;
    textPainter.layout();

    Offset thousandsOffset =
        Offset(lowestTextOffset.dx + lowestTextWidth, lowestTextOffset.dy);
    textPainter.paint(canvas, thousandsOffset);

    thousandsOffset =
        Offset(highestTextOffset.dx + highestTextWidth, highestTextOffset.dy);
    textPainter.paint(canvas, thousandsOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double calculateTangentLength(double angle, double cornerRadius) {
    if (angle < pi / 6) {
      return cornerRadius * 2;
    } else if (angle > 5 * pi / 6) {
      return cornerRadius * 0.5;
    } else {
      return cornerRadius * tan(angle / 4);
    }
  }

  double calculateAngle(Offset p0, Offset p1, Offset p2) {
    final double dx1 = p0.dx - p1.dx;
    final double dy1 = p0.dy - p1.dy;
    final double dx2 = p2.dx - p1.dx;
    final double dy2 = p2.dy - p1.dy;

    final double angle1 = atan2(dy1, dx1);
    final double angle2 = atan2(dy2, dx2);

    var angle = (angle2 - angle1).abs();
    if (angle > pi) {
      angle = 2 * pi - angle;
    }

    return angle;
  }

  double getDynamicCornerRadius(double angle, double segment1Length,
      double segment2Length, double maxRadius) {
    final angleMultiplier = sin(angle);
    final minSegmentLength = max(segment1Length, segment2Length);
    final maxAllowedRadius = minSegmentLength / 3;

    return max(maxRadius * angleMultiplier, maxAllowedRadius);
  }

  Offset getPointAtDistance(Offset start, Offset end, double distance) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final length = sqrt(dx * dx + dy * dy);

    if (length == 0) return start;

    final unitX = dx / length;
    final unitY = dy / length;

    return Offset(
      start.dx + (unitX * distance),
      start.dy + (unitY * distance),
    );
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
}
