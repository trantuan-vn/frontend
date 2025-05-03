import 'package:flutter/material.dart';
import 'package:smartconsultor/features/dashboard/presentation/widgets/trading_view_chart.dart';
import '../widgets/sidebar.dart';
import '../widgets/header.dart';
import '../widgets/overview_cards.dart';
import '../widgets/income_chart.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/account_overview_chart.dart';
import '../widgets/saving_growth_chart.dart';

class Dashboard extends StatelessWidget {
  static const DASHBOARD_ROUTE = '/dashboard';

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final screenHeight = MediaQuery.of(context).size.height;

    // Tỷ lệ chiều cao linh hoạt
    final incomeSectionHeight = screenHeight * 0.35;
    final overviewChartHeight = screenHeight * 0.25;
    final tradingViewHeight = screenHeight * 0.45;

    return Scaffold(
      body: isMobile
          ? const Center(child: Text("Mobile view coming soon"))
          : Row(
              children: [
                const Sidebar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Header(),
                            const SizedBox(height: 20),

                            Divider(
                              color: Colors.grey.withOpacity(0.3),
                              thickness: 1,
                            ),
                            const SizedBox(height: 16),
                            const OverviewCards(),
                            const SizedBox(height: 20),

                            // Biểu đồ thu nhập và giao dịch gần đây
                            SizedBox(
                              height: incomeSectionHeight,
                              child: const Row(
                                children: [
                                  Expanded(child: IncomeChart()),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: RecentTransactions(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Biểu đồ tài khoản và tiết kiệm
                            SizedBox(
                              height: overviewChartHeight,
                              child: const Row(
                                children: [
                                  Expanded(child: AccountOverviewChart()),
                                  SizedBox(width: 20),
                                  Expanded(child: SavingGrowthChart()),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // TradingView chart
                            SizedBox(
                              height: tradingViewHeight,
                              child: const TradingViewWidget(
                                symbol: 'BINANCE:BTCUSDT',
                                interval: 'D',
                                theme: 'dark',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
