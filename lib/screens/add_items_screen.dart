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
  late TextEditingController _purchasePriceController;
  late TextEditingController _stockController;
  late TextEditingController _reservedQtyController;
  late TextEditingController _descriptionController;
  int _quantity = 1;
  String _selectedCategory = 'Services';

  final List<String> _categories = ['Clothing', 'Services', 'Electronic', 'Travel', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _priceController = TextEditingController(text: widget.item?.price.toString() ?? '');
    _purchasePriceController = TextEditingController(text: widget.item?.purchasePrice.toString() ?? '');
    _stockController = TextEditingController(text: widget.item?.stock.toString() ?? '');
    _reservedQtyController = TextEditingController(text: widget.item?.reservedQty.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _quantity = widget.item?.quantity ?? 1;
    _selectedCategory = widget.item?.category ?? 'Services';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _purchasePriceController.dispose();
    _stockController.dispose();
    _reservedQtyController.dispose();
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
                    purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
                    stock: double.tryParse(_stockController.text) ?? 0,
                    reservedQty: double.tryParse(_reservedQtyController.text) ?? 0,
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
            _buildQuickItemsPicker(context),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('OR ENTER MANUALLY', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
            const SizedBox(height: 24),
            _buildItemAutocompleteField(),
            const SizedBox(height: 16),
            _buildInputField('Sale Price', _priceController, isRequired: true, keyboardType: TextInputType.number, prefix: context.read<AppProvider>().currency),
            const SizedBox(height: 16),
            _buildInputField('Purchase Price', _purchasePriceController, keyboardType: TextInputType.number, prefix: context.read<AppProvider>().currency),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('In Stock', _stockController, keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _buildInputField('Reserved', _reservedQtyController, keyboardType: TextInputType.number)),
              ],
            ),
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

  void _updateItemFields(InvoiceItemModel item) {
    setState(() {
      _nameController.text = item.name;
      _priceController.text = item.price.toString();
      _descriptionController.text = item.description;
      _selectedCategory = item.category;
    });
  }

  Widget _buildQuickItemsPicker(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final items = provider.masterItems;
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick from Inventory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => _updateItemFields(item),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34A853).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF34A853), size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemAutocompleteField() {
    final provider = context.watch<AppProvider>();
    final items = provider.masterItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
            Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Autocomplete<InvoiceItemModel>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<InvoiceItemModel>.empty();
            }
            return items.where((InvoiceItemModel option) {
              return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: (InvoiceItemModel option) => option.name,
          onSelected: (InvoiceItemModel selection) => _updateItemFields(selection),
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            if (controller.text != _nameController.text) {
              controller.text = _nameController.text;
            }
            controller.addListener(() {
              if (_nameController.text != controller.text) {
                _nameController.text = controller.text;
              }
            });
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onSubmitted: (value) => onFieldSubmitted(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                hintText: 'Search inventory...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            );
          },
        ),
      ],
    );
  }
}
