import 'package:flutter/material.dart';
import '../models/invoice.dart';

class InvoiceInfoScreen extends StatefulWidget {
  final InvoiceInfo info;

  const InvoiceInfoScreen({super.key, required this.info});

  @override
  State<InvoiceInfoScreen> createState() => _InvoiceInfoScreenState();
}

class _InvoiceInfoScreenState extends State<InvoiceInfoScreen> {
  late TextEditingController _invNoController;
  late TextEditingController _dateController;
  late TextEditingController _dueDateController;
  String _selectedCurrency = '\$';
  String _selectedDueInterval = 'None';

  final List<String> _currencies = ['\$', '€', '£', '¥', '₹', 'Rp'];
  final List<String> _dueIntervals = ['None', '5 days', '7 days', '10 days', '15 days', '20 days', 'Custom'];

  @override
  void initState() {
    super.initState();
    _invNoController = TextEditingController(text: widget.info.invNo);
    _dateController = TextEditingController(text: widget.info.date);
    _dueDateController = TextEditingController(text: widget.info.dueDate);
    _selectedCurrency = widget.info.currency;
  }

  @override
  void dispose() {
    _invNoController.dispose();
    _dateController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF34A853),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
        title: const Text('Invoice info', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                InvoiceInfo(
                  invNo: _invNoController.text,
                  date: _dateController.text,
                  dueDate: _dueDateController.text,
                  currency: _selectedCurrency,
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
            _buildInputField('Invoice No.', _invNoController, hint: 'e.g. INV 01'),
            const SizedBox(height: 20),
            _buildDatePickerField('Creation Date', _dateController),
            const SizedBox(height: 20),
            _buildDueDateSection(),
            const SizedBox(height: 20),
            _buildCurrencyDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
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

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(controller),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.text.isEmpty ? 'Select Date' : controller.text, style: const TextStyle(fontSize: 16)),
                const Icon(Icons.calendar_today, color: Color(0xFF34A853), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () => _selectDate(_dueDateController),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_dueDateController.text.isEmpty ? 'Select Date' : _dueDateController.text, style: const TextStyle(fontSize: 14)),
                      const Icon(Icons.calendar_today, color: Color(0xFF34A853), size: 18),
                    ],
                  ),
                ),
              ),
            ),
            Container(height: 52, width: 1, color: Colors.grey.shade200),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDueInterval,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    items: _dueIntervals.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDueInterval = newValue!;
                        if (newValue != 'None' && newValue != 'Custom') {
                          int days = int.parse(newValue.split(' ')[0]);
                          final now = DateTime.now();
                          final due = now.add(Duration(days: days));
                          _dueDateController.text = "${due.day}/${due.month}/${due.year}";
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Currency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCurrency,
              isExpanded: true,
              items: _currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
