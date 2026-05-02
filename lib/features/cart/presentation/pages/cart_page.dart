import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_service.dart'; // Ensure this import exists

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    double total = cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty!"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item.imageUrl, width: 50),
                  title: Text(item.name),
                  subtitle: Text("${item.price} AED"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => ref.read(cartProvider.notifier).removeItem(item.id),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${total.toStringAsFixed(2)} AED",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () => _handleCheckout(context, ref, total),
                    child: const Text("PLACE ORDER NOW", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- THE NEW PAYMENT LOGIC ---
  Future<void> _handleCheckout(BuildContext context, WidgetRef ref, double total) async {
    if (total <= 0) return;

    try {
      // 1. Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.black)),
      );

      // 2. Trigger Stripe Payment
      // Note: This opens the UI where you enter the 4242 card number
      await PaymentService.makePayment(total.toString());

      // 3. Remove loading indicator
      if (context.mounted) Navigator.pop(context);

      // 4. If payment succeeded, save order to Firebase
      await ref.read(cartProvider.notifier).placeOrder();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Successful! Order Placed."), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Go back to Home
      }
    } catch (e) {
      // Remove loading indicator if error occurs
      if (context.mounted && Navigator.canPop(context)) Navigator.pop(context);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Failed: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }
}