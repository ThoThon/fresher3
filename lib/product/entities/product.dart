import '../../category/entities/category.dart';

class Product {
  final int id;
  final int status;
  final String name;
  final String code;
  final double price;
  final int stock;
  final String description;
  final String image;
  final Category? category; 

  Product({
    required this.id,
    required this.status,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.description,
    required this.image,
    this.category, 
  });
}