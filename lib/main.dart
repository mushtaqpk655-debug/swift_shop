import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:swift_shop/injection_container.dart' as di;
import 'package:swift_shop/features/auth/presentation/pages/login_page.dart';
import 'package:swift_shop/features/home/presentation/pages/home_page.dart';
import 'package:swift_shop/features/cart/presentation/pages/cart_page.dart'; // Corrected path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe
  Stripe.publishableKey = "pk_test_51TSIA62ccOyMgmJdDeTYMn5MPFsWqwIKqkFoP2Tlnw3RKOUoLF8yx4o7MlIMtKv3VrwwVgLAPrkuzjeA965SWiGr00pdxMqHmg";
  await Stripe.instance.applySettings();

  try {
    await Firebase.initializeApp();
    await di.init();

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("App Init Error: $e")))));
  }
}

class MyApp extends ConsumerWidget { // Changed to ConsumerWidget to watch auth state
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwiftShop',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      // --- THE FIX: ROUTE DEFINITIONS ---
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/orders': (context) => const CartPage(), // Using your correct filename
      },
      // --- THE FIX: AUTH GATEKEEPER ---
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If Firebase says we have a user, go to Home
          if (snapshot.hasData) {
            return const HomePage();
          }
          // Otherwise, go to Login
          return const LoginPage();
        },
      ),
    );
  }
}