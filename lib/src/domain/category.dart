class Category {
  final String id;
  final String name;
  final String? description;

  const Category({
    required this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
  };

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }
}
