import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/invoice.dart';
import '../providers/app_provider.dart';
import '../services/pdf_service.dart';
import '../services/qr_service.dart';
import '../utils/app_keys.dart';
import 'create_invoice_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;
  const DashboardScreen({super.key, this.onProfileTap});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    // Filtering logic
    List<InvoiceModel> filteredInvoices = provider.invoices.where((inv) {
      bool matchesFilter = true;
      if (_selectedFilter == 'Paid') matchesFilter = inv.status == InvoiceStatus.paid;
      if (_selectedFilter == 'Unpaid') matchesFilter = inv.status == InvoiceStatus.unpaid;
      if (_selectedFilter == 'Partially paid') matchesFilter = inv.status == InvoiceStatus.partiallyPaid;

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch = inv.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                        inv.invNo.toLowerCase().contains(_searchQuery.toLowerCase());
      }

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.sort_rounded, size: 28, color: Colors.black87),
          onPressed: () => AppKeys.mainScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Einvoice', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black87), onPressed: () {}),
          InkWell(
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
            child: const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=ismail')),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSummaryCards(provider, provider.balance),
          const SizedBox(height: 16),
          _buildFilters(),
          const SizedBox(height: 8),
          Expanded(child: _buildInvoiceList(provider, filteredInvoices)),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(AppProvider provider, double balance) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _summaryCard('Total paid', '${provider.currency}${balance.toStringAsFixed(2)}', Colors.green),
          const SizedBox(width: 12),
          _summaryCard('Due Amt', '${provider.currency}12,430.00', Colors.red),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String amount, Color amountColor) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(amount, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: amountColor)),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildFilters() {
    final filters = ['All', 'Paid', 'Unpaid', 'Partially paid'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(
          filters.length,
          (i) {
            bool isSelected = _selectedFilter == filters[i];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filters[i]),
                selected: isSelected,
                selectedColor: const Color(0xFF34A853).withOpacity(0.2),
                checkmarkColor: const Color(0xFF34A853),
                onSelected: (val) => setState(() => _selectedFilter = filters[i]),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? const Color(0xFF34A853) : Colors.grey.shade200),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search invoices...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: const Icon(Icons.tune_rounded, color: Color(0xFF34A853), size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(AppProvider provider, List<InvoiceModel> invoices) {
    if (invoices.isEmpty) {
      return const Center(child: Text('No invoices found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final inv = invoices[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateInvoiceScreen(invoice: inv)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4),
              ],
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(inv.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 22, color: Colors.redAccent),
                        onPressed: () => PdfService.generateInvoicePdf(inv),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 22, color: Colors.blueAccent),
                        onPressed: () => PdfService.shareInvoicePdf(inv),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      IconButton(
                        icon: const Icon(Icons.qr_code_2, size: 22, color: Color(0xFF34A853)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Invoice QR'),
                              content: QrService.getInvoiceQr(inv),
                            ),
                          );
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      Text(
                        'Due Amt ${provider.currency} ${inv.dueAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: inv.dueAmount > 0 ? Colors.red : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('# ${inv.invNo}   ${inv.date}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  Text('Due: ${inv.dueDate}', style: TextStyle(color: inv.dueAmount > 0 ? Colors.red : Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${provider.currency} ${inv.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF34A853))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(inv.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(inv.status),
                      style: TextStyle(color: _getStatusColor(inv.status), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  String _getStatusText(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid: return 'Paid';
      case InvoiceStatus.unpaid: return 'Unpaid';
      case InvoiceStatus.partiallyPaid: return 'Partial';
    }
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid: return const Color(0xFF34A853);
      case InvoiceStatus.unpaid: return Colors.red;
      case InvoiceStatus.partiallyPaid: return Colors.orange;
    }
  }
}
