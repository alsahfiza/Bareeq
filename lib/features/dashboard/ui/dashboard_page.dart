// DashboardPage
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';


// ✅ DASHBOARD PAGE (MAIN)
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1100;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------- KPI CARDS --------
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                KPICard(
                    title: "Total Sales",
                    value: "\$48,988,078",
                    color: Colors.orange,
                    icon: Icons.shopping_cart),
                KPICard(
                    title: "Total Sales Return",
                    value: "\$16,478,145",
                    color: Colors.indigo,
                    icon: Icons.undo),
                KPICard(
                    title: "Total Purchase",
                    value: "\$24,145,789",
                    color: Colors.teal,
                    icon: Icons.local_mall),
                KPICard(
                    title: "Total Purchase Return",
                    value: "\$18,458,747",
                    color: Colors.blue,
                    icon: Icons.reply),
              ],
            ),

            const SizedBox(height: 24),

            // -------- STAT CARDS --------
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                StatCard(
                    title: "Profit",
                    amount: "\$8,458,798",
                    percent: "+35%",
                    icon: Icons.trending_up),
                StatCard(
                    title: "Invoice Due",
                    amount: "\$48,988.78",
                    percent: "+35%",
                    icon: Icons.receipt),
                StatCard(
                    title: "Total Expenses",
                    amount: "\$8,980,097",
                    percent: "+15%",
                    icon: Icons.money_off),
                StatCard(
                    title: "Total Returns",
                    amount: "\$78,458,798",
                    percent: "-10%",
                    icon: Icons.refresh),
              ],
            ),

            const SizedBox(height: 24),

            const Row3Section(),
            const SizedBox(height: 24),
            const Row4Section(),
            const SizedBox(height: 24),
            const Row5Section(),
            const SizedBox(height: 24),
            const Row6RecentSales(),
            const SizedBox(height: 24),
            const Row7TopCustomersAndCategories(),
            const SizedBox(height: 24),
            const Row8OrderStatistics(),
            const Footer(),
          ],
        ),
      ),
    );
  }
}


// ===== COMPONENTS BELOW: KPI Card, Stat Card, Product List, Chart, etc.
// class KPICard extends StatelessWidget {
//   final String title;
//   final String value;
//   final Color color;
//   final IconData icon;
//   const KPICard({super.key, required this.title, required this.value, required this.color, required this.icon});
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 280,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
//         child: Row(children: [
//           CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
//           const SizedBox(width: 12),
//           Expanded(
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
//             const SizedBox(height: 4),
//             Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ])),
//         ]),
//       ),
//     );
//   }
// }
class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final String percent;
  final bool positive;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.percent = "+25%",
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: icon + percent badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: positive
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        positive
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 12,
                        color:
                            positive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        percent,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              positive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Value
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class StatCard extends StatelessWidget {
//   final String title, amount, percent;
//   final IconData icon;
//   const StatCard({super.key, required this.title, required this.amount, required this.percent, required this.icon});
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 280,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6)
//         ]),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Icon(icon, color: Colors.blue, size: 30),
//           const SizedBox(height: 16),
//           Text(amount, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//           Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
//           const SizedBox(height: 8),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Text("vs Last Month $percent", style: const TextStyle(color: Colors.green)),
//             Text("View All", style: TextStyle(color: Colors.blue[700], fontSize: 13)),
//           ]),
//         ]),
//       ),
//     );
//   }
// }

class StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final String percent;
  final IconData icon;
  final bool positive;

  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percent,
    required this.icon,
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top-right icon
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Colors.blue),
              ),
            ),

            const SizedBox(height: 12),

            // Amount
            Text(
              amount,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 14),

            // Bottom row: delta + view all
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: positive
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        positive
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 12,
                        color:
                            positive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        percent,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              positive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class ProductListCard extends StatelessWidget {
  final String title;
  final List<String> items;
  const ProductListCard({super.key, required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((item) => ListTile(
                dense: true,
                leading: const CircleAvatar(radius: 14, backgroundColor: Colors.grey),
                title: Text(item, style: const TextStyle(fontSize: 14)),
                trailing: const Text("x10"),
              ))
        ]),
      ),
    );
  }
}

// ROW 3: Sales & Purchase + Overall Information
class Row3Section extends StatelessWidget {
  const Row3Section({super.key});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 1000;
    return isWideScreen
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SalesChartCard()),
              SizedBox(width: 16),
              Expanded(child: OverallInfoCard()),
            ],
          )
        : Column(
            children: [
              SalesChartCard(),
              SizedBox(height: 16),
              OverallInfoCard(),
            ],
          );
  }
}

