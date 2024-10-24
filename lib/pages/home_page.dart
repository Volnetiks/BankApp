import 'package:bank_app/objects/transaction.dart';
import 'package:bank_app/utils/hex_color.dart';
import 'package:bank_app/widgets/analytics_graph.dart';
import 'package:bank_app/widgets/custom_icon.dart';
import 'package:bank_app/widgets/month_item.dart';
import 'package:bank_app/widgets/three_month_item.dart';
import 'package:bank_app/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool daily = true;
  int selectedSwitchIndex = 0;
  DateFormat textDateFormat = DateFormat("d MMM");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor.fromHex("#f4f4f4"),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          backgroundColor: HexColor.fromHex("#f4f4f4"),
          title: const Text("Analytics",
              style: TextStyle(fontWeight: FontWeight.w500)),
          leading: const Icon(Icons.arrow_back_ios_new_rounded),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: CustomIcon(path: "icons/bell.png", size: 20),
            )
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            "Analytics ${DateFormat("d MMM").format(DateTime.now())}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 34,
                                fontWeight: FontWeight.w500)),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 40,
                        ),
                      ],
                    ),
                    Text(
                        "Report from ${DateFormat("d.M.y").format(DateTime.now())}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 20)),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                daily
                                    ? "${textDateFormat.format(DateTime.now())} Income"
                                    : "${DateFormat("d").format(DateTime.now())} - ${textDateFormat.format(DateTime.now().subtract(const Duration(days: 7)))} Income",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 20)),
                            const Text("48,56k",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                        ToggleSwitch(
                          minWidth: 80,
                          initialLabelIndex: selectedSwitchIndex,
                          cornerRadius: 20,
                          activeFgColor: Colors.white,
                          inactiveFgColor: Colors.black,
                          totalSwitches: 2,
                          activeBgColor: const [Colors.black],
                          inactiveBgColor: Colors.white,
                          labels: const ["Daily", "Weekly"],
                          customTextStyles: const [
                            TextStyle(fontWeight: FontWeight.w500),
                            TextStyle(fontWeight: FontWeight.w500),
                          ],
                          radiusStyle: true,
                          onToggle: (index) {
                            setState(() {
                              daily = index == 0;
                              selectedSwitchIndex = index!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const AnalyticsGraph(),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6,
                    (index) => MonthItem(activated: index == 5, index: index)),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    3, (index) => ThreeMonthItem(index: (2 - index))),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Transaction History",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24)),
                    Text("View All",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 16))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                return TransactionItem(
                  transaction: Transaction(
                      name: index % 2 == 0 ? "Justine" : "Toa",
                      category:
                          index % 2 == 0 ? "Send Money" : "Received Money",
                      price: index % 2 == 0 ? -800 : 950,
                      date: DateTime.now(),
                      iconPath: index % 2 == 0
                          ? "images/toa.jpg"
                          : "images/justine.jpg"),
                );
              }))
            ],
          ),
        )));
  }
}
