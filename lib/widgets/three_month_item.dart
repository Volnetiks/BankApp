import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThreeMonthItem extends StatelessWidget {
  const ThreeMonthItem({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.now()
        .add(const Duration(days: 1))
        .subtract(Duration(days: 31 * (index + 1)));
    DateTime endDate = DateTime.now()
        .add(const Duration(days: 1))
        .subtract(Duration(days: 31 * index));
    DateFormat dateFormat = DateFormat("MMM");

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: (startDate.isBefore(DateTime.now()) &&
                  endDate.isAfter(DateTime.now()))
              ? Colors.blue
              : Colors.transparent,
          border: Border.all(
              color: (startDate.isBefore(DateTime.now()) &&
                      endDate.isAfter(DateTime.now()))
                  ? Colors.transparent
                  : Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Text(
            "${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}",
            style: TextStyle(
              color: (startDate.isBefore(DateTime.now()) &&
                      endDate.isAfter(DateTime.now()))
                  ? Colors.white
                  : Colors.black,
            )),
      ),
    );
  }
}
