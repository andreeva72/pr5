import 'dart:io';
import '../data/database.dart';
import '../data/repositories/user_rep.dart';
import '../data/repositories/category_rep.dart';
import '../data/repositories/product_rep.dart';
import '../data/repositories/cart_rep.dart';
import '../data/repositories/cart_item_rep.dart';
import '../data/repositories/order_rep.dart';
import '../data/repositories/order_item_rep.dart';
import '../domain/user.dart';
import '../domain/category.dart';
import '../domain/product.dart';
import '../domain/cart.dart';
import '../domain/cart_item.dart';
import '../domain/order.dart';
import '../domain/order_item.dart';

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
--- Цветочный магазин ---
1 — список пользователей
2 — добавить пользователя
3 — удалить пользователя по id
4 — список категорий
5 — добавить категорию
6 — удалить категорию по id
7 — список товаров
8 — добавить товар
9 — удалить товар по id
10 — список корзины
11 — добавить товар в корзину
12 — удалить товар из корзины по id
13 — оформить заказ
14 — список заказов
15 — показать всё из базы (как таблицы в консоли)
0 — выход
Выберите пункт:''');

    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        _printUsers(userRepo);
        break;
      case '2':
        _addUser(userRepo);
        break;
      case '3':
        _deleteUser(userRepo);
        break;
      case '4':
        _printCategories(categoryRepo);
        break;
      case '5':
        _addCategory(categoryRepo);
        break;
      case '6':
        _deleteCategory(categoryRepo);
        break;
      case '7':
        _printProducts(productRepo, categoryRepo);
        break;
      case '8':
        _addProduct(productRepo, categoryRepo);
        break;
      case '9':
        _deleteProduct(productRepo);
        break;
      case '10':
        _printCart(cartRepo, cartItemRepo, productRepo);
        break;
      case '11':
        _addToCart(cartRepo, cartItemRepo, productRepo, userRepo, categoryRepo);
        break;
      case '12':
        _deleteFromCart(cartItemRepo);
        break;
      case '13':
        _createOrder(cartRepo, cartItemRepo, orderRepo, orderItemRepo, productRepo, userRepo);
        break;
      case '14':
        _printOrders(orderRepo);
        break;
      case '15':
        _printAllFromDb(userRepo, categoryRepo, productRepo, orderRepo);
        break;
      case '0':
        stdout.writeln('До свидания.');
        return;
      default:
        stdout.writeln('Неизвестная команда.');
    }
    stdout.writeln();
  }
}

void _printUsers(UserRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Пользователей нет.');
    return;
  }
  for (final u in list) {
    stdout.writeln('id: ${u.id} | ${u.name} | ${u.phone}');
  }
}

void _printCategories(CategoryRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Категорий нет.');
    return;
  }
  for (final c in list) {
    stdout.writeln('id: ${c.id} | ${c.name}');
  }
}

void _printProducts(ProductRepository productRepo, CategoryRepository categoryRepo) {
  final list = productRepo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Товаров нет.');
    return;
  }
  final categories = categoryRepo.getAll();
  final catMap = {for (var c in categories) c.id: c.name};
  for (final p in list) {
    stdout.writeln('id: ${p.id} | ${p.name} | ${p.price} ₽ | ${catMap[p.categoryId]}');
  }
}

void _printCart(CartRepository cartRepo, CartItemRepository cartItemRepo, ProductRepository productRepo) {
  final userId = _read('id пользователя: ');
  final cart = cartRepo.getByUserId(userId);
  if (cart == null) {
    stdout.writeln('Корзина пуста.');
    return;
  }
  final items = cartItemRepo.getByCartId(cart.id);
  if (items.isEmpty) {
    stdout.writeln('Корзина пуста.');
    return;
  }
  double total = 0;
  for (final item in items) {
    final product = productRepo.getById(item.productId);
    final sum = (product?.price ?? 0) * item.quantity;
    total += sum;
    stdout.writeln('${item.id} | ${product?.name} | ${item.quantity} шт | ${sum} ₽');
  }
  stdout.writeln('Итого: $total ₽');
}

void _printOrders(OrderRepository repo) {
  final list = repo.getAll();
  if (list.isEmpty) {
    stdout.writeln('Заказов нет.');
    return;
  }
  for (final o in list) {
    stdout.writeln('id: ${o.id} | ${o.userId} | ${o.orderDate.toLocal()} | ${o.totalAmount} ₽ | ${o.status}');
  }
}

void _printAllFromDb(UserRepository userRepo, CategoryRepository categoryRepo, ProductRepository productRepo, OrderRepository orderRepo) {
  stdout.writeln('--- Пользователи ---');
  final users = userRepo.getAll();
  if (users.isEmpty) stdout.writeln('нет');
  else for (final u in users) stdout.writeln('${u.id} | ${u.name} | ${u.phone}');
  
  stdout.writeln('--- Категории ---');
  final categories = categoryRepo.getAll();
  if (categories.isEmpty) stdout.writeln('нет');
  else for (final c in categories) stdout.writeln('${c.id} | ${c.name}');
  
  stdout.writeln('--- Товары ---');
  final products = productRepo.getAll();
  if (products.isEmpty) stdout.writeln('нет');
  else for (final p in products) stdout.writeln('${p.id} | ${p.name} | ${p.price} ₽');
  
  stdout.writeln('--- Заказы ---');
  final orders = orderRepo.getAll();
  if (orders.isEmpty) stdout.writeln('нет');
  else for (final o in orders) stdout.writeln('${o.id} | ${o.userId} | ${o.totalAmount} ₽');
}

void _addUser(UserRepository repo) {
  final id = _read('id пользователя: ');
  final name = _read('имя: ');
  final phone = _read('телефон: ');
  final email = _read('email: ');
  final password = _read('пароль: ');

  repo.insert(User(
    id: id,
    name: name,
    phone: phone,
    email: email,
    passwordHash: password,
    registeredAt: DateTime.now(),
  ));
  stdout.writeln('Пользователь сохранён.');
}

void _deleteUser(UserRepository repo) {
  final id = _read('id пользователя для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _addCategory(CategoryRepository repo) {
  final id = _read('id категории: ');
  final name = _read('название: ');
  final description = _read('описание (можно пропустить): ');

  repo.insert(Category(
    id: id,
    name: name,
    description: description.isEmpty ? null : description,
  ));
  stdout.writeln('Категория сохранена.');
}

void _deleteCategory(CategoryRepository repo) {
  final id = _read('id категории для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _addProduct(ProductRepository productRepo, CategoryRepository categoryRepo) {
  stdout.writeln('Доступные категории:');
  _printCategories(categoryRepo);

  final id = _read('id товара: ');
  final name = _read('название: ');
  final description = _read('описание (можно пропустить): ');
  final categoryId = _read('id категории: ');
  final price = double.parse(_read('цена (число): ').replaceAll(',', '.'));
  final stock = int.parse(_read('количество на складе: '));

  productRepo.insert(Product(
    id: id,
    name: name,
    description: description.isEmpty ? null : description,
    categoryId: categoryId,
    price: price,
    stockQuantity: stock,
  ));
  stdout.writeln('Товар сохранён.');
}

void _deleteProduct(ProductRepository repo) {
  final id = _read('id товара для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _addToCart(CartRepository cartRepo, CartItemRepository cartItemRepo, ProductRepository productRepo, UserRepository userRepo, CategoryRepository categoryRepo) {
  stdout.writeln('Доступные пользователи:');
  _printUsers(userRepo);
  stdout.writeln('Доступные товары:');
  _printProducts(productRepo, categoryRepo);

  final userId = _read('id пользователя: ');
  final productId = _read('id товара: ');
  final quantity = int.parse(_read('количество: '));

  var cart = cartRepo.getByUserId(userId);
  if (cart == null) {
    final cartId = 'cart_$userId';
    cartRepo.insert(Cart(id: cartId, userId: userId));
    cart = cartRepo.getByUserId(userId);
  }

  cartItemRepo.insert(CartItem(
    id: 'ci_${DateTime.now().millisecondsSinceEpoch}',
    cartId: cart!.id,
    productId: productId,
    quantity: quantity,
  ));
  stdout.writeln('Товар добавлен в корзину.');
}

void _deleteFromCart(CartItemRepository repo) {
  final id = _read('id товара в корзине для удаления: ');
  repo.delete(id);
  stdout.writeln('Готово (если id был в базе).');
}

void _createOrder(CartRepository cartRepo, CartItemRepository cartItemRepo, OrderRepository orderRepo, OrderItemRepository orderItemRepo, ProductRepository productRepo, UserRepository userRepo) {
  final userId = _read('id пользователя: ');
  
  final cart = cartRepo.getByUserId(userId);
  if (cart == null) {
    stdout.writeln('Корзина пуста.');
    return;
  }
  
  final cartItems = cartItemRepo.getByCartId(cart.id);
  if (cartItems.isEmpty) {
    stdout.writeln('Корзина пуста.');
    return;
  }

  double total = 0;
  for (final item in cartItems) {
    final product = productRepo.getById(item.productId);
    if (product == null) {
      stdout.writeln('Товар ${item.productId} не найден.');
      return;
    }
    if (product.stockQuantity < item.quantity) {
      stdout.writeln('Недостаточно товара ${product.name}. Доступно: ${product.stockQuantity}');
      return;
    }
    total += product.price * item.quantity;
  }

  final address = _read('адрес доставки: ');
  final orderId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
  
  orderRepo.insert(Order(
    id: orderId,
    userId: userId,
    orderDate: DateTime.now(),
    totalAmount: total,
    status: 'Оформлен',
    deliveryAddress: address,
  ));

  for (final item in cartItems) {
    final product = productRepo.getById(item.productId)!;
    orderItemRepo.insert(OrderItem(
      id: 'oi_${DateTime.now().millisecondsSinceEpoch}_${item.productId}',
      orderId: orderId,
      productId: item.productId,
      quantity: item.quantity,
      priceAtMoment: product.price,
    ));
    productRepo.updateStock(item.productId, product.stockQuantity - item.quantity);
  }

  cartItemRepo.clearCart(cart.id);
  stdout.writeln('Заказ оформлен. ID: $orderId, сумма: $total ₽');
}

String _read(String label) {
  stdout.write(label);
  return stdin.readLineSync()?.trim() ?? '';
}
