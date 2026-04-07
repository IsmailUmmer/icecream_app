import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/invoice.dart';
import 'add_items_screen.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9), // Light grey background like home screen
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Items', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Quick Links Section
              _buildQuickLinks(),
              const SizedBox(height: 24),
              
              // Items List
              ...provider.masterItems.map((item) => _buildItemCard(context, provider, item)).toList(),
              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
          
          // Add New Item Button
          Positioned(
            bottom: 30,
            left: 100,
            right: 100,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddItemsScreen()),
                );
                if (result != null && result is InvoiceItemModel) {
                  provider.addMasterItem(result);
                }
              },
              icon: const Icon(Icons.inventory_2_outlined, size: 20),
              label: const Text('Add New Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34A853), // Green like home screen
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinks() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Links', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickLinkItem(Icons.storefront_outlined, 'Online Store'),
              _buildQuickLinkItem(Icons.inventory_2_outlined, 'Stock Summary'),
              _buildQuickLinkItem(Icons.settings_outlined, 'Item Settings'),
              _buildQuickLinkItem(Icons.chevron_right, 'Show All'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF34A853).withOpacity(0.1), // Light green background for icons
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF34A853), size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label.length > 11 ? label.substring(0, 10) + '...' : label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF53616F)),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, AppProvider provider, InvoiceItemModel item) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddItemsScreen(item: item)),
        );
        if (result != null && result is InvoiceItemModel) {
          provider.updateMasterItem(result);
        }
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Item?'),
            content: Text('Are you sure you want to remove ${item.name}?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
              TextButton(
                onPressed: () {
                  provider.removeMasterItem(item.id);
                  Navigator.pop(context);
                },
                child: const Text('DELETE', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF53616F))),
                const Icon(Icons.edit_outlined, color: Colors.grey, size: 18),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildItemDetail('Sale Price', '${provider.currency} ${item.price.toStringAsFixed(2)}'),
                _buildItemDetail('Purchase Price', '${provider.currency} ${item.purchasePrice.toStringAsFixed(2)}'),
                _buildItemDetail('In Stock', item.stock.toString(), valueColor: const Color(0xFF2E7D32)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildItemDetail('Reserved Qty', item.reservedQty.toString()),
                _buildItemDetail('Available Qty', item.availableQty.toString()),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetail(String label, String value, {Color? valueColor}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF53616F),
            ),
          ),
        ],
      ),
    );
  }
}
