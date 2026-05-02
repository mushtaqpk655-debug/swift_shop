import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Auth Imports - Adding 'package:swift_shop/' or correct relative paths
import 'package:swift_shop/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:swift_shop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:swift_shop/features/auth/domain/repositories/auth_repository.dart';

// Home Imports
import 'package:swift_shop/features/home/data/datasources/product_remote_data_source.dart';
import 'package:swift_shop/features/home/data/repositories/product_repository_impl.dart';
import 'package:swift_shop/features/home/domain/repositories/product_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- External ---
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton(() => FirebaseAuth.instance);
  }
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }

  // --- Auth Feature ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );

  // --- Home Feature ---
  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
}