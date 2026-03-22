import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../screens/clients_screen.dart';
import '../screens/items_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showCurrencyPicker(BuildContext context) {
    final provider = context.read<AppProvider>();
    final List<String> currencies = ['\$', '€', '£', '¥', '₹', 'Rp'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Currency'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final cur = currencies[index];
                return ListTile(
                  title: Text(cur),
                  trailing: provider.currency == cur ? const Icon(Icons.check, color: Color(0xFF34A853)) : null,
                  onTap: () {
                    provider.setCurrency(cur);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Simplified Header
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.account_balance_wallet_rounded, size: 50, color: Color(0xFF34A853)),
                   const SizedBox(height: 10),
                   const Text(
                    'E-Invoice',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1B2430)),
                  ),
                ],
              ),
            ),
          ),
          
          // Drawer Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildDrawerItem(
                  Icons.people_outline, 
                  'Clients', 
                  count: provider.clients.length.toString().padLeft(2, '0'),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientsScreen()));
                  },
                ),
                _buildDrawerItem(
                  Icons.inventory_2_outlined, 
                  'Items', 
                  count: provider.masterItems.length.toString().padLeft(2, '0'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemsScreen()));
                  },
                ),
                _buildDrawerItem(Icons.bar_chart_outlined, 'Report'),
                _buildDrawerItem(Icons.picture_as_pdf_outlined, 'PDF Invoices'),
                _buildDrawerItem(
                  Icons.monetization_on_outlined, 
                  'Currency', 
                  value: provider.currency,
                  onTap: () => _showCurrencyPicker(context),
                ),
                _buildDrawerItem(Icons.business_outlined, 'Business info'),
                _buildDrawerItem(Icons.description_outlined, 'Terms & Conditions'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {String? count, String? value, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.black87),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (count != null)
                Text(
                  '($count) ',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              if (value != null)
                Text(
                  '$value ',
                  style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}
