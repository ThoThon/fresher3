class ProductRequest {
  final String name;
  final String code;
  final double price;
  final int stock;
  final String description;
  final int? categoryId;
  final String image;

  ProductRequest({
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.description,
    this.categoryId,
    this.image = "https://example.com/new-image.png",
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "code": code,
      "price": price,
      "stock": stock,
      "description": description,
      "category_id": categoryId,
      "image": image,
    };
  }
}
