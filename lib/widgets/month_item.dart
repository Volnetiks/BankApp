import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthItem extends StatelessWidget {
  const MonthItem({super.key, required this.activated, required this.index});

  final bool activated;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Text(
        DateFormat("MMM").format(
            DateTime(DateTime.now().year, DateTime.now().month, 1)
                .subtract(const Duration(days: 150))
                .add(Duration(days: 31 * index))),
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: activated ? Colors.black : Colors.grey));
  }
}
