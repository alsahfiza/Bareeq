import 'package:flutter/material.dart';

import 'widgets/dashboard_kpi_grid.dart';
import 'widgets/sales_purchase_chart.dart';
import 'widgets/sales_statistics_chart.dart';
import 'widgets/profit_chart.dart';
import 'widgets/category_donut.dart';
import 'widgets/customer_donut.dart';
import 'widgets/top_selling_products.dart';
import 'widgets/low_stock_products.dart';
import 'widgets/recent_sales.dart';
import 'widgets/recent_transactions_table.dart';
import 'widgets/order_heatmap.dart';
import 'widgets/top_products.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const double _pagePadding = 24;
  static const double _sectionGap = 24;
  static const double _cardGap = 16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 1200;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(_pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),

              const DashboardKpiGrid(),
              const SizedBox(height: _sectionGap),

              _salesAndProfit(isDesktop),
              const SizedBox(height: _sectionGap),

              _row(
                isDesktop,
                left: const SalesStatisticsChart(),
                right: _column(
                  const CategoryDonut(),
                  const SizedBox(height: _cardGap),
                  const CustomerDonut(),
                ),
                leftFlex: 3,
                rightFlex: 2,
              ),
              const SizedBox(height: _sectionGap),

              _row(
                isDesktop,
                left: const TopSellingProducts(),
                right: const LowStockProducts(),
              ),
              const SizedBox(height: _sectionGap),

              _row(
                isDesktop,
                left: const RecentSales(),
                right: const RecentTransactionsTable(),
                leftFlex: 2,
                rightFlex: 3,
              ),
              const SizedBox(height: _sectionGap),

              _row(
                isDesktop,
                left: const OrderHeatmap(),
                right: const TopProducts(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Overview of your business performance',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // ================= SALES + PROFIT (FIXED) =================

  Widget _salesAndProfit(bool isDesktop) {
    if (!isDesktop) {
      return Column(
        children: const [
          SalesPurchaseChart(),
          SizedBox(height: 16),
          ProfitChart(),
        ],
      );
    }

    return Stack(
      children: [
        Row(
          children: const [
            Expanded(
              flex: 4,
              child: SalesPurchaseChart(),
            ),
            SizedBox(width: 120),
          ],
        ),
        const Positioned(
          right: 0,
          top: 24,
          child: SizedBox(
            width: 280,
            child: ProfitChart(),
          ),
        ),
      ],
    );
  }

  // ================= LAYOUT HELPERS =================

  Widget _row(
    bool isDesktop, {
    required Widget left,
    required Widget right,
    int leftFlex = 1,
    int rightFlex = 1,
  }) {
    if (!isDesktop) {
      return Column(
        children: [
          left,
          const SizedBox(height: _cardGap),
          right,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: leftFlex, child: left),
        const SizedBox(width: _cardGap),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }

  Widget _column(Widget a, Widget b, Widget c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [a, b, c],
    );
  }
}