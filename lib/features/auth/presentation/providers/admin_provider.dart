import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This provider watches the current user's role in Firestore.
/// It uses a Stream so the UI updates instantly if a role is changed in the console.
final isAdminProvider = StreamProvider<bool>((ref) {
  // 1. Get the current user from Firebase Auth
  final user = FirebaseAuth.instance.currentUser;

  // 2. If no user is logged in, they are definitely not an admin
  if (user == null) {
    return Stream.value(false);
  }

  // 3. Listen to the specific user document in the 'users' collection
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data() as Map<String, dynamic>;

      // Check if the role is explicitly set to 'admin'
      // Using '==' 'admin' ensures only that specific string works
      return data['role'] == 'admin';
    }
    return false;
  }).handleError((error) {
    // If there is a permission error or network issue, default to false
    debugPrint("Admin Provider Error: $error");
    return false;
  });
});