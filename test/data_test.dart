import 'package:test/test.dart';
import 'package:flower_shop1/flower_shop1.dart';

void main() {
  test('database connection', () {
    final db = FlowerDatabase.inApp();
    expect(db, isNotNull);
    db.close();
  });
}