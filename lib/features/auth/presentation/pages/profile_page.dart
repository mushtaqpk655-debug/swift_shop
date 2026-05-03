import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import '../providers/admin_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    // Using watch on the StreamProvider to handle admin visibility
    final isAdmin = ref.watch(isAdminProvider).value ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Account",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // --- Header Section ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                      user?.displayName ?? "SwiftShop User",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                  Text(
                      user?.email ?? "",
                      style: const TextStyle(color: Colors.grey)
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Admin Section (Now resets correctly on logout) ---
            if (isAdmin) ...[
              _buildSectionTitle("Management"),
              _buildProfileTile(
                icon: Icons.admin_panel_settings,
                title: "Admin Dashboard",
                onTap: () => Navigator.pushNamed(context, '/admin_panel'),
              ),
              const SizedBox(height: 10),
            ],

            _buildSectionTitle("Personal Information"),
            _buildProfileTile(
                icon: Icons.shopping_bag_outlined,
                title: "My Orders",
                onTap: () => Navigator.pushNamed(context, '/orders')
            ),
            _buildProfileTile(
                icon: Icons.location_on_outlined,
                title: "Shipping Address",
                onTap: () {}
            ),

            const SizedBox(height: 20),

            _buildSectionTitle("App Settings"),
            _buildProfileTile(
                icon: Icons.notifications_none,
                title: "Notifications",
                onTap: () => Navigator.pushNamed(context, '/notifications')
            ),
            _buildProfileTile(
                icon: Icons.security,
                title: "Privacy & Security",
                onTap: () => Navigator.pushNamed(context, '/privacy')
            ),

            const SizedBox(height: 30),

            // --- Logout Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _showLogoutDialog(context, ref),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Logout",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

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
            )
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
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
              child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () async {
              // 1. Sign out of Firebase
              await FirebaseAuth.instance.signOut();

              // 2. IMPORTANT: Force reset the admin status in Riverpod
              // This stops the dashboard from appearing for the next user
              ref.invalidate(isAdminProvider);

              // 3. Clear local auth state
              await ref.read(authProvider.notifier).logout();

              // 4. Navigate to login and wipe navigation history
              if (context.mounted) {
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