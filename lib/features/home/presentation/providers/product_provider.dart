import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product_entity.dart';

// 1. The original search query state
final searchQueryProvider = StateProvider<String>((ref) => "");

// 2. The original data fetcher from Firebase
final productsProvider = FutureProvider<List<ProductEntity>>((ref) async {
  final repository = sl<ProductRepository>();
  final result = await repository.getProducts();

  return result.fold(
        (failure) => throw failure.message,
        (products) => products,
  );
});

// 3. The Filtered Provider (This combines the data and the search text)
final filteredProductsProvider = Provider<AsyncValue<List<ProductEntity>>>((ref) {
  final allProductsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return allProductsAsync.whenData((products) {
    if (query.isEmpty) return products;
    return products.where((p) =>
    p.name.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query)
    ).toList();
  });
});