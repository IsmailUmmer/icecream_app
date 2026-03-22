import 'package:flutter/material.dart';
import '../models/invoice.dart';

class BillToScreen extends StatefulWidget {
  final Party party;

  const BillToScreen({super.key, required this.party});

  @override
  State<BillToScreen> createState() => _BillToScreenState();
}

class _BillToScreenState extends State<BillToScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.party.name);
    _emailController = TextEditingController(text: widget.party.email);
    _phoneController = TextEditingController(text: widget.party.phone);
    _addressController = TextEditingController(text: widget.party.address);
    _cityController = TextEditingController(text: widget.party.city);
    _websiteController = TextEditingController(text: widget.party.website);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _websiteController.dispose();
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
        title: const Text('Bill To', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                Party(
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  address: _addressController.text,
                  city: _cityController.text,
                  website: _websiteController.text,
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
          children: [
            _buildInputField('Client Name', _nameController, isRequired: true),
            const SizedBox(height: 16),
            _buildInputField('Email Address', _emailController),
            const SizedBox(height: 16),
            _buildInputField('Phone No.', _phoneController, isRequired: true, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildInputField('Address', _addressController, isRequired: true),
            const SizedBox(height: 16),
            _buildInputField('City', _cityController),
            const SizedBox(height: 16),
            _buildInputField('Website', _websiteController, keyboardType: TextInputType.url),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isRequired = false, TextInputType keyboardType = TextInputType.text}) {
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
}
