import 'package:bank_app/painters/analytics_graph_painter.dart';
import 'package:flutter/material.dart';

class AnalyticsGraph extends StatefulWidget {
  const AnalyticsGraph({super.key});

  @override
  State<AnalyticsGraph> createState() => _AnalyticsGraphState();
}

class _AnalyticsGraphState extends State<AnalyticsGraph> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: CustomPaint(
        painter: AnalyticsGraphPainter(values: [
          8000,
          8250,
          8450,
          7500,
          8000,
          8653,
          8450,
        ]),
      ),
    );
  }
}
