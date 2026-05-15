class Product {
  final String id;
  final String name;
  final String? description;
  final String categoryId;
  final double price;
  final int stockQuantity;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    required this.price,
    required this.stockQuantity,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'categoryId': categoryId,
    'price': price,
    'stockQuantity': stockQuantity,
  };

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      categoryId: map['categoryId'] as String,
      price: (map['price'] as num).toDouble(),
      stockQuantity: map['stockQuantity'] as int,
    );
  }
}
