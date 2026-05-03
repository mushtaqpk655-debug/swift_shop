import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _sales = true;
  bool _orders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Sales & Promotions"),
            subtitle: const Text("Get notified about sneaker drops and discounts"),
            value: _sales,
            onChanged: (val) => setState(() => _sales = val),
          ),
          SwitchListTile(
            title: const Text("Order Updates"),
            subtitle: const Text("Real-time tracking for your purchases"),
            value: _orders,
            onChanged: (val) => setState(() => _orders = val),
          ),
        ],
      ),
    );
  }
}