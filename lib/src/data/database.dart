import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class FlowerDatabase {
  final Database _db;

  FlowerDatabase(String path) : _db = sqlite3.open(path) {
    _createTables();
  }

  factory FlowerDatabase.inApp() {
    final path = p.join(Directory.current.path, 'flower_shop.db');
    return FlowerDatabase(path);
  }

  Database get db => _db;

  void _createTables() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        passwordHash TEXT NOT NULL,
        registeredAt TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        categoryId TEXT NOT NULL,
        price REAL NOT NULL,
        stockQuantity INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS cart (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL UNIQUE,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS cart_items (
        id TEXT PRIMARY KEY,
        cartId TEXT NOT NULL,
        productId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (cartId) REFERENCES cart(id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        orderDate TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        status TEXT NOT NULL,
        deliveryAddress TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS order_items (
        id TEXT PRIMARY KEY,
        orderId TEXT NOT NULL,
        productId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        priceAtMoment REAL NOT NULL,
        FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');
  }

  void close() {
    _db.dispose();
  }
}