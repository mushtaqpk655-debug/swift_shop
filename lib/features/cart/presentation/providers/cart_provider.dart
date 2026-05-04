import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swift_shop/features/home/domain/entities/product_entity.dart';

class CartNotifier extends StateNotifier<List<ProductEntity>> {
  CartNotifier() : super([]);

  // Add item to cart
  void addToCart(ProductEntity product) {
    // Only add if it's not already in the cart to avoid duplicates
    if (!state.any((item) => item.id == product.id)) {
      state = [...state, product];
    }
  }

  // Remove specific item from cart
  void removeFromCart(String productId) {
    state = state.where((item) => item.id != productId).toList();
  }

  // Alias for removeFromCart to match common naming conventions
  void removeItem(String productId) => removeFromCart(productId);

  // Clear all items
  void clearCart() {
    state = [];
  }

  // --- NEW: Place Order Function ---
  Future<void> placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Please login to place an order");
    if (state.isEmpty) throw Exception("Your cart is empty");

    final firestore = FirebaseFirestore.instance;

    // Calculate total price in AED
    double total = state.fold(0, (totalSum, item) => totalSum + item.price);

    // Map cart items for Firestore
    List<Map<String, dynamic>> orderItems = state.map((item) => {
      'name': item.name,
      'price': item.price,
      'id': item.id,
      'imageUrl': item.imageUrl,
    }).toList();

    try {
      await firestore.collection('orders').add({
        'userId': user.uid,
        'userEmail': user.email,
        'items': orderItems,
        'totalAmount': total,
        'status': 'Paid', // Since we use Stripe, we set it to 'Paid'
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear the cart after success
      clearCart();
    } catch (e) {
      throw Exception("Order failed: ${e.toString()}");
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<ProductEntity>>((ref) {
  return CartNotifier();
});