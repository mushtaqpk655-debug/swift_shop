import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

// The Provider that the UI will listen to
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(sl<AuthRepository>());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthInitial());

  // --- LOGIN ---
  Future<void> login(String email, String password) async {
    state = AuthLoading();
    final result = await _repository.signIn(email, password);

    result.fold(
          (failure) => state = AuthError(failure.message),
          (user) => state = AuthAuthenticated(user),
    );
  }

  // --- SIGN UP ---
  Future<void> signUp(String email, String password) async {
    state = AuthLoading();
    final result = await _repository.signUp(email, password);

    result.fold(
          (failure) => state = AuthError(failure.message),
          (user) => state = AuthAuthenticated(user),
    );
  }

  // --- LOGOUT (Add this) ---
  // Inside your AuthNotifier class:
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // This tells Firebase to clear the session
      //state = null; // Or whatever your 'Logged Out' state is
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}