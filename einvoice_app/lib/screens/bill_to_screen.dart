import 'package:flutter/material.dart';
import '../models/invoice.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

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
              if (_nameController.text.trim().isEmpty ||
                  _phoneController.text.trim().isEmpty ||
                  _addressController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please fill all required fields (*)'),
                    backgroundColor: Colors.red.shade400,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
                return;
              }
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
            _buildClientPicker(context),
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
            _buildClientAutocompleteField(),
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

  void _updateClientFields(Party client) {
    setState(() {
      _nameController.text = client.name;
      _emailController.text = client.email;
      _phoneController.text = client.phone;
      _addressController.text = client.address;
      _cityController.text = client.city;
      _websiteController.text = client.website;
    });
  }

  Widget _buildClientPicker(BuildContext context) {
    final clients = context.watch<AppProvider>().clients;
    if (clients.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick from Clients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => _updateClientFields(client),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF34A853).withOpacity(0.1),
                        child: Text(client.name.substring(0, 1).toUpperCase(), style: const TextStyle(color: Color(0xFF34A853), fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      const SizedBox(height: 8),
                      Text(client.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
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

  Widget _buildClientAutocompleteField() {
    final clients = context.watch<AppProvider>().clients;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Client Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
            Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Autocomplete<Party>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<Party>.empty();
            }
            return clients.where((Party option) {
              return option.name
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: (Party option) => option.name,
          onSelected: (Party selection) => _updateClientFields(selection),
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
                hintText: 'Type to search clients...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            );
          },
        ),
      ],
    );
  }
}