// class SalesChartCard extends StatelessWidget {
//   const SalesChartCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: const [
//                     Icon(Icons.shopping_cart_outlined, color: Colors.orange),
//                     SizedBox(width: 8),
//                     Text("Sales & Purchase", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 ToggleButtons(
//                   isSelected: [false, false, false, false, false, true],
//                   borderRadius: BorderRadius.circular(6),
//                   children: const [
//                     Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('1D')),
//                     Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('1W')),
//                     Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('1M')),
//                     Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('3M')),
//                     Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('6M')),
//                     Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('1Y')),
//                   ],
//                   onPressed: (index) {},
//                 )
//               ],
//             ),

//             const SizedBox(height: 16),

//             // Metrics
//             Row(
//               children: [
//                 _metricBox("Total Purchase", "3K", Colors.orange.shade100),
//                 const SizedBox(width: 12),
//                 _metricBox("Total Sales", "1K", Colors.orange.shade200),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // Bar Chart
//             SizedBox(
//               height: 220,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: 100,
//                   barTouchData: BarTouchData(enabled: false),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 30,
//                         getTitlesWidget: (value, meta) {
//                           const labels = ['2 am', '4 am', '6 am', '8 am', '10 am', '12 am', '14 pm', '16 pm', '18 pm', '20 pm', '22 pm', '24 pm'];
//                           return SideTitleWidget(
//                             axisSide: meta.axisSide,
//                             child: Text(labels[value.toInt() % labels.length], style: const TextStyle(fontSize: 10)),
//                           );
//                         },
//                         interval: 1,
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         interval: 20,
//                         getTitlesWidget: (value, meta) {
//                           return Text('${value.toInt()}K', style: const TextStyle(fontSize: 10));
//                         },
//                       ),
//                     ),
//                     topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   gridData: FlGridData(
//                     show: true,
//                     getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
//                     drawVerticalLine: false,
//                   ),
//                   borderData: FlBorderData(show: false),
//                   barGroups: _buildBars(),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _metricBox(String title, String value, Color bgColor) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         decoration: BoxDecoration(
//           color: bgColor.withOpacity(0.3),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.circle, color: bgColor, size: 8),
//                 const SizedBox(width: 6),
//                 Text(title, style: const TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   List<BarChartGroupData> _buildBars() {
//     final light = Colors.orange.shade100;
//     final dark = Colors.orange.shade400;

//     final purchase = [40, 38, 35, 65, 62, 64, 48, 55, 89, 38, 66, 48];
//     final sales = [18, 20, 10, 18, 25, 18, 10, 20, 40, 10, 30, 20];

//     return List.generate(12, (i) {
//       return BarChartGroupData(x: i, barRods: [
//         BarChartRodData(
//           toY: purchase[i].toDouble(),
//           rodStackItems: [
//             BarChartRodStackItem(0, sales[i].toDouble(), dark),
//             BarChartRodStackItem(sales[i].toDouble(), purchase[i].toDouble(), light),
//           ],
//           width: 18,
//           borderRadius: BorderRadius.circular(4),
//         )
//       ]);
//     });
//   }
// }

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.shopping_cart_outlined,
                      color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    "Sales & Purchase",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              _RangeTabs(),
            ],
          ),

          const SizedBox(height: 16),

          // ===== METRICS =====
          Row(
            children: const [
              _MetricPill(
                label: "Total Purchase",
                value: "3K",
                color: Colors.orange,
              ),
              SizedBox(width: 12),
              _MetricPill(
                label: "Total Sales",
                value: "1K",
                color: Colors.deepOrange,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===== BAR CHART =====
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade200),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 32,
                      getTitlesWidget: (value, _) =>
                          Text("${value.toInt()}K",
                              style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          '2 am',
                          '4 am',
                          '6 am',
                          '8 am',
                          '10 am',
                          '12 pm',
                          '2 pm',
                          '4 pm',
                          '6 pm',
                          '8 pm',
                          '10 pm',
                          '12 am'
                        ];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            labels[value.toInt() % labels.length],
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: _buildBars(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBars() {
    final purchase = [50, 45, 40, 70, 65, 68, 52, 58, 88, 42, 70, 50];
    final sales = [18, 20, 12, 20, 25, 20, 12, 22, 40, 12, 30, 18];

    return List.generate(12, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: purchase[i].toDouble(),
            width: 16,
            borderRadius: BorderRadius.circular(6),
            rodStackItems: [
              BarChartRodStackItem(
                  0, sales[i].toDouble(), Colors.deepOrange),
              BarChartRodStackItem(
                  sales[i].toDouble(),
                  purchase[i].toDouble(),
                  Colors.orange.shade200),
            ],
          ),
        ],
      );
    });
  }
}

// ===== RANGE TABS (UI ONLY) =====
class _RangeTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: const [
        _RangeChip("1D"),
        _RangeChip("1W"),
        _RangeChip("1M"),
        _RangeChip("3M"),
        _RangeChip("6M"),
        _RangeChip("1Y", selected: true),
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _RangeChip(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : Colors.orange,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ===== METRIC PILL =====
class _MetricPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}


class _ChartLegend extends StatelessWidget {
  final String title;
  final String value;
  const _ChartLegend({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(children: [
        const CircleAvatar(radius: 4, backgroundColor: Colors.orange),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ]),
      ]),
    );
  }
}


