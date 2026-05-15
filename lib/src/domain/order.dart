class Order {
  final String id;
  final String userId;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final String deliveryAddress;

  const Order({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'orderDate': orderDate.toIso8601String(),
    'totalAmount': totalAmount,
    'status': status,
    'deliveryAddress': deliveryAddress,
  };

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      userId: map['userId'] as String,
      orderDate: DateTime.parse(map['orderDate'] as String),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: map['status'] as String,
      deliveryAddress: map['deliveryAddress'] as String,
    );
  }
}
