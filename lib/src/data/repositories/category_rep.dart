import 'package:sqlite3/sqlite3.dart';
import '../../models/category.dart';

class CategoryRepository {
  final Database _db;

  CategoryRepository(this._db);

  void insert(Category category) {
    _db.execute(
      'INSERT OR REPLACE INTO categories(id,name,description) VALUES(?,?,?)',
      [category.id, category.name, category.description],
    );
  }

  List<Category> getAll() {
    final rows = _db.select('SELECT * FROM categories');
    return rows.map((row) => Category.fromMap(row)).toList();
  }

  Category? getById(String id) {
    final rows = _db.select('SELECT * FROM categories WHERE id = ?', [id]);
    return rows.isNotEmpty ? Category.fromMap(rows.first) : null;
  }

  void update(Category category) {
    _db.execute(
      'UPDATE categories SET name=?, description=? WHERE id=?',
      [category.name, category.description, category.id],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM categories WHERE id = ?', [id]);
  }
}