import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/invoice.dart';
import '../providers/app_provider.dart';
import '../utils/app_keys.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    // Simple dynamic calculation
    double totalRevenue = provider.invoices.where((i) => i.status == InvoiceStatus.paid).fold(0, (sum, item) => sum + item.amount);
    double totalExpenses = provider.transactions.fold(0, (sum, item) => sum + item.amount);
    double netProfit = totalRevenue - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sort_rounded, size: 28, color: Colors.black87),
          onPressed: () => AppKeys.mainScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Statistics', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF34A853), Color(0xFF2E8B57)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34A853).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Net Profit', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('${provider.currency} ${netProfit.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _smallStat('${provider.currency}${totalRevenue.toStringAsFixed(0)}', 'Revenue'),
                      const SizedBox(width: 24),
                      _smallStat('${provider.currency}${totalExpenses.toStringAsFixed(0)}', 'Expenses'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Revenue Stream', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('Month')),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _chartBar(0.4, 'Jan'),
                  _chartBar(0.7, 'Feb'),
                  _chartBar(0.5, 'Mar'),
                  _chartBar(0.9, 'Apr', active: true),
                  _chartBar(0.6, 'May'),
                  _chartBar(0.8, 'Jun'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _categoryItem('Services', 65, const Color(0xFF34A853)),
            _categoryItem('Products', 25, const Color(0xFFFBBC04)),
            _categoryItem('Others', 10, const Color(0xFFEA4335)),
          ],
        ),
      ),
    );
  }

  Widget _smallStat(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }

  Widget _chartBar(double height, String label, {bool active = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 35,
          height: 150 * height,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF34A853) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: active ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null,
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _categoryItem(String label, int percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('$percent%', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
