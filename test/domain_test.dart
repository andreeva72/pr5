import 'package:test/test.dart';
import 'package:flower_shop1/flower_shop1.dart';

void main() {
  test('User toMap and fromMap', () {
    final user = User(
      id: '1',
      name: 'надя',
      phone: '7999123409',
      email: 'nadya@mail.ru',
      passwordHash: '123',
      registeredAt: DateTime(2024, 1, 1),
    );
    final map = user.toMap();
    final restored = User.fromMap(map);
    expect(restored.id, '1');
    expect(restored.name, 'надя');
  });
}