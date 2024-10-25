import 'package:bank_app/widgets/analytics_graph.dart';
import 'package:bank_app/objects/transaction.dart';
import 'package:bank_app/utils/hex_color.dart';
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
  int indexValues = 0;
  List<List<double>> values = [
    [
      8000,
      8250,
      8450,
      7500,
      8000,
      8653,
      8450,
    ],
    [
      8250,
      7500,
      8000,
      9500,
      8400,
      8653,
      8450,
    ]
  ];

  Widget _buildIncomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            daily
                ? "${textDateFormat.format(DateTime.now())} Income"
                : "${DateFormat("d").format(DateTime.now())} - ${textDateFormat.format(DateTime.now().subtract(const Duration(days: 7)))} Income",
            style: const TextStyle(color: Colors.grey, fontSize: 20)),
        const Text("48,56k",
            style: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#f4f4f4"),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              centerTitle: true,
              scrolledUnderElevation: 0.0,
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
            SliverToBoxAdapter(
              child: Padding(
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
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 80,
                maxHeight: 80,
                child: Container(
                  color: HexColor.fromHex("#f4f4f4"),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIncomeSection(),
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
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  AnalyticsGraph(values: values[indexValues % 2]),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        6,
                        (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                indexValues = index;
                              });
                            },
                            child: MonthItem(
                                activated: index == indexValues,
                                index: index))),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        3, (index) => ThreeMonthItem(index: (2 - index))),
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 70,
                maxHeight: 70,
                child: Container(
                  color: HexColor.fromHex("#f4f4f4"),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: const Row(
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
              ),
            ),
          ];
        },
        body: ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return TransactionItem(
                transaction: Transaction(
                    name: index % 2 == 0 ? "Justine" : "Toa",
                    category: index % 2 == 0 ? "Send Money" : "Received Money",
                    price: index % 2 == 0 ? -800 : 950,
                    date: DateTime.now(),
                    iconPath: index % 2 == 0
                        ? "images/toa.jpg"
                        : "images/justine.jpg"),
              );
            }),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
