import 'package:flower_shop1/flower_shop1.dart';

void main(List<String> arguments) {
  final db = FlowerDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}