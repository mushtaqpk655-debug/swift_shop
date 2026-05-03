import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:swift_shop/features/auth/presentation/pages/notifications_page.dart';
import 'package:swift_shop/features/auth/presentation/pages/privacy_page.dart';
import 'package:swift_shop/features/auth/presentation/pages/signup_page.dart';
import 'package:swift_shop/features/home/presentation/pages/add_product_page.dart';
import 'package:swift_shop/injection_container.dart' as di;
import 'package:swift_shop/features/auth/presentation/pages/login_page.dart';
import 'package:swift_shop/features/home/presentation/pages/home_page.dart';
import 'package:swift_shop/features/cart/presentation/pages/cart_page.dart';
import 'package:swift_shop/features/auth/presentation/pages/shipping_address_page.dart';
// ADD THIS IMPORT
import 'package:swift_shop/features/home/presentation/pages/admin_panel_page.dart';


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

class MyApp extends ConsumerWidget {
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
      // --- ROUTE DEFINITIONS ---
      routes: {
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/orders': (context) => const CartPage(),
        '/shipping_address': (context) => const ShippingAddressPage(),
        '/admin_panel': (context) => const AdminPanelPage(), // ADDED ROUTE
        '/add_product': (context) => const AddProductPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/privacy': (context) => const PrivacyPage(),
      },
      // --- AUTH GATEKEEPER ---
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}