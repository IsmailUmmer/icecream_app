import 'package:flutter/material.dart';
import 'settings_screen.dart';
import '../utils/app_keys.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sort_rounded, size: 28, color: Colors.black87),
          onPressed: () => AppKeys.mainScaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF34A853), width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?u=ismail'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Color(0xFF34A853), shape: BoxShape.circle),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Ismail Ummer', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Software Consultant', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 32),
            _menuItem(Icons.person_outline, 'Personal Info'),
            _menuItem(Icons.payment_outlined, 'Payment Methods'),
            _menuItem(Icons.security_outlined, 'Security'),
            _menuItem(Icons.help_outline, 'Help Center'),
            _menuItem(Icons.logout, 'Log Out', color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black87),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color ?? Colors.black87)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
