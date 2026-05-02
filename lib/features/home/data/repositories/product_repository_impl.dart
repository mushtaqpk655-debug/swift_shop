import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
// Fix this import to point to the file you just created
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product_entity.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getProducts();
      return Right(remoteProducts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}