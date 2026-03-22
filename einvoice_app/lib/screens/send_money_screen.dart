import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/app_provider.dart';
import 'dart:math';

class SendMoneyScreen extends StatelessWidget {
  const SendMoneyScreen({super.key});

  void _showSendMoneyDialog(BuildContext context) {
    String name = '';
    double amount = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(hintText: 'Recipient Name'), onChanged: (v) => name = v),
            TextField(decoration: InputDecoration(hintText: 'Amount'), keyboardType: TextInputType.number, onChanged: (v) => amount = double.tryParse(v) ?? 0),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (name.isNotEmpty && amount > 0) {
                final transaction = TransactionModel(
                  id: Random().nextInt(1000).toString(),
                  name: name,
                  amount: amount,
                  date: 'Just now',
                  type: TransactionType.sent,
                  status: TransactionStatus.success,
                );
                context.read<AppProvider>().addTransaction(transaction);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Money sent successfully!')));
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Send Money', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF34A853).withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const Text('Available Balance', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text('\$ ${provider.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF34A853))),
                ],
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => _showSendMoneyDialog(context),
              child: _buildActionRow(Icons.account_balance, 'Bank Transfer')
            ),
            const SizedBox(height: 16),
            _buildActionRow(Icons.qr_code_scanner, 'Scan & Pay'),
            const SizedBox(height: 16),
            _buildActionRow(Icons.person_add_alt_1_outlined, 'New Contact'),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Transfers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            ...provider.transactions.map((tx) => _recentItem(tx.name, '\$ ${tx.amount.toStringAsFixed(2)}', tx.status == TransactionStatus.success ? 'Success' : 'Processing')).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4)],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: const Color(0xFF34A853).withOpacity(0.1), child: Icon(icon, color: const Color(0xFF34A853))),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _recentItem(String name, String amount, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade100, child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?')),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(status, style: TextStyle(color: status == 'Success' ? Colors.green : Colors.orange, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ],
      ),
    );
  }
}