// class OverallInfoCard extends StatelessWidget {
//   const OverallInfoCard({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration:
//           BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: const [
//             Icon(Icons.info_outline, color: Colors.blue),
//             SizedBox(width: 8),
//             Text("Overall Information", style: TextStyle(fontWeight: FontWeight.bold)),
//           ]),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               _InfoTile(icon: Icons.store, label: "Suppliers", value: "6987"),
//               _InfoTile(icon: Icons.people, label: "Customer", value: "4896"),
//               _InfoTile(icon: Icons.shopping_cart, label: "Orders", value: "487"),
//             ],
//           ),
//           const Divider(height: 32),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
//             Text("Customers Overview", style: TextStyle(fontWeight: FontWeight.bold)),
//             Icon(Icons.arrow_drop_down), // Placeholder for dropdown
//           ]),
//           const SizedBox(height: 16),
//           Row(children:  [
//             Expanded(child: CustomerDonutChart()),
//             SizedBox(width: 12),
//             Expanded(child: _CustomerStats()),
//           ]),
//         ],
//       ),
//     );
//   }
// }


class OverallInfoCard extends StatelessWidget {
  const OverallInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Overall Information",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===== TOP METRICS =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _InfoTile(icon: Icons.store, label: "Suppliers", value: "6,987"),
              _InfoTile(icon: Icons.people, label: "Customers", value: "4,896"),
              _InfoTile(icon: Icons.shopping_cart, label: "Orders", value: "487"),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),

          const SizedBox(height: 16),

          // ===== CUSTOMERS OVERVIEW =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Customers Overview",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.more_vert, color: Colors.black45),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(child: _CustomerDonut()),
              SizedBox(width: 20),
              Expanded(child: _CustomerStats()),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== INFO TILE =====
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ===== DONUT CHART =====
class _CustomerDonut extends StatelessWidget {
  const _CustomerDonut();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 6,
              centerSpaceRadius: 52,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  value: 55,
                  color: Colors.deepOrange,
                  radius: 22,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 45,
                  color: Colors.teal,
                  radius: 22,
                  showTitle: false,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "9.0K",
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Customers",
                style:
                    TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== CUSTOMER STATS =====
class _CustomerStats extends StatelessWidget {
  const _CustomerStats();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _StatRow(
          value: "5.5K",
          label: "First Time",
          percent: "25%",
          color: Colors.deepOrange,
        ),
        SizedBox(height: 20),
        _StatRow(
          value: "3.5K",
          label: "Returning",
          percent: "21%",
          color: Colors.teal,
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String value;
  final String label;
  final String percent;
  final Color color;

  const _StatRow({
    required this.value,
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.arrow_upward,
                size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              percent,
              style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }
}


// class _InfoTile extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   const _InfoTile({required this.icon, required this.label, required this.value});
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Icon(icon, color: Colors.grey),
//       const SizedBox(height: 6),
//       Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
//       Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//     ]);
//   }
// }
class CustomerDonutChart extends StatelessWidget {
  const CustomerDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text("Customers Overview",
        //     style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          width: 120,
          child: CustomPaint(
            painter: _DonutChartPainter(
              outerPercent: 0.75, // 75% filled
              innerPercent: 0.6,  // 60% filled
              outerColor: Colors.deepOrange,
              innerColor: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }
}
class _DonutChartPainter extends CustomPainter {
  final double outerPercent;
  final double innerPercent;
  final Color outerColor;
  final Color innerColor;

  _DonutChartPainter({
    required this.outerPercent,
    required this.innerPercent,
    required this.outerColor,
    required this.innerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerRadius = size.width / 2;
    final innerRadius = size.width / 3;

    // Base ring (light gray)
    final basePaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Outer ring
    final outerPaint = Paint()
      ..color = outerColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Inner ring
    final innerPaint = Paint()
      ..color = innerColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw base circles
    canvas.drawCircle(center, outerRadius - 6, basePaint);
    canvas.drawCircle(center, innerRadius - 6, basePaint);

    // Draw outer arc
    final outerRect = Rect.fromCircle(center: center, radius: outerRadius - 6);
    canvas.drawArc(
      outerRect,
      -pi / 2,
      2 * pi * outerPercent,
      false,
      outerPaint,
    );

    // Draw inner arc
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius - 6);
    canvas.drawArc(
      innerRect,
      -pi / 2,
      2 * pi * innerPercent,
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// class _CustomerStats extends StatelessWidget {
//   const _CustomerStats();
//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(
//         children: const [
//           Text("5.5K", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           SizedBox(width: 8),
//           Text("First Time", style: TextStyle(color: Colors.orange)),
//         ],
//       ),
//       Row(children: const [Icon(Icons.arrow_upward, size: 16, color: Colors.green), Text("25%")]),
//       const SizedBox(height: 16),
//       Row(
//         children: const [
//           Text("3.5K", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           SizedBox(width: 8),
//           Text("Return", style: TextStyle(color: Colors.teal)),
//         ],
//       ),
//       Row(children: const [Icon(Icons.arrow_upward, size: 16, color: Colors.green), Text("21%")]),
//     ]);
//   }
// }

// ROW 4: Top Selling Products + Low Stock Products
class Row4Section extends StatelessWidget {
  const Row4Section({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1000;
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: TopSellingProductsCard()),
              SizedBox(width: 16),
              Expanded(child: LowStockProductsCard()),
            ],
          )
        : Column(
            children: const [
              TopSellingProductsCard(),
              SizedBox(height: 16),
              LowStockProductsCard(),
            ],
          );
  }
}

// class TopSellingProductsCard extends StatelessWidget {
//   const TopSellingProductsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final products = [
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Charger Cable - Lighting",
//         "price": "\$187",
//         "sales": "247+ Sales",
//         "change": "+25%",
//         "isNegative": false,
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Yves Saint Eau De Parfum",
//         "price": "\$145",
//         "sales": "289+ Sales",
//         "change": "+25%",
//         "isNegative": false,
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Apple Airpods 2",
//         "price": "\$458",
//         "sales": "300+ Sales",
//         "change": "+25%",
//         "isNegative": false,
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Vacuum Cleaner",
//         "price": "\$139",
//         "sales": "225+ Sales",
//         "change": "-21%",
//         "isNegative": true,
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Samsung Galaxy S21 Fe 5g",
//         "price": "\$898",
//         "sales": "365+ Sales",
//         "change": "+25%",
//         "isNegative": false,
//       },
//     ];

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration:
//           BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Row(
//                 children: [
//                   Icon(Icons.inventory_2, color: Colors.pink),
//                   SizedBox(width: 8),
//                   Text("Top Selling Products", style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               Icon(Icons.calendar_today, size: 18, color: Colors.black45),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Product List
//           ...products.map((p) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(p['image']! as String, width: 40, height: 40, fit: BoxFit.cover),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(p['name']! as String, style: const TextStyle(fontWeight: FontWeight.w600)),
//                           Text("${p['price']}  •  ${p['sales']}",
//                               style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: p['isNegative'] as bool ? Colors.red.shade50 : Colors.green.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: p['isNegative'] as bool ? Colors.red : Colors.green,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             p['isNegative'] as bool ? Icons.arrow_downward : Icons.arrow_upward,
//                             size: 14,
//                             color: p['isNegative'] as bool ? Colors.red : Colors.green,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             p['change']! as String,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: p['isNegative'] as bool ? Colors.red : Colors.green,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }

class TopSellingProductsCard extends StatelessWidget {
  const TopSellingProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        "image": "https://via.placeholder.com/48",
        "name": "Charger Cable – Lightning",
        "price": "\$187",
        "sales": "247+ Sales",
        "change": "+25%",
        "isNegative": false,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Yves Saint Eau De Parfum",
        "price": "\$145",
        "sales": "289+ Sales",
        "change": "+25%",
        "isNegative": false,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Apple AirPods 2",
        "price": "\$458",
        "sales": "300+ Sales",
        "change": "+25%",
        "isNegative": false,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Vacuum Cleaner",
        "price": "\$139",
        "sales": "225+ Sales",
        "change": "-21%",
        "isNegative": true,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Samsung Galaxy S21 FE",
        "price": "\$898",
        "sales": "365+ Sales",
        "change": "+25%",
        "isNegative": false,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.inventory_2,
                      color: Colors.pinkAccent),
                  SizedBox(width: 8),
                  Text(
                    "Top Selling Products",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(Icons.more_vert, color: Colors.black45),
            ],
          ),

          const SizedBox(height: 16),

          // ===== PRODUCT LIST =====
          ...products.map((p) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        p["image"] as String,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name + meta
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            p["name"] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${p["price"]} • ${p["sales"]}",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // Trend badge
                    _TrendBadge(
                      value: p["change"] as String,
                      negative: p["isNegative"] as bool,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ===== TREND BADGE =====
class _TrendBadge extends StatelessWidget {
  final String value;
  final bool negative;

  const _TrendBadge({
    required this.value,
    required this.negative,
  });

  @override
  Widget build(BuildContext context) {
    final color = negative ? Colors.red : Colors.green;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            negative ? Icons.arrow_downward : Icons.arrow_upward,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}


// class LowStockProductsCard extends StatelessWidget {
//   const LowStockProductsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final products = [
//       {"image": "https://via.placeholder.com/40", "name": "Dell XPS 13", "id": "#665814", "stock": 6},
//       {"image": "https://via.placeholder.com/40", "name": "Vacuum Cleaner Robot", "id": "#940004", "stock": 14},
//       {"image": "https://via.placeholder.com/40", "name": "KitchenAid Stand Mixer", "id": "#325569", "stock": 21},
//       {"image": "https://via.placeholder.com/40", "name": "Levi's Trucker Jacket", "id": "#124588", "stock": 12},
//       {"image": "https://via.placeholder.com/40", "name": "Lay's Classic", "id": "#365586", "stock": 10},
//     ];

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration:
//           BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Row(
//                 children: [
//                   Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
//                   SizedBox(width: 8),
//                   Text("Low Stock Products", style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               Text("View All", style: TextStyle(color: Colors.blue)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Product List
//           ...products.map((p) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(p['image']! as String, width: 40, height: 40, fit: BoxFit.cover),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(p['name']! as String, style: const TextStyle(fontWeight: FontWeight.w600)),
//                           Text("ID: ${p['id']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         const Text("In Stock", style: TextStyle(fontSize: 12, color: Colors.grey)),
//                         Text("${p['stock']}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }

class LowStockProductsCard extends StatelessWidget {
  const LowStockProductsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        "image": "https://via.placeholder.com/48",
        "name": "Dell XPS 13",
        "id": "#665814",
        "stock": 6,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Vacuum Cleaner Robot",
        "id": "#940004",
        "stock": 14,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "KitchenAid Stand Mixer",
        "id": "#325569",
        "stock": 21,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Levi’s Trucker Jacket",
        "id": "#124588",
        "stock": 12,
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Lay’s Classic",
        "id": "#365586",
        "stock": 10,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    "Low Stock Products",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                "View All",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===== PRODUCT LIST =====
          ...products.map((p) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        p["image"] as String,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name + ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            p["name"] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ID: ${p["id"]}",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // Stock indicator
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${p["stock"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "In Stock",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ROW 5: Recent Sales
// class Row6RecentSales extends StatelessWidget {
//   const Row6RecentSales({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final sales = [
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Apple Watch Series 9",
//         "category": "Electronics",
//         "price": "\$640",
//         "date": "Today",
//         "status": "Processing",
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Gold Bracelet",
//         "category": "Fashion",
//         "price": "\$126",
//         "date": "Today",
//         "status": "Cancelled",
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Parachute Down Duvet",
//         "category": "Health",
//         "price": "\$69",
//         "date": "15 Jan 2025",
//         "status": "Onhold",
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "YETI Rambler Tumbler",
//         "category": "Sports",
//         "price": "\$65",
//         "date": "12 Jan 2025",
//         "status": "Processing",
//       },
//       {
//         "image": "https://via.placeholder.com/40",
//         "name": "Osmo Genius Starter Kit",
//         "category": "Lifestyles",
//         "price": "\$87.56",
//         "date": "11 Jan 2025",
//         "status": "Completed",
//       },
//     ];

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Row(
//                 children: [
//                   Icon(Icons.inventory_2, color: Colors.pink),
//                   SizedBox(width: 8),
//                   Text("Recent Sales", style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.calendar_today, size: 16, color: Colors.black45),
//                   SizedBox(width: 4),
//                   Text("Weekly", style: TextStyle(color: Colors.black54)),
//                 ],
//               )
//             ],
//           ),
//           const SizedBox(height: 16),
//           // List of Sales
//           ...sales.map((s) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   children: [
//                     // Image
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         s["image"]!,
//                         width: 48,
//                         height: 48,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     // Product Info
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(s["name"]!,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w600)),
//                           Text(
//                             "${s["category"]}  •  ${s["price"]}",
//                             style: const TextStyle(
//                                 fontSize: 12, color: Colors.black54),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Date
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(s["date"]!,
//                             style: const TextStyle(
//                                 fontSize: 12, color: Colors.black54)),
//                         const SizedBox(height: 6),
//                         _statusBadge(s["status"]!),
//                       ],
//                     ),
//                   ],
//                 ),
//               ))
//         ],
//       ),
//     );
//   }

//   Widget _statusBadge(String status) {
//     Color bgColor;
//     Color textColor;

//     switch (status) {
//       case "Processing":
//         bgColor = Colors.deepPurple;
//         textColor = Colors.white;
//         break;
//       case "Cancelled":
//         bgColor = Colors.red;
//         textColor = Colors.white;
//         break;
//       case "Onhold":
//         bgColor = Colors.cyan;
//         textColor = Colors.white;
//         break;
//       case "Completed":
//         bgColor = Colors.green;
//         textColor = Colors.white;
//         break;
//       default:
//         bgColor = Colors.grey;
//         textColor = Colors.white;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(color: textColor, fontSize: 12),
//       ),
//     );
//   }
// }

class Row6RecentSales extends StatelessWidget {
  const Row6RecentSales({super.key});

  @override
  Widget build(BuildContext context) {
    final sales = [
      {
        "image": "https://via.placeholder.com/48",
        "name": "Apple Watch Series 9",
        "category": "Electronics",
        "price": "\$640",
        "date": "Today",
        "status": "Processing",
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Gold Bracelet",
        "category": "Fashion",
        "price": "\$126",
        "date": "Today",
        "status": "Cancelled",
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Parachute Down Duvet",
        "category": "Health",
        "price": "\$69",
        "date": "15 Jan 2025",
        "status": "Onhold",
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "YETI Rambler Tumbler",
        "category": "Sports",
        "price": "\$65",
        "date": "12 Jan 2025",
        "status": "Processing",
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Osmo Genius Starter Kit",
        "category": "Lifestyles",
        "price": "\$87.56",
        "date": "11 Jan 2025",
        "status": "Completed",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.receipt_long,
                      color: Colors.pinkAccent),
                  SizedBox(width: 8),
                  Text(
                    "Recent Sales",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Colors.black45),
                  SizedBox(width: 6),
                  Text(
                    "Weekly",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===== SALES LIST =====
          ...sales.map((s) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        s["image"]!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            s["name"]!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${s["category"]} • ${s["price"]}",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // Date + Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          s["date"]!,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45),
                        ),
                        const SizedBox(height: 6),
                        _StatusPill(status: s["status"]!),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ===== STATUS PILL =====
class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case "Processing":
        bg = Colors.deepPurple.shade50;
        fg = Colors.deepPurple;
        break;
      case "Cancelled":
        bg = Colors.red.shade50;
        fg = Colors.red;
        break;
      case "Onhold":
        bg = Colors.cyan.shade50;
        fg = Colors.cyan;
        break;
      case "Completed":
        bg = Colors.green.shade50;
        fg = Colors.green;
        break;
      default:
        bg = Colors.grey.shade200;
        fg = Colors.grey.shade700;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withOpacity(0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}


// ROW 6: Sales Statics + Recent Transactions
class Row5Section extends StatelessWidget {
  const Row5Section({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1000;
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: SalesStaticsCard()),
              SizedBox(width: 16),
              Expanded(child: RecentTransactionsCard()),
            ],
          )
        : Column(
            children: const [
              SalesStaticsCard(),
              SizedBox(height: 16),
              RecentTransactionsCard(),
            ],
          );
  }
}
// SALES STATICS
class SalesStaticsCard extends StatelessWidget {
  const SalesStaticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text("Sales Statics", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.black45),
                  SizedBox(width: 4),
                  Text("2025", style: TextStyle(color: Colors.black54)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          // Stats
          Row(
            children: [
              _StatCard(
                title: "Revenue",
                value: "\$12,189",
                percent: "25%",
                positive: true,
              ),
              const SizedBox(width: 16),
              _StatCard(
                title: "Expense",
                value: "\$48,988,078",
                percent: "25%",
                positive: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bar Chart
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(enabled: false),
                gridData: FlGridData(drawHorizontalLine: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                        ];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(months[value.toInt()], style: const TextStyle(fontSize: 10)),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(12, (i) {
                  final revenue = 10 + (i % 4) * 5;
                  final expense = -10 - (i % 3) * 5;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(toY: revenue.toDouble(), color: Colors.teal, width: 8),
                      BarChartRodData(toY: expense.toDouble(), color: Colors.deepOrange, width: 8),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percent;
  final bool positive;

  const _StatCard({
    required this.title,
    required this.value,
    required this.percent,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF9FAFB),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: positive ? Colors.teal : Colors.red)),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: positive ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    positive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: positive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    percent,
                    style: TextStyle(
                        color: positive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// RECENT TRANSACTIONS
// class RecentTransactionsCard extends StatelessWidget {
//   const RecentTransactionsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final transactions = [
//       {
//         "date": "24 May 2025",
//         "name": "Andrea Willer",
//         "status": "Completed",
//         "amount": "\$4,560",
//         "image": "https://via.placeholder.com/40",
//       },
//       {
//         "date": "23 May 2025",
//         "name": "Timothy Sandsr",
//         "status": "Completed",
//         "amount": "\$3,569",
//         "image": "https://via.placeholder.com/40",
//       },
//       {
//         "date": "22 May 2025",
//         "name": "Bonnie Rodrigues",
//         "status": "Draft",
//         "amount": "\$4,560",
//         "image": "https://via.placeholder.com/40",
//       },
//       {
//         "date": "21 May 2025",
//         "name": "Randy McCree",
//         "status": "Completed",
//         "amount": "\$2,155",
//         "image": "https://via.placeholder.com/40",
//       },
//       {
//         "date": "21 May 2025",
//         "name": "Dennis Anderson",
//         "status": "Completed",
//         "amount": "\$5,123",
//         "image": "https://via.placeholder.com/40",
//       },
//     ];

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration:
//           BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Row(
//                 children: [
//                   Icon(Icons.flag, color: Colors.orangeAccent),
//                   SizedBox(width: 8),
//                   Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               Text("View All", style: TextStyle(color: Colors.blue)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           // Tab Bar (UI only)
//           Container(
//             decoration: BoxDecoration(
//               border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//             ),
//             child: Row(
//               children: const [
//                 _TabChip(label: "Sale", selected: true),
//                 _TabChip(label: "Purchase"),
//                 _TabChip(label: "Quotation"),
//                 _TabChip(label: "Expenses"),
//                 _TabChip(label: "Invoices"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Table Header
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Row(
//               children: const [
//                 Expanded(flex: 2, child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(flex: 3, child: Text("Customer", style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
//                 Expanded(flex: 1, child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
//               ],
//             ),
//           ),
//           const Divider(),
//           // Table Rows
//           ...transactions.map((tx) {
//             final isDraft = tx['status'] == 'Draft';
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Row(
//                 children: [
//                   Expanded(flex: 2, child: Text(tx['date']!)),
//                   Expanded(
//                     flex: 3,
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: NetworkImage(tx['image']!),
//                           radius: 16,
//                         ),
//                         const SizedBox(width: 8),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(tx['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
//                             const Text("#114589", style: TextStyle(color: Colors.deepOrange)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: isDraft ? Colors.pink.shade100 : Colors.green.shade100,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         tx['status']!,
//                         style: TextStyle(
//                           color: isDraft ? Colors.pink.shade800 : Colors.green.shade800,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(flex: 1, child: Text(tx['amount']!, style: const TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

class RecentTransactionsCard extends StatelessWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        "date": "24 May 2025",
        "name": "Andrea Willer",
        "status": "Completed",
        "amount": "\$4,560",
        "image": "https://via.placeholder.com/40",
      },
      {
        "date": "23 May 2025",
        "name": "Timothy Sandsr",
        "status": "Completed",
        "amount": "\$3,569",
        "image": "https://via.placeholder.com/40",
      },
      {
        "date": "22 May 2025",
        "name": "Bonnie Rodrigues",
        "status": "Draft",
        "amount": "\$4,560",
        "image": "https://via.placeholder.com/40",
      },
      {
        "date": "21 May 2025",
        "name": "Randy McCree",
        "status": "Completed",
        "amount": "\$2,155",
        "image": "https://via.placeholder.com/40",
      },
      {
        "date": "21 May 2025",
        "name": "Dennis Anderson",
        "status": "Completed",
        "amount": "\$5,123",
        "image": "https://via.placeholder.com/40",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.flag, color: Colors.orangeAccent),
                  SizedBox(width: 8),
                  Text(
                    "Recent Transactions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                "View All",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===== TAB STRIP (UI ONLY) =====
          const _TransactionTabs(),

          const SizedBox(height: 12),

          // ===== TABLE HEADER =====
          _TableHeader(),

          const Divider(height: 24),

          // ===== TABLE ROWS =====
          ...transactions.map((tx) => _TableRow(tx: tx)),
        ],
      ),
    );
  }
}

// ================== TABS ==================
class _TransactionTabs extends StatelessWidget {
  const _TransactionTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _TabItem(label: "Sale", selected: true),
        _TabItem(label: "Purchase"),
        _TabItem(label: "Quotation"),
        _TabItem(label: "Expenses"),
        _TabItem(label: "Invoices"),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabItem({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: selected ? Colors.orange : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          if (selected)
            Container(
              height: 2,
              width: 24,
              color: Colors.orange,
            ),
        ],
      ),
    );
  }
}

// ================== HEADER ==================
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
            flex: 2,
            child: Text("Date",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13))),
        Expanded(
            flex: 4,
            child: Text("Customer",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13))),
        Expanded(
            flex: 2,
            child: Text("Status",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13))),
        Expanded(
            flex: 1,
            child: Text("Total",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13))),
      ],
    );
  }
}

// ================== ROW ==================
class _TableRow extends StatelessWidget {
  final Map<String, String> tx;

  const _TableRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isDraft = tx["status"] == "Draft";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Date
          Expanded(
            flex: 2,
            child: Text(
              tx["date"]!,
              style: const TextStyle(fontSize: 13),
            ),
          ),

          // Customer
          Expanded(
            flex: 4,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(tx["image"]!),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Customer Name",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "#114589",
                      style: TextStyle(
                          fontSize: 11, color: Colors.deepOrange),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status
          Expanded(
            flex: 2,
            child: _StatusChip(
              label: tx["status"]!,
              draft: isDraft,
            ),
          ),

          // Amount
          Expanded(
            flex: 1,
            child: Text(
              tx["amount"]!,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== STATUS CHIP ==================
class _StatusChip extends StatelessWidget {
  final String label;
  final bool draft;

  const _StatusChip({
    required this.label,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    final bg = draft ? Colors.pink.shade50 : Colors.green.shade50;
    final fg = draft ? Colors.pink.shade800 : Colors.green.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _TabChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.orange : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (selected)
            Container(height: 2, width: 20, color: Colors.orange)
        ],
      ),
    );
  }
}

// ROW 7: Top Customers & Top Categories
class Row7TopCustomersAndCategories extends StatelessWidget {
  const Row7TopCustomersAndCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1000;
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: TopCustomersCard()),
              SizedBox(width: 16),
              Expanded(child: TopCategoriesCard()),
            ],
          )
        : Column(
            children: const [
              TopCustomersCard(),
              SizedBox(height: 16),
              TopCategoriesCard(),
            ],
          );
  }
}
// ------------------ TOP CUSTOMERS ------------------
class TopCustomersCard extends StatelessWidget {
  const TopCustomersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = [
      {
        "image": "https://via.placeholder.com/48",
        "name": "Carlos Curran",
        "location": "USA",
        "orders": "24 Orders",
        "amount": "\$8,9645"
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Stan Gaunter",
        "location": "UAE",
        "orders": "22 Orders",
        "amount": "\$16,985"
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Richard Wilson",
        "location": "Germany",
        "orders": "14 Orders",
        "amount": "\$5,366"
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Mary Bronson",
        "location": "Belgium",
        "orders": "08 Orders",
        "amount": "\$4,569"
      },
      {
        "image": "https://via.placeholder.com/48",
        "name": "Annie Tremblay",
        "location": "Greenland",
        "orders": "14 Orders",
        "amount": "\$3,5698"
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.deepOrangeAccent),
                  SizedBox(width: 8),
                  Text("Top Customers", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Text("View All", style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 16),
          // Customer list
          ...customers.map((c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(c["image"]!),
                      radius: 24,
                    ),
                    const SizedBox(width: 12),
                    // Customer info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c["name"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 14, color: Colors.black45),
                              const SizedBox(width: 4),
                              Text(c["location"]!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                              const SizedBox(width: 6),
                              const Text("•",
                                  style: TextStyle(color: Colors.black45)),
                              const SizedBox(width: 6),
                              Text(c["orders"]!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Text(c["amount"]!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
// ------------------ TOP CATEGORIES ------------------
class TopCategoriesCard extends StatelessWidget {
  const TopCategoriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryData = [
      {"title": "Electronics", "sales": 698, "color": Colors.orange},
      {"title": "Sports", "sales": 545, "color": Colors.deepOrange},
      {"title": "Lifestyles", "sales": 456, "color": Colors.indigo},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.category, color: Colors.deepOrangeAccent),
                  SizedBox(width: 8),
                  Text("Top Categories",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.black45),
                  SizedBox(width: 4),
                  Text("Weekly", style: TextStyle(color: Colors.black54)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          // Donut Chart + Legend
          Row(
            children: [
              // Donut Chart
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: categoryData
                          .map((c) => PieChartSectionData(
                                color: c['color'] as Color,
                                value: (c['sales'] as int).toDouble(),
                                showTitle: false,
                                radius: 40,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Legend
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryData
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: c['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                c["title"]! as String,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              const Spacer(),
                              Text("${c["sales"]} Sales",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Category Statistics",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: const [
                _CategoryStatRow(
                  iconColor: Colors.deepPurple,
                  label: "Total Number Of Categories",
                  value: "698",
                ),
                SizedBox(height: 12),
                _CategoryStatRow(
                  iconColor: Colors.deepOrange,
                  label: "Total Number Of Products",
                  value: "7899",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class _CategoryStatRow extends StatelessWidget {
  final Color iconColor;
  final String label;
  final String value;

  const _CategoryStatRow(
      {required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ROW 8: Order Statistics – Heatmap View
class Row8OrderStatistics extends StatelessWidget {
  const Row8OrderStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final hours = [
      "2 Am", "4 Am", "6 Am", "8 Am", "10 Am", "12 Am",
      "14 Pm", "16 Pm", "18 Am"
    ];

    final activeSlots = {
      "Mon-2 Am", "Mon-4 Am", "Mon-10 Am",
      "Tue-2 Am", "Tue-4 Am", "Tue-10 Am",
      "Wed-2 Am", "Wed-4 Am", "Wed-10 Am",
      "Thu-2 Am", "Thu-4 Am",
      "Fri-16 Pm",
      "Sat-8 Am", "Sat-18 Am",
      "Sun-18 Am",
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.widgets, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text("Order Statistics", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.black45),
                  SizedBox(width: 4),
                  Text("Weekly", style: TextStyle(color: Colors.black54)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Heatmap Grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: hours.map((hour) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 60,
                          child: Text(hour, style: const TextStyle(fontSize: 12))),
                      ...days.map((day) {
                        final key = "$day-$hour";
                        final isActive = activeSlots.contains(key);
                        return Container(
                          margin: const EdgeInsets.all(2),
                          width: 40,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.orange
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


// FOOTER
class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Text("© 2025 • Designed & Developed by Dreamguys", style: TextStyle(color: Colors.grey)),
    );
  }
}
