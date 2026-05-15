import 'package:sqlite3/sqlite3.dart';
import '../../domain/cart.dart';

class CartRepository {
  final Database _db;

  CartRepository(this._db);

  void insert(Cart cart) {
    _db.execute(
      'INSERT OR REPLACE INTO cart(id,userId) VALUES(?,?)',
      [cart.id, cart.userId],
    );
  }

  Cart? getByUserId(String userId) {
    final rows = _db.select('SELECT * FROM cart WHERE userId = ?', [userId]);
    return rows.isNotEmpty ? Cart.fromMap(rows.first) : null;
  }

  Cart? getById(String id) {
    final rows = _db.select('SELECT * FROM cart WHERE id = ?', [id]);
    return rows.isNotEmpty ? Cart.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _db.execute('DELETE FROM cart WHERE id = ?', [id]);
  }

  void deleteByUserId(String userId) {
    _db.execute('DELETE FROM cart WHERE userId = ?', [userId]);
  }
}
