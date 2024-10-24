import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String path;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const CustomIcon(
      {super.key,
      required this.path,
      required this.size,
      this.backgroundColor,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        margin: const EdgeInsets.all(10),
        color: backgroundColor,
        child: Image.asset(path, color: iconColor));
  }
}
