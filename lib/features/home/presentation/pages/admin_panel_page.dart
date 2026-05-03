import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Admin Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "System Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // --- THIS IS THE ROW WITH THE BLUE BUTTON ---
            Row(
              children: [
                _buildStatCard(
                  title: "Add Product",
                  subtitle: "Tap to expand store",
                  icon: Icons.add_circle_outline,
                  color: Colors.blue, // This creates the blue theme
                  onTap: () => Navigator.pushNamed(context, '/add_product'),
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  title: "Active Orders",
                  subtitle: "Live from Firestore",
                  icon: Icons.trending_up,
                  color: Colors.green,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 25),
            const Text(
              "Global Order Stream",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Orders List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text("Error loading orders"));
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final orders = snapshot.data!.docs;

                  if (orders.isEmpty) {
                    return const Center(child: Text("No orders placed yet."));
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final data = orders[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.black12,
                            child: Icon(Icons.receipt, color: Colors.black),
                          ),
                          title: Text("Order #${orders[index].id.substring(0, 5).toUpperCase()}"),
                          subtitle: Text("User: ${data['email'] ?? 'Unknown'}\nTotal: AED ${data['amount']}"),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UPDATED CARD DESIGN ---
  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            // This adds the colored vertical line on the left
            border: Border(left: BorderSide(color: color, width: 5)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}