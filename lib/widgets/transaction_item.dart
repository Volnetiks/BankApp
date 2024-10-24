import 'package:bank_app/objects/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(transaction.iconPath),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction.name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600)),
                        Text(transaction.category,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14))
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${transaction.price.toStringAsFixed(2)}\$",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900)),
                    Text(DateFormat("yy MMM, HH:mm").format(transaction.date),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12))
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
