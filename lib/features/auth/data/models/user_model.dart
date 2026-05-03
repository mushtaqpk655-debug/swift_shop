import '../../domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  const UserModel({

    required super.uid,
    required super.email,
    super.displayName,
  });

  // Convert Firebase User to our Model
  // Ensure this name matches what you call in the DataSource
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  // Convert Model to Map for Firestore if needed later
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }
}