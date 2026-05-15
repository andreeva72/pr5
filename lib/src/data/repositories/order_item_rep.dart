import 'package:sqlite3/sqlite3.dart';
import '../../models/order_item.dart';

class OrderItemRepository {
  final Database _db;

  OrderItemRepository(this._db);

  void insert(OrderItem item) {
    _db.execute(
      'INSERT OR REPLACE INTO order_items(id,orderId,productId,quantity,priceAtMoment) VALUES(?,?,?,?,?)',
      [item.id, item.orderId, item.productId, item.quantity, item.priceAtMoment],
    );
  }

  List<OrderItem> getByOrderId(String orderId) {
    final rows = _db.select('SELECT * FROM order_items WHERE orderId = ?', [orderId]);
    return rows.map((row) => OrderItem.fromMap(row)).toList();
  }

  void delete(String id) {
    _db.execute('DELETE FROM order_items WHERE id = ?', [id]);
  }

  void deleteByOrderId(String orderId) {
    _db.execute('DELETE FROM order_items WHERE orderId = ?', [orderId]);
  }
}