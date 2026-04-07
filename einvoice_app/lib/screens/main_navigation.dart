import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'send_money_screen.dart';
import 'create_invoice_screen.dart';
import 'items_screen.dart';
import '../widgets/app_drawer.dart';
import '../utils/app_keys.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(onProfileTap: () => setState(() => _currentIndex = 4)), // Now navigates to Items
      const SendMoneyScreen(),
      const SizedBox.shrink(), // FAB Placeholder
      const ReportsScreen(),
      const ItemsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AppKeys.mainScaffoldKey,
      drawer: const AppDrawer(),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: const Color(0xFF34A853),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateInvoiceScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != 2) setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 20,
          selectedItemColor: const Color(0xFF34A853),
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 26), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded, size: 26), label: 'Wallets'),
            BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.transparent), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart_rounded, size: 26), label: 'Reports'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded, size: 26), label: 'Items'),
          ],
        ),
      ),
    );
  }
}
