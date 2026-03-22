import 'package:flutter/material.dart';
import '../models/invoice.dart';

class PaymentMethodScreen extends StatefulWidget {
  final PaymentInfo payment;

  const PaymentMethodScreen({super.key, required this.payment});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  late TextEditingController _accountNameController;
  late TextEditingController _accountNoController;
  late TextEditingController _bankNameController;
  late TextEditingController _swiftController;
  String _selectedMethod = 'PayPal';

  final List<Map<String, dynamic>> _methods = [
    {'name': 'PayPal', 'icon': Icons.payment},
    {'name': 'Visa', 'icon': Icons.credit_card},
    {'name': 'MasterCard', 'icon': Icons.credit_card_off},
  ];

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController(text: widget.payment.accountName);
    _accountNoController = TextEditingController(text: widget.payment.accountNo);
    _bankNameController = TextEditingController(text: widget.payment.bankName);
    _swiftController = TextEditingController(text: widget.payment.swift);
    _selectedMethod = widget.payment.method;
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNoController.dispose();
    _bankNameController.dispose();
    _swiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payments', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                PaymentInfo(
                  accountName: _accountNameController.text,
                  accountNo: _accountNoController.text,
                  bankName: _bankNameController.text,
                  swift: _swiftController.text,
                  method: _selectedMethod,
                ),
              );
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFF34A853), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField('Account Name', _accountNameController),
            const SizedBox(height: 16),
            _buildInputField('Account Number', _accountNoController),
            const SizedBox(height: 16),
            _buildInputField('Bank Name', _bankNameController),
            const SizedBox(height: 16),
            _buildInputField('SWIFT/BIC', _swiftController),
            const SizedBox(height: 30),
            const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 12),
            _buildMethodSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _methods.map((m) {
        bool isSelected = _selectedMethod == m['name'];
        return GestureDetector(
          onTap: () => setState(() => _selectedMethod = m['name'] as String),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF34A853) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? const Color(0xFF34A853) : Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(m['icon'] as IconData, color: isSelected ? Colors.white : Colors.grey, size: 30),
                const SizedBox(height: 8),
                Text(m['name'] as String, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
