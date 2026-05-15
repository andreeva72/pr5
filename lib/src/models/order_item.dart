class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double priceAtMoment;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceAtMoment,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'orderId': orderId,
    'productId': productId,
    'quantity': quantity,
    'priceAtMoment': priceAtMoment,
  };

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as String,
      orderId: map['orderId'] as String,
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      priceAtMoment: (map['priceAtMoment'] as num).toDouble(),
    );
  }
}