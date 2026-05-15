import 'package:test/test.dart';
import 'package:flower_shop1/flower_shop1.dart';

void main() {
  test('valid email', () {
    expect(isValidEmail('test@mail.ru'), true);
  });
  test('invalid email', () {
    expect(isValidEmail('testmail.ru'), false);
  });
  test('positive number', () {
    expect(isGreaterThanZero(10), true);
    expect(isGreaterThanZero(0), false);
  });
}