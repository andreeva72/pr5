class CartItem {
  final String id;
  final String cartId;
  final String productId;
  final int quantity;

  const CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'cartId': cartId,
    'productId': productId,
    'quantity': quantity,
  };

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      cartId: map['cartId'] as String,
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
    );
  }
}
