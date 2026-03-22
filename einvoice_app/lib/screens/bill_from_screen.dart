import 'package:flutter/material.dart';
import '../models/invoice.dart';

class BillFromScreen extends StatefulWidget {
  final Party party;

  const BillFromScreen({super.key, required this.party});

  @override
  State<BillFromScreen> createState() => _BillFromScreenState();
}

class _BillFromScreenState extends State<BillFromScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.party.name);
    _emailController = TextEditingController(text: widget.party.email);
    _phoneController = TextEditingController(text: widget.party.phone);
    _address1Controller = TextEditingController(text: widget.party.address);
    _address2Controller = TextEditingController(text: ''); // address2 not in model yet, but in UI
    _websiteController = TextEditingController(text: widget.party.website);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
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
        title: const Text('Bill From', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
                  address: _address1Controller.text,
                  website: _websiteController.text,
                  logo: widget.party.logo,
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
            _buildInputField('Business Name', _nameController, isRequired: true),
            const SizedBox(height: 16),
            _buildInputField('Email Address', _emailController),
            const SizedBox(height: 16),
            _buildInputField('Phone No.', _phoneController, isRequired: true, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildInputField('Address 1', _address1Controller, isRequired: true),
            const SizedBox(height: 16),
            _buildInputField('Address 2', _address2Controller),
            const SizedBox(height: 16),
            _buildInputField('Website', _websiteController, keyboardType: TextInputType.url),
            const SizedBox(height: 30),
            _buildLogoSection(),
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

  Widget _buildLogoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF34A853).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF34A853), size: 30),
          ),
          const SizedBox(height: 12),
          const Text('Upload Logo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('2 MB maximum (PNG, JPG)', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
