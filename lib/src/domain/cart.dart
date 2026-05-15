class Cart {
  final String id;
  final String userId;

  const Cart({
    required this.id,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
  };

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      userId: map['userId'] as String,
    );
  }
}
