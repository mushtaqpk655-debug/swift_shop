import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Security")),
      body: ListView(
        children: [
          _buildSecurityTile(Icons.lock_outline, "Change Password", "Update your login credentials"),
          _buildSecurityTile(Icons.fingerprint, "Biometric Login", "Enable FaceID or Fingerprint"),
          _buildSecurityTile(Icons.visibility_off_outlined, "Hide Profile Picture", "Only show to friends"),
          const Divider(),
          _buildSecurityTile(Icons.delete_forever, "Delete Account", "Permanently remove your data", isDangerous: true),
        ],
      ),
    );
  }

  Widget _buildSecurityTile(IconData icon, String title, String subtitle, {bool isDangerous = false}) {
    return ListTile(
      leading: Icon(icon, color: isDangerous ? Colors.red : Colors.black),
      title: Text(title, style: TextStyle(color: isDangerous ? Colors.red : Colors.black, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}