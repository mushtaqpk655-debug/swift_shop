import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(String email, String password);

  // Updated to match Notifier and return Either
  Future<Either<Failure, void>> logout();

  Future<Option<UserEntity>> getCurrentUser();
}