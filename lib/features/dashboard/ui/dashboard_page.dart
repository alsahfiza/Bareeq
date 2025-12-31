import 'package:flutter/material.dart';

// KPI
import 'widgets/dashboard_kpi_card.dart';
import 'widgets/dashboard_kpi_grid.dart';
import 'widgets/dashboard_kpi_summary_card.dart';

// Row 3
import 'widgets/sales_purchase_panel.dart';
import 'widgets/overall_information_panel.dart';

// Row 4
import 'widgets/top_selling_panel.dart';
import 'widgets/low_stock_panel.dart';
import 'widgets/recent_sales_panel.dart';

// Row 5
import 'widgets/sales_statistics_panel.dart';
import 'widgets/recent_transactions_panel.dart';

// Row 6
import 'widgets/top_customers_panel.dart';
import 'widgets/top_categories_panel.dart';
import 'widgets/order_statistics_panel.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const double _gap = 16;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1200;
    final bool isTablet = width >= 768 && width < 1200;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ───────────────── ROW 1 ─────────────────
            _row(
              isDesktop: isDesktop,
              isTablet: isTablet,
              Dchildren: [
                DashboardKpiGrid(
                  children: const [
                    DashboardKpiCard(
                      title: 'Total Sales',
                      value: '\$48,988,078',
                      trend: '+2.3%',
                      icon: Icons.receipt_long,
                      background: Color(0xFFFFA44C),
                      trendBg: Color(0x33FFFFFF),
                      iconBg: Color(0x33FFFFFF),
                    ),
                    DashboardKpiCard(
                      title: 'Total Sales Return',
                      value: '\$16,478,145',
                      trend: '-2.2%',
                      icon: Icons.undo,
                      background: Color(0xFF0B2A4A),
                      trendBg: Color(0x33FFFFFF),
                      iconBg: Color(0x33FFFFFF),
                    ),
                    DashboardKpiCard(
                      title: 'Total Purchase',
                      value: '\$24,145,789',
                      trend: '+1.7%',
                      icon: Icons.shopping_bag,
                      background: Color(0xFF16A085),
                      trendBg: Color(0x33FFFFFF),
                      iconBg: Color(0x33FFFFFF),
                    ),
                    DashboardKpiCard(
                      title: 'Total Purchase Return',
                      value: '\$18,458,747',
                      trend: '+2.1%',
                      icon: Icons.keyboard_return,
                      background: Color(0xFF2563EB),
                      trendBg: Color(0x33FFFFFF),
                      iconBg: Color(0x33FFFFFF),
                    ),
                  ],
                ),

              ],
            ),

            const SizedBox(height: _gap),

            // ───────────────── ROW 2 ─────────────────
            _row(
              isDesktop: isDesktop,
              isTablet: isTablet,
              children: const [
                DashboardKpiSummaryCardGrid(),
              ],
            ),

            const SizedBox(height: _gap),

            // ───────────────── ROW 3 ─────────────────
            _row(
              isDesktop: isDesktop,
              isTablet: isTablet,
              ratios: const [8, 4],
              children: const [
                SalesPurchasePanel(),
                OverallInformationPanel(),
              ],
            ),

            const SizedBox(height: _gap),

            // ───────────────── ROW 4 ─────────────────
            _row(
              isDesktop: isDesktop,
              isTablet: isTablet,
              children: const [
                TopSellingPanel(),
                LowStockPanel(),
                RecentSalesPanel(),
              ],
            ),

            const SizedBox(height: _gap),

            // ───────────────── ROW 5 ─────────────────
            _row(
              isDesktop: isDesktop,
              isTablet: isTablet,
              ratios: const [6, 6],
              children: const [
                SalesStatisticsPanel(),
                RecentTransactionsPanel(),
              ],
            ),

            const SizedBox(height: _gap),

            // ───────────────── ROW 6 ─────────────────
            _row(
              isDesktop: isDesktop,
              isTablet: isTablet,
              children: const [
                TopCustomersPanel(),
                TopCategoriesPanel(),
                OrderStatisticsPanel(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── GRID ENGINE ─────────────────

  Widget _row({
    required bool isDesktop,
    required bool isTablet,
    required List<Widget> children,
    List<int>? ratios,
  }) {
    if (!isDesktop) {
      return Column(
        children: children
            .map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: _gap),
                  child: w,
                ))
            .toList(),
      );
    }

    final resolvedRatios =
        ratios ?? List.generate(children.length, (_) => 12 ~/ children.length);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.length, (i) {
        return Expanded(
          flex: resolvedRatios[i],
          child: Padding(
            padding: EdgeInsets.only(
              right: i == children.length - 1 ? 0 : _gap,
            ),
            child: children[i],
          ),
        );
      }),
    );
  }
}