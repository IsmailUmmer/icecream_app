import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/invoice.dart';
import '../providers/app_provider.dart';
import 'dart:math';

class AddItemsScreen extends StatefulWidget {
  final InvoiceItemModel? item;

  const AddItemsScreen({super.key, this.item});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  int _quantity = 1;
  String _selectedCategory = 'Services';

  final List<String> _categories = ['Clothing', 'Services', 'Electronic', 'Travel', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _priceController = TextEditingController(text: widget.item?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _quantity = widget.item?.quantity ?? 1;
    _selectedCategory = widget.item?.category ?? 'Services';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
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
        title: Text(widget.item == null ? 'Add Items' : 'Edit Item', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
                Navigator.pop(
                  context,
                  InvoiceItemModel(
                    id: widget.item?.id ?? Random().nextInt(10000).toString(),
                    name: _nameController.text,
                    quantity: _quantity,
                    price: double.tryParse(_priceController.text) ?? 0,
                    description: _descriptionController.text,
                    category: _selectedCategory,
                  ),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFF34A853), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputField('Item Name', _nameController, isRequired: true),
            const SizedBox(height: 16),
            _buildInputField('Price', _priceController, isRequired: true, keyboardType: TextInputType.number, prefix: context.watch<AppProvider>().currency),
            const SizedBox(height: 16),
            _buildQuantityStepper(),
            const SizedBox(height: 16),
            _buildInputField('Description', _descriptionController, maxLines: 3),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isRequired = false, TextInputType keyboardType = TextInputType.text, int maxLines = 1, String? prefix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
            if (isRequired) const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixText: prefix != null ? '$prefix ' : null,
            prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityStepper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_quantity > 1) setState(() => _quantity--);
                    },
                    icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF34A853)),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF34A853)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
