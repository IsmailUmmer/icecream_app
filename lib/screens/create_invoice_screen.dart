import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/invoice.dart';
import '../providers/app_provider.dart';
import 'dart:math';

import 'invoice_info_screen.dart';
import 'bill_from_screen.dart';
import 'bill_to_screen.dart';
import 'add_items_screen.dart';
import 'payment_method_screen.dart';

class CreateInvoiceScreen extends StatefulWidget {
  final InvoiceModel? invoice;
  const CreateInvoiceScreen({super.key, this.invoice});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  bool _isCash = true;
  InvoiceInfo _invoiceInfo = InvoiceInfo(
    invNo: 'INV-001',
    date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    dueDate: '${DateTime.now().add(const Duration(days: 7)).day}/${DateTime.now().add(const Duration(days: 7)).month}/${DateTime.now().add(const Duration(days: 7)).year}',
  );

  Party _billFrom = Party(name: 'Climaxcode', email: 'hello@climaxcode.com', phone: '+1 234 567 890', address: '123 Business St, Tech City');
  Party _billTo = Party(name: 'Muneeba', email: 'muneeba@example.com', phone: '+1 987 654 321', address: '456 Client Rd, Design Suburb');
  PaymentInfo _paymentInfo = PaymentInfo();
  final List<InvoiceItemModel> _items = [];

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      _invoiceInfo = widget.invoice!.info ?? _invoiceInfo;
      _billFrom = widget.invoice!.billFrom ?? _billFrom;
      _billTo = widget.invoice!.billTo ?? _billTo;
      _paymentInfo = widget.invoice!.payment ?? _paymentInfo;
      _items.addAll(widget.invoice!.items);
      _isCash = widget.invoice!.status == InvoiceStatus.paid;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<AppProvider>();
        setState(() {
          _invoiceInfo = InvoiceInfo(
            invNo: provider.nextInvoiceNumber,
            date: _invoiceInfo.date,
            dueDate: _invoiceInfo.dueDate,
            currency: provider.currency,
          );
        });
      });
    }
  }

  void _navigateToInvoiceInfo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvoiceInfoScreen(info: _invoiceInfo)),
    );
    if (result != null && result is InvoiceInfo) {
      setState(() => _invoiceInfo = result);
    }
  }

  void _navigateToBillFrom() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BillFromScreen(party: _billFrom)),
    );
    if (result != null && result is Party) {
      setState(() => _billFrom = result);
    }
  }

  void _navigateToBillTo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BillToScreen(party: _billTo)),
    );
    if (result != null && result is Party) {
      setState(() => _billTo = result);
    }
  }

  void _navigateToAddItem({InvoiceItemModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemsScreen(item: item)),
    );
    if (result != null && result is InvoiceItemModel) {
      setState(() {
        if (item != null) {
          int index = _items.indexWhere((i) => i.id == item.id);
          if (index != -1) _items[index] = result;
        } else {
          _items.add(result);
        }
      });
    }
  }

  void _navigateToPayment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodScreen(payment: _paymentInfo)),
    );
    if (result != null && result is PaymentInfo) {
      setState(() => _paymentInfo = result);
    }
  }

  void _saveInvoice() {
    if (_billTo.name.isEmpty || _items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter client name and add at least one item.')));
      return;
    }

    double totalAmount = _items.fold(0, (sum, item) => sum + item.total);

    final newInvoice = InvoiceModel(
      id: widget.invoice?.id ?? Random().nextInt(10000).toString(),
      clientName: _billTo.name,
      invNo: _invoiceInfo.invNo,
      date: _invoiceInfo.date,
      amount: totalAmount,
      status: _isCash ? InvoiceStatus.paid : InvoiceStatus.unpaid,
      dueAmount: _isCash ? 0.0 : totalAmount,
      dueDate: _invoiceInfo.dueDate,
      items: _items,
      info: _invoiceInfo,
      billFrom: _billFrom,
      billTo: _billTo,
      payment: _paymentInfo,
    );

    if (widget.invoice != null) {
      context.read<AppProvider>().updateInvoice(newInvoice);
    } else {
      context.read<AppProvider>().addInvoice(newInvoice);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.invoice == null ? 'Invoice saved successfully!' : 'Invoice updated successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.invoice == null ? 'Create' : 'Edit Invoice', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Center(
            child: Container(
              height: 38,
              width: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: _isCash ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 80,
                      height: 34,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34A853),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF34A853).withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isCash = false),
                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Credit',
                              style: TextStyle(
                                color: !_isCash ? Colors.white : const Color(0xFF8E9297),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isCash = true),
                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Cash',
                              style: TextStyle(
                                color: _isCash ? Colors.white : const Color(0xFF8E9297),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1B2430)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildInvoiceNumberSection(),
            const SizedBox(height: 24),
            _buildSummaryCard('Bill From', _billFrom.name, _navigateToBillFrom),
            const SizedBox(height: 12),
            _buildSummaryCard('Bill To', _billTo.name, _navigateToBillTo),
            const SizedBox(height: 24),
            _buildItemsSection(),
            const SizedBox(height: 24),
            _buildAmountSummarySection(),
            const SizedBox(height: 24),
            _buildActionRow('Payment', _paymentInfo.accountNo.isNotEmpty ? _paymentInfo.method : 'Add Payment +', _navigateToPayment),
            const SizedBox(height: 12),
            _buildActionRow('Signature', '', () {}),
            const SizedBox(height: 12),
            _buildActionRow('Terms & Conditions', '', () {}),
            const SizedBox(height: 12),
            _buildActionRow('Attachment', '0/5', () {}),
            const SizedBox(height: 40),
            _buildContinueButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceNumberSection() {
    return InkWell(
      onTap: _navigateToInvoiceInfo,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_invoiceInfo.invNo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 4),
            Text(_invoiceInfo.date, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text('Due on ${_invoiceInfo.dueDate}', style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(value.isEmpty ? 'Choose' : value, style: TextStyle(color: value.isEmpty ? const Color(0xFF34A853) : Colors.grey.shade500, fontSize: 13)),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () => _navigateToAddItem(),
              child: const Text('Add items +', style: TextStyle(color: Color(0xFF34A853), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        if (_items.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._items.map((item) => InkWell(
            onTap: () => _navigateToAddItem(item: item),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text('${item.quantity} x ${_invoiceInfo.currency}${item.price.toStringAsFixed(0)}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                  Text('${_invoiceInfo.currency}${item.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildAmountSummarySection() {
    double totalAmount = _items.fold(0, (sum, item) => sum + item.total);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow('Discount', 'Enter Amt', isAction: true),
          const Divider(height: 24),
          _summaryRow('Tax', '${_invoiceInfo.currency}0', isAction: true),
          const Divider(height: 24),
          _summaryRow('Shipping', '${_invoiceInfo.currency}0', isAction: true),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amt', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text('${_invoiceInfo.currency}${totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isAction = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        Row(
          children: [
            Text(value, style: TextStyle(color: isAction ? const Color(0xFF34A853) : Colors.black, fontWeight: isAction ? FontWeight.bold : FontWeight.normal)),
            if (isAction) const SizedBox(width: 4),
            if (isAction) const Icon(Icons.add_circle, color: Color(0xFF34A853), size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildActionRow(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Row(
              children: [
                if (value.isNotEmpty) Text(value, style: TextStyle(color: const Color(0xFF34A853), fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF34A853),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: _saveInvoice,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.double_arrow, size: 18),
          ],
        ),
      ),
    );
  }
}
