import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Professional light grey background
      appBar: AppBar(
        title: const Text("Account", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user?.displayName ?? "SwiftShop User",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? "User Email",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Menu Section ---
            _buildSectionTitle("Personal Information"),
            _buildProfileTile(
              icon: Icons.shopping_bag_outlined,
              title: "My Orders",
              onTap: () => Navigator.pushNamed(context, '/orders'),
            ),
            _buildProfileTile(
              icon: Icons.location_on_outlined,
              title: "Shipping Address",
              subtitle: "Dubai, United Arab Emirates",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            _buildSectionTitle("App Settings"),
            _buildProfileTile(
              icon: Icons.notifications_none,
              title: "Notifications",
              onTap: () {},
            ),
            _buildProfileTile(
              icon: Icons.security,
              title: "Privacy & Security",
              onTap: () {},
            ),

            const SizedBox(height: 30),

            // --- Logout Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Corrected Helper widget for section headers
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2
          ),
        ),
      ),
    );
  }

  // Helper widget for menu items
  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit SwiftShop?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // 1. Sign out from Firebase immediately
              await FirebaseAuth.instance.signOut();

              // 2. Call your provider logout to clear state
              await ref.read(authProvider.notifier).logout();

              if (context.mounted) {
                // 3. Clear the entire screen stack and go to Login
                // This ensures the user cannot click 'back' to return to the profile
                Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                  '/login',
                      (route) => false,
                );
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}