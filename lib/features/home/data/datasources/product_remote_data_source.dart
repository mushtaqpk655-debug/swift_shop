import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ProductModel>> getProducts() async {
    // This looks for a collection named 'products' in your Firebase
    final snapshot = await firestore.collection('products').get();
    return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}