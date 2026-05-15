class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String passwordHash;
  final DateTime registeredAt;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.passwordHash,
    required this.registeredAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'passwordHash': passwordHash,
    'registeredAt': registeredAt.toIso8601String(),
  };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      passwordHash: map['passwordHash'] as String,
      registeredAt: DateTime.parse(map['registeredAt'] as String),
    );
  }
}
