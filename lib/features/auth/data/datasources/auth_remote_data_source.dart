import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) throw Exception("User not found");
      return UserModel.fromFirebaseUser(response.user!);
    } on FirebaseAuthException catch (e) {
      // Re-throw to be caught by the Repository
      throw Exception(e.message ?? "Authentication failed");
    }
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) throw Exception("User creation failed");
      return UserModel.fromFirebaseUser(response.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Sign up failed");
    }
  }

  @override
  Future<void> signOut() => firebaseAuth.signOut();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }
}