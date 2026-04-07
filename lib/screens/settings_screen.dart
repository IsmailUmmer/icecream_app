import 'package:flutter/material.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildPremiumSettingItem(
              context,
              icon: Icons.language,
              title: 'App Language',
              subtitle: 'English',
              iconColor: Colors.blue.shade100,
              iconSymbolColor: Colors.blue.shade700,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen())),
            ),
            const SizedBox(height: 16),
            _buildPremiumSettingItem(
              context,
              icon: Icons.share_outlined,
              title: 'Share App',
              subtitle: 'Share with friends & family',
              iconColor: Colors.purple.shade50,
              iconSymbolColor: Colors.purple.shade400,
            ),
            const SizedBox(height: 16),
            _buildPremiumSettingItem(
              context,
              icon: Icons.thumb_up_alt_outlined,
              title: 'Rate Us',
              subtitle: 'Rate us 5 star',
              iconColor: Colors.blue.shade50,
              iconSymbolColor: Colors.blue.shade400,
            ),
            const SizedBox(height: 16),
            _buildPremiumSettingItem(
              context,
              icon: Icons.shield_outlined,
              title: 'Privacy Policy',
              subtitle: 'Our Terms & Conditions',
              iconColor: Colors.blue.shade50,
              iconSymbolColor: Colors.blue.shade400,
            ),
            const SizedBox(height: 16),
            _buildPremiumSettingItem(
              context,
              icon: Icons.add_circle_outline,
              title: 'More Apps',
              subtitle: 'Add more apps',
              iconColor: Colors.grey.shade200,
              iconSymbolColor: Colors.grey.shade600,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'AD',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconSymbolColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconSymbolColor, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
