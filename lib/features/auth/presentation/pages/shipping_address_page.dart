import 'package:flutter/material.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final _addressController = TextEditingController();
  String selectedCity = 'Dubai';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Address")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedCity,
              decoration: const InputDecoration(labelText: "City"),
              items: ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman', 'UAQ', 'RAK', 'Fujairah']
                  .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCity = val!),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "Full Address (Villa/Apt, Street, Area)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                // Logic to save to Firestore goes here
                Navigator.pop(context);
              },
              child: const Text("Save Address", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}