import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user ID safely
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Order History", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: userId == null
          ? const Center(child: Text("Please login to see orders"))
          : StreamBuilder<QuerySnapshot>(
        // We query the 'orders' collection for this specific user
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          final orderDocs = snapshot.data?.docs ?? [];

          if (orderDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text("No orders found yet!", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final data = orderDocs[index].data() as Map<String, dynamic>;

              // Extract data safely
              final double total = (data['totalAmount'] ?? 0.0).toDouble();
              final String status = data['status'] ?? 'Processing';
              final List items = data['items'] ?? [];
              final Timestamp? time = data['createdAt'] as Timestamp?;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.check, color: Colors.white, size: 20),
                  ),
                  title: Text("Order #${orderDocs[index].id.substring(0, 5)}"),
                  subtitle: Text("Total: AED ${total.toStringAsFixed(2)} • $status"),
                  children: [
                    const Divider(),
                    ...items.map((item) => ListTile(
                      title: Text(item['name'] ?? "Product"),
                      trailing: Text("AED ${item['price']}"),
                    )),
                    if (time != null)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Placed on: ${time.toDate().toString().split('.')[0]}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}