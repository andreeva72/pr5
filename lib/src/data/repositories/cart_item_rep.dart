import 'package:sqlite3/sqlite3.dart';
import '../../domain/cart_item.dart';

class CartItemRepository {
  final Database _db;

  CartItemRepository(this._db);

  void insert(CartItem item) {
    _db.execute(
      'INSERT OR REPLACE INTO cart_items(id,cartId,productId,quantity) VALUES(?,?,?,?)',
      [item.id, item.cartId, item.productId, item.quantity],
    );
  }

  List<CartItem> getByCartId(String cartId) {
    final rows = _db.select('SELECT * FROM cart_items WHERE cartId = ?', [cartId]);
    return rows.map((row) => CartItem.fromMap(row)).toList();
  }

  CartItem? getById(String id) {
    final rows = _db.select('SELECT * FROM cart_items WHERE id = ?', [id]);
    return rows.isNotEmpty ? CartItem.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.execute('DELETE FROM cart_items WHERE id = ?', [id]);
  }

  void deleteByCartId(String cartId) {
    _db.execute('DELETE FROM cart_items WHERE cartId = ?', [cartId]);
  }

  void clearCart(String cartId) {
    _db.execute('DELETE FROM cart_items WHERE cartId = ?', [cartId]);
  }
}
