import 'package:swift_shop/features/home/domain/entities/product_entity.dart';



class CartItemEntity {
  final ProductEntity product;
  final int quantity;

  CartItemEntity({required this.product, this.quantity = 1});

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}