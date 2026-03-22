import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/invoice.dart';
import '../models/transaction.dart';

class AppProvider extends ChangeNotifier {
  static const _invoicesKey = 'invoices_v1';
  static const _transactionsKey = 'transactions_v1';
  static const _currencyKey = 'currency_v1';
  static const _clientsKey = 'clients_v1';
  static const _itemsKey = 'master_items_v1';

  double _balance = 12500.00;
  List<InvoiceModel> _invoices = [];
  List<TransactionModel> _transactions = [];
  String _currency = '₹';
  List<Party> _clients = [];
  List<InvoiceItemModel> _masterItems = [];

  AppProvider() {
    _initialLoad();
  }

  double get balance => _balance;
  List<InvoiceModel> get invoices => _invoices;
  List<TransactionModel> get transactions => _transactions;
  String get currency => _currency;
  List<Party> get clients => _clients;
  List<InvoiceItemModel> get masterItems => _masterItems;

  String get nextInvoiceNumber {
    if (_invoices.isEmpty) return 'INV-001';
    
    try {
      // Find the maximum number from all invoice IDs of format INV-XXX
      int maxNum = 0;
      for (var inv in _invoices) {
        if (inv.invNo.startsWith('INV-')) {
          final parts = inv.invNo.split('-');
          if (parts.length > 1) {
            final num = int.tryParse(parts[1]);
            if (num != null && num > maxNum) {
              maxNum = num;
            }
          }
        }
      }
      return 'INV-${(maxNum + 1).toString().padLeft(3, '0')}';
    } catch (e) {
      return 'INV-${(_invoices.length + 1).toString().padLeft(3, '0')}';
    }
  }

  Future<void> _initialLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final invJson = prefs.getStringList(_invoicesKey);
      final txJson = prefs.getStringList(_transactionsKey);

      if (invJson == null || invJson.isEmpty) {
        _seedInMemoryData();
        await _persist();
      } else {
        _invoices = invJson
            .map((s) => InvoiceModel.fromJson(
                jsonDecode(s) as Map<String, dynamic>))
            .toList();
        _transactions = txJson != null
            ? txJson
                .map((s) => TransactionModel.fromJson(
                    jsonDecode(s) as Map<String, dynamic>))
                .toList()
            : [];
        _currency = prefs.getString(_currencyKey) ?? '₹';
        final clientsJson = prefs.getStringList(_clientsKey);
        _clients = clientsJson != null
            ? clientsJson
                .map((s) => Party.fromJson(jsonDecode(s) as Map<String, dynamic>))
                .toList()
            : [];
        final itemsJson = prefs.getStringList(_itemsKey);
        _masterItems = itemsJson != null
            ? itemsJson
                .map((s) => InvoiceItemModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
                .toList()
            : [];
        _recalculateBalance();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Storage load failed, using in-memory data: $e');
      _seedInMemoryData();
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          _invoicesKey, _invoices.map((i) => jsonEncode(i.toJson())).toList());
      await prefs.setStringList(_transactionsKey,
          _transactions.map((t) => jsonEncode(t.toJson())).toList());
      await prefs.setString(_currencyKey, _currency);
      await prefs.setStringList(
          _clientsKey, _clients.map((c) => jsonEncode(c.toJson())).toList());
      await prefs.setStringList(
          _itemsKey, _masterItems.map((i) => jsonEncode(i.toJson())).toList());
    } catch (e) {
      debugPrint('Storage save failed: $e');
    }
  }

  void _recalculateBalance() {
    _balance = 12500.00;
    for (var tx in _transactions) {
      if (tx.type == TransactionType.sent &&
          tx.status != TransactionStatus.failed) {
        _balance -= tx.amount;
      } else if (tx.type == TransactionType.received &&
          tx.status != TransactionStatus.failed) {
        _balance += tx.amount;
      }
    }
  }

  Future<void> updateInvoice(InvoiceModel model) async {
    final index = _invoices.indexWhere((inv) => inv.id == model.id);
    if (index != -1) {
      _invoices[index] = model;
      _recalculateBalance();
      notifyListeners();
      await _persist();
    }
  }

  Future<void> addInvoice(InvoiceModel model) async {
    _invoices.insert(0, model);
    _recalculateBalance();
    notifyListeners();
    await _persist();
  }

  Future<void> addTransaction(TransactionModel model) async {
    _transactions.insert(0, model);
    _recalculateBalance();
    notifyListeners();
    await _persist();
  }

  Future<void> setCurrency(String newCurrency) async {
    _currency = newCurrency;
    notifyListeners();
    await _persist();
  }

  void _seedInMemoryData() {
    _invoices = [
      InvoiceModel(
        id: '1',
        clientName: 'Amanda Saphira',
        invNo: 'INV-1025',
        date: '21 Mar 2026',
        amount: 350.00,
        dueAmount: 0.00,
        dueDate: '28 Mar 2026',
        status: InvoiceStatus.paid,
        items: [
          InvoiceItemModel(
              id: '1', name: 'UI Design Services', quantity: 1, price: 350.00)
        ],
      ),
      InvoiceModel(
        id: '2',
        clientName: 'John Doe',
        invNo: 'INV-1026',
        date: '22 Mar 2026',
        amount: 150.00,
        dueAmount: 50.00,
        dueDate: '29 Mar 2026',
        status: InvoiceStatus.partiallyPaid,
        items: [
          InvoiceItemModel(
              id: '2', name: 'Consultation', quantity: 1, price: 150.00)
        ],
      ),
    ];
    _transactions = [
      TransactionModel(
        id: '1',
        name: 'UI Design Project',
        amount: 350.00,
        date: 'Mar 21, 2026',
        type: TransactionType.received,
        status: TransactionStatus.success,
      ),
      TransactionModel(
        id: '2',
        name: 'Office Rent',
        amount: 1200.00,
        date: 'Mar 20, 2026',
        type: TransactionType.sent,
        status: TransactionStatus.success,
      ),
    ];
    _clients = [
      Party(name: 'Robert', phone: '+1 2344 4478 899', email: 'robert@example.com', address: '123 Client St'),
      Party(name: 'Amanda Saphira', phone: '+1 987 654 321 00', email: 'amanda@example.com', address: '456 Designer Ave'),
    ];
    _masterItems = [
      InvoiceItemModel(id: '1', name: 'UI Design', price: 350.00, category: 'Services'),
      InvoiceItemModel(id: '2', name: 'Web Development', price: 1200.00, category: 'Services'),
      InvoiceItemModel(id: '3', name: 'Consultation', price: 150.00, category: 'Consultation'),
    ];
    _recalculateBalance();
    notifyListeners();
  }

  Future<void> addClient(Party client) async {
    _clients.insert(0, client);
    notifyListeners();
    await _persist();
  }

  Future<void> removeClient(String name) async {
    _clients.removeWhere((c) => c.name == name);
    notifyListeners();
    await _persist();
  }

  Future<void> addMasterItem(InvoiceItemModel item) async {
    _masterItems.insert(0, item);
    notifyListeners();
    await _persist();
  }

  Future<void> removeMasterItem(String id) async {
    _masterItems.removeWhere((i) => i.id == id);
    notifyListeners();
    await _persist();
  }
}
