import 'dart:io';
import '../data/database.dart';
import '../data/repositories/user_rep.dart';
import '../data/repositories/category_rep.dart';
import '../data/repositories/product_rep.dart';
import '../data/repositories/cart_rep.dart';
import '../data/repositories/cart_item_rep.dart';
import '../data/repositories/order_rep.dart';
import '../data/repositories/order_item_rep.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/order_item.dart';

void runMenu(FlowerDatabase db) {
  final userRepo = UserRepository(db.db);
  final categoryRepo = CategoryRepository(db.db);
  final productRepo = ProductRepository(db.db);
  final cartRepo = CartRepository(db.db);
  final cartItemRepo = CartItemRepository(db.db);
  final orderRepo = OrderRepository(db.db);
  final orderItemRepo = OrderItemRepository(db.db);

  while (true) {
    stdout.writeln('''
    Цветочный магазин
    1 — список пользователей
    2 — добавить пользователя
    3 — удалить пользователя
    4 — список категорий
    5 — добавить категорию
    6 — удалить категорию
    7 — список товаров
    8 — добавить товар
    9 — удалить товар
    10 — корзина пользователя
    11 — добавить товар в корзину
    12 — удалить товар из корзины
    13 — оформить заказ
    14 — список заказов
    15 — показать всё из БД
    0 — выход
    Выберите пункт:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        final list = userRepo.getAll();
        if (list.isEmpty) { print('Пользователей нет'); }
        else { for (final u in list) { print('${u.id} | ${u.name} | ${u.phone}'); } }
        break;
      case '2':
        final id = _read('id: ');
        final name = _read('имя: ');
        final phone = _read('телефон: ');
        final email = _read('email: ');
        final pass = _read('пароль: ');
        userRepo.insert(User(id: id, name: name, phone: phone, email: email, passwordHash: pass, registeredAt: DateTime.now()));
        print('Пользователь добавлен');
        break;
      case '3':
        final id = _read('id пользователя: ');
        userRepo.delete(id);
        print('Удалено');
        break;
      case '4':
        final list = categoryRepo.getAll();
        if (list.isEmpty) { print('Категорий нет'); }
        else { for (final c in list) { print('${c.id} | ${c.name}'); } }
        break;
      case '5':
        final id = _read('id категории: ');
        final name = _read('название: ');
        final desc = _read('описание: ');
        categoryRepo.insert(Category(id: id, name: name, description: desc.isEmpty ? null : desc));
        print('Категория добавлена');
        break;
      case '6':
        final id = _read('id категории: ');
        categoryRepo.delete(id);
        print('Удалено');
        break;
      case '7':
        final list = productRepo.getAll();
        if (list.isEmpty) { print('Товаров нет'); }
        else { for (final p in list) { print('${p.id} | ${p.name} | ${p.price}₽ | в наличии: ${p.stockQuantity}'); } }
        break;
      case '8':
        final id = _read('id товара: ');
        final name = _read('название: ');
        final desc = _read('описание: ');
        final catId = _read('id категории: ');
        final price = double.parse(_read('цена: ').replaceAll(',', '.'));
        final stock = int.parse(_read('количество: '));
        productRepo.insert(Product(id: id, name: name, description: desc.isEmpty ? null : desc, categoryId: catId, price: price, stockQuantity: stock));
        print('Товар добавлен');
        break;
      case '9':
        final id = _read('id товара: ');
        productRepo.delete(id);
        print('Удалено');
        break;
      case '10':
        final userId = _read('id пользователя: ');
        final cart = cartRepo.getByUserId(userId);
        if (cart == null) { print('Корзина пуста'); break; }
        final items = cartItemRepo.getByCartId(cart.id);
        if (items.isEmpty) { print('Корзина пуста'); break; }
        double total = 0;
        for (final item in items) {
          final prod = productRepo.getById(item.productId);
          final sum = (prod?.price ?? 0) * item.quantity;
          total += sum;
          print('${prod?.name} x${item.quantity} = $sum₽');
        }
        print('Итого: $total₽');
        break;
      case '11':
        final userId = _read('id пользователя: ');
        final productId = _read('id товара: ');
        final quantity = int.parse(_read('количество: '));
        var cart = cartRepo.getByUserId(userId);
        if (cart == null) {
          cartRepo.insert(Cart(id: 'cart_$userId', userId: userId));
          cart = cartRepo.getByUserId(userId);
        }
        cartItemRepo.insert(CartItem(id: 'ci_${DateTime.now().millisecondsSinceEpoch}', cartId: cart!.id, productId: productId, quantity: quantity));
        print('Товар добавлен в корзину');
        break;
      case '12':
        final id = _read('id товара в корзине: ');
        cartItemRepo.delete(id);
        print('Удалено');
        break;
      case '13':
        final userId = _read('id пользователя: ');
        final cart = cartRepo.getByUserId(userId);
        if (cart == null) { print('Корзина пуста'); break; }
        final items = cartItemRepo.getByCartId(cart.id);
        if (items.isEmpty) { print('Корзина пуста'); break; }
        double total = 0;
        for (final item in items) {
          final prod = productRepo.getById(item.productId);
          if (prod == null) { print('Товар не найден'); return; }
          if (prod.stockQuantity < item.quantity) { print('Недостаточно ${prod.name}'); return; }
          total += prod.price * item.quantity;
        }
        final address = _read('адрес доставки: ');
        final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
        orderRepo.insert(Order(id: orderId, userId: userId, orderDate: DateTime.now(), totalAmount: total, status: 'Оформлен', deliveryAddress: address));
        for (final item in items) {
          final prod = productRepo.getById(item.productId)!;
          orderItemRepo.insert(OrderItem(id: 'oi_${DateTime.now().millisecondsSinceEpoch}_${item.productId}', orderId: orderId, productId: item.productId, quantity: item.quantity, priceAtMoment: prod.price));
          productRepo.updateStock(item.productId, prod.stockQuantity - item.quantity);
        }
        cartItemRepo.clearCart(cart.id);
        print('Заказ оформлен! ID: $orderId, сумма: $total₽');
        break;
      case '14':
        final list = orderRepo.getAll();
        if (list.isEmpty) { print('Заказов нет'); }
        else { for (final o in list) { print('${o.id} | ${o.userId} | ${o.orderDate.toLocal()} | ${o.totalAmount}₽ | ${o.status}'); } }
        break;
      case '15':
        print('ПОЛЬЗОВАТЕЛИ');
        for (final u in userRepo.getAll()) { print('${u.id} | ${u.name}'); }
        print('КАТЕГОРИИ');
        for (final c in categoryRepo.getAll()) { print('${c.id} | ${c.name}'); }
        print('ТОВАРЫ');
        for (final p in productRepo.getAll()) { print('${p.id} | ${p.name} | ${p.price}₽'); }
        print('ЗАКАЗЫ');
        for (final o in orderRepo.getAll()) { print('${o.id} | ${o.userId} | ${o.totalAmount}₽'); }
        break;
      case '0':
        print('До свидания!');
        return;
      default:
        print('Неизвестная команда');
    }
    print('');
  }
}

String _read(String label) {
  stdout.write(label);
  return stdin.readLineSync()?.trim() ?? '';
}