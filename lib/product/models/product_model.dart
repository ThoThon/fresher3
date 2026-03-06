import '../../category/models/category_model.dart';
import '../entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.status,
    required super.name,
    required super.code,
    required super.price,
    required super.stock,
    required super.description,
    required super.image,
    super.category, 
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      status: json['status'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] != null 
          ? CategoryModel.fromJson(json['category']) 
          : null, 
    );
  }
}