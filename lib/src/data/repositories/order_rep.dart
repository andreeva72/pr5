import 'package:sqlite3/sqlite3.dart';
import '../../models/order.dart';

class OrderRepository {
  final Database _db;

  OrderRepository(this._db);

  void insert(Order order) {
    _db.execute(
      'INSERT OR REPLACE INTO orders(id,userId,orderDate,totalAmount,status,deliveryAddress) VALUES(?,?,?,?,?,?)',
      [order.id, order.userId, order.orderDate.toIso8601String(), order.totalAmount, order.status, order.deliveryAddress],
    );
  }

  List<Order> getAll() {
    final rows = _db.select('SELECT * FROM orders');
    return rows.map((row) => Order.fromMap(row)).toList();
  }

  List<Order> getByUserId(String userId) {
    final rows = _db.select('SELECT * FROM orders WHERE userId = ?', [userId]);
    return rows.map((row) => Order.fromMap(row)).toList();
  }

  Order? getById(String id) {
    final rows = _db.select('SELECT * FROM orders WHERE id = ?', [id]);
    return rows.isNotEmpty ? Order.fromMap(rows.first) : null;
  }

  void updateStatus(String id, String newStatus) {
    _db.execute('UPDATE orders SET status = ? WHERE id = ?', [newStatus, id]);
  }

  void delete(String id) {
    _db.execute('DELETE FROM orders WHERE id = ?', [id]);
  }
}