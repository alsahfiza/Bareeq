// import 'package:flutter/material.dart';

// // KPI
// import 'widgets/dashboard_kpi_card.dart';
// import 'widgets/dashboard_kpi_grid.dart';
// import 'widgets/dashboard_kpi_summary_card.dart';

// // Row 3
// import 'widgets/sales_purchase_panel.dart';
// import 'widgets/overall_information_panel.dart';

// // Row 4
// import 'widgets/top_selling_panel.dart';
// import 'widgets/low_stock_panel.dart';
// import 'widgets/recent_sales_panel.dart';

// // Row 5
// import 'widgets/sales_statistics_panel.dart';
// import 'widgets/recent_transactions_panel.dart';

// // Row 6
// import 'widgets/top_customers_panel.dart';
// import 'widgets/top_categories_panel.dart';
// import 'widgets/order_statistics_panel.dart';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});

//   static const double _gap = 16;

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final bool isDesktop = width >= 1200;
//     final bool isTablet = width >= 768 && width < 1200;
//     final bool isMobile = width < 768;

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // ───────────────── ROW 1 ─────────────────
//             _row(
//               isDesktop: isDesktop,
//               isTablet: isTablet,
//               isMobile: isMobile,
//               children: [
//                 DashboardKpiGrid(
//                   children: const [
//                     DashboardKpiCard(
//                       title: 'Total Sales',
//                       value: '\$48,988,078',
//                       trend: '+2.3%',
//                       icon: Icons.receipt_long,
//                       background: Color(0xFFFFA44C),
//                       trendBg: Color(0x33FFFFFF),
//                       iconBg: Color(0x33FFFFFF),
//                     ),
//                     DashboardKpiCard(
//                       title: 'Total Sales Return',
//                       value: '\$16,478,145',
//                       trend: '-2.2%',
//                       icon: Icons.undo,
//                       background: Color(0xFF0B2A4A),
//                       trendBg: Color(0x33FFFFFF),
//                       iconBg: Color(0x33FFFFFF),
//                     ),
//                     DashboardKpiCard(
//                       title: 'Total Purchase',
//                       value: '\$24,145,789',
//                       trend: '+1.7%',
//                       icon: Icons.shopping_bag,
//                       background: Color(0xFF16A085),
//                       trendBg: Color(0x33FFFFFF),
//                       iconBg: Color(0x33FFFFFF),
//                     ),
//                     DashboardKpiCard(
//                       title: 'Total Purchase Return',
//                       value: '\$18,458,747',
//                       trend: '+2.1%',
//                       icon: Icons.keyboard_return,
//                       background: Color(0xFF2563EB),
//                       trendBg: Color(0x33FFFFFF),
//                       iconBg: Color(0x33FFFFFF),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: _gap),

//             // ───────────────── ROW 2 ─────────────────
//             _row(
//               isDesktop: isDesktop,
//               isTablet: isTablet,
//               isMobile: isMobile,
//               children: const [
//                 DashboardKpiSummaryCard(
//                   title: 'Profit',
//                   value: '\$8,458,798',
//                   delta: '+35%',
//                   isPositive: true,
//                   icon: Icons.trending_up,
//                   iconBg: Color(0xFFE9F7F3),
//                   iconColor: Color(0xFF16A085),
//                   ),
//                 DashboardKpiSummaryCard(
//                   title: 'Invoice Due',
//                   value: '\$48,988.78',
//                   delta: '+35%',
//                   isPositive: true,
//                   icon: Icons.receipt,
//                   iconBg: Color(0xFFEFF3FF),
//                   iconColor: Color(0xFF2563EB),
//                   ),
                  
//                 DashboardKpiSummaryCard(
//                   title: 'Total Expenses',
//                   value: '\$8,980,097',
//                   delta: '+41%',
//                   isPositive: true,
//                   icon: Icons.account_balance_wallet,
//                   iconBg: Color(0xFFFFF3E9),
//                   iconColor: Color(0xFFFF8A00),
//                   ),
//                 DashboardKpiSummaryCard(
//                   title: 'Total Payment Returns',
//                   value: '\$78,458,798',
//                   delta: '-20%',
//                   isPositive: false,
//                   icon: Icons.keyboard_return,
//                   iconBg: Color(0xFFFFECEC),
//                   iconColor: Color(0xFFE4572E),
//                   ),
//               ],
//             ),

//             const SizedBox(height: _gap),

//             // ───────────────── ROW 3 ─────────────────
//             _row(
//               isDesktop: isDesktop,
//               isTablet: isTablet,
//               isMobile: isMobile,
//               ratios: const [8, 4],
//               children: const [
//                 SalesPurchasePanel(),
//                 OverallInformationPanel(),
//               ],
//             ),

//             const SizedBox(height: _gap),

//             // ───────────────── ROW 4 ─────────────────
//             _row(
//               isDesktop: isDesktop,
//               isTablet: isTablet,
//               isMobile: isMobile,
//               children: const [
//                 TopSellingPanel(),
//                 LowStockPanel(),
//                 RecentSalesPanel(),
//               ],
//             ),

//             const SizedBox(height: _gap),

//             // ───────────────── ROW 5 ─────────────────
//             _row(
//               isDesktop: isDesktop,
//               isTablet: isTablet,
//               isMobile: isMobile,
//               ratios: const [6, 6],
//               children: const [
//                 SalesStatisticsPanel(),
//                 RecentTransactionsPanel(),
//               ],
//             ),

//             const SizedBox(height: _gap),

//             // ───────────────── ROW 6 ─────────────────
//             _row(
//               isDesktop: isDesktop,
//               isTablet: isTablet,
//               isMobile: isMobile,
//               children: const [
//                 TopCustomersPanel(),
//                 TopCategoriesPanel(),
//                 OrderStatisticsPanel(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ───────────────── GRID ENGINE ─────────────────

//   Widget _row({
//     required bool isDesktop,
//     required bool isTablet,
//     required bool isMobile,
//     required List<Widget> children,
//     List<int>? ratios,
//   }) {
//     if (!isDesktop) {
//       return Column(
//         children: children
//             .map((w) => Padding(
//                   padding: const EdgeInsets.only(bottom: _gap),
//                   child: w,
//                 ))
//             .toList(),
//       );
//     }

//     final resolvedRatios =
//         ratios ?? List.generate(children.length, (_) => 12 ~/ children.length);

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(children.length, (i) {
//         return Expanded(
//           flex: resolvedRatios[i],
//           child: Padding(
//             padding: EdgeInsets.only(
//               right: i == children.length - 1 ? 0 : _gap,
//             ),
//             child: children[i],
//           ),
//         );
//       }),
//     );
//   }
// }

// class _MobileKpiWrapper extends StatelessWidget {
//   final Widget child;
//   const _MobileKpiWrapper({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 16),
//       child: SizedBox(
//         width: 280,
//         child: child,
//       ),
//     );
//   }
// }

// main.dart DashboardPage
// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

// MAIN DASHBOARD
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // KPI CARDS
            Wrap(spacing: 16, runSpacing: 16, children: const [
              KPICard(title: "Total Sales", value: "\$48,988,078", color: Colors.orange, icon: Icons.shopping_cart),
              KPICard(title: "Total Sales Return", value: "\$16,478,145", color: Colors.indigo, icon: Icons.undo),
              KPICard(title: "Total Purchase", value: "\$24,145,789", color: Colors.teal, icon: Icons.local_mall),
              KPICard(title: "Total Purchase Return", value: "\$18,458,747", color: Colors.blue, icon: Icons.reply),
            ]),
            const SizedBox(height: 24),
            // STAT CARDS
            Wrap(spacing: 16, runSpacing: 16, children: const [
              StatCard(title: "Profit", amount: "\$8,458,798", percent: "+35%", icon: Icons.trending_up),
              StatCard(title: "Invoice Due", amount: "\$48,988.78", percent: "+35%", icon: Icons.receipt),
              StatCard(title: "Total Expenses", amount: "\$8,980,097", percent: "+15%", icon: Icons.money_off),
              StatCard(title: "Total Returns", amount: "\$78,458,798", percent: "-10%", icon: Icons.refresh),
            ]),
            const SizedBox(height: 24),
            // SALES + DONUT
            isWideScreen
                ? Row(children: const [
                    Expanded(child: SalesChartCard()),
                    SizedBox(width: 16),
                    Expanded(child: CustomerDonutChart()),
                  ])
                : Column(children: const [
                    SalesChartCard(),
                    SizedBox(height: 16),
                    CustomerDonutChart(),
                  ]),
            const SizedBox(height: 24),
            // PRODUCT SECTIONS
            Wrap(spacing: 16, runSpacing: 16, children: const [
              ProductListCard(title: "Top Selling Products", items: ["Cougar Cable", "iPhone 14", "Vacuum Cleaner"]),
              ProductListCard(title: "Low Stock Products", items: ["PS5", "Reebok Shoes", "Rice 1kg"]),
              ProductListCard(title: "Recent Sales", items: ["Apple Watch", "Gold Bracelet", "Sofa"]),
            ]),
            const SizedBox(height: 24),
            // SALES + TRANSACTIONS
            isWideScreen
                ? Row(children: const [
                    Expanded(child: SalesBarChartCard()),
                    SizedBox(width: 16),
                    Expanded(child: TransactionCard()),
                  ])
                : Column(children: const [
                    SalesBarChartCard(),
                    SizedBox(height: 16),
                    TransactionCard(),
                  ]),
            const SizedBox(height: 24),
            // CUSTOMERS, CATEGORIES, HEATMAP
            Wrap(spacing: 16, runSpacing: 16, children: const [
              BoxCard(title: "Top Customers", content: "Carlos Gomez Richard Wilson Henry Bronson"),
              PieChartCard(),
              HeatmapCard(),
            ]),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

// ===== COMPONENTS BELOW: KPI Card, Stat Card, Product List, Chart, etc.

class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  const KPICard({super.key, required this.title, required this.value, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ])),
        ]),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title, amount, percent;
  final IconData icon;
  const StatCard({super.key, required this.title, required this.amount, required this.percent, required this.icon});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(height: 16),
          Text(amount, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("vs Last Month $percent", style: const TextStyle(color: Colors.green)),
            Text("View All", style: TextStyle(color: Colors.blue[700], fontSize: 13)),
          ]),
        ]),
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

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: const Center(child: Text("Line/Bar Chart Placeholder")),
    );
  }
}

class CustomerDonutChart extends StatelessWidget {
  const CustomerDonutChart({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Customer Overview", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: PieChart(
              PieChartData(centerSpaceRadius: 40, sections: [
                PieChartSectionData(value: 55, title: "5.5K", color: Colors.green, radius: 50),
                PieChartSectionData(value: 35, title: "3.5K", color: Colors.orange, radius: 50),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class SalesBarChartCard extends StatelessWidget {
  const SalesBarChartCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          barGroups: List.generate(6, (i) {
            return BarChartGroupData(x: i, barRods: [
              BarChartRodData(toY: (5 + i).toDouble(), color: Colors.orange),
              BarChartRodData(toY: (3 + i).toDouble(), color: Colors.blue),
            ]);
          }),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Invoice from Alice – \$4,560"),
          Text("• Quote to Bob – \$3,500"),
          Text("• Purchase by John – \$5,000"),
        ],
      ),
    );
  }
}

class BoxCard extends StatelessWidget {
  final String title;
  final String content;
  const BoxCard({super.key, required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(content),
        ]),
      ),
    );
  }
}

class PieChartCard extends StatelessWidget {
  const PieChartCard({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Top Categories", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: PieChart(
                PieChartData(centerSpaceRadius: 30, sections: [
                  PieChartSectionData(value: 40, color: Colors.orange, title: "Electronics"),
                  PieChartSectionData(value: 30, color: Colors.blue, title: "Fashion"),
                  PieChartSectionData(value: 30, color: Colors.green, title: "Lifestyle"),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeatmapCard extends StatelessWidget {
  const HeatmapCard({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Statistics", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(child: Text("Heatmap Grid Placeholder")),
          ],
        ),
      ),
    );
  }
}

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
