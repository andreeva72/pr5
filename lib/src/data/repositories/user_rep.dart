import 'package:sqlite3/sqlite3.dart';
import '../../models/user.dart';

class UserRepository {
  final Database _db;

  UserRepository(this._db);

  void insert(User user) {
    _db.execute(
      'INSERT OR REPLACE INTO users(id,name,phone,email,passwordHash,registeredAt) VALUES(?,?,?,?,?,?)',
      [user.id, user.name, user.phone, user.email, user.passwordHash, user.registeredAt.toIso8601String()],
    );
  }

  List<User> getAll() {
    final rows = _db.select('SELECT * FROM users');
    return rows.map((row) => User.fromMap(row)).toList();
  }

  User? getById(String id) {
    final rows = _db.select('SELECT * FROM users WHERE id = ?', [id]);
    return rows.isNotEmpty ? User.fromMap(rows.first) : null;
  }

  void update(User user) {
    _db.execute(
      'UPDATE users SET name=?, phone=?, email=?, passwordHash=? WHERE id=?',
      [user.name, user.phone, user.email, user.passwordHash, user.id],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM users WHERE id = ?', [id]);
  }
}