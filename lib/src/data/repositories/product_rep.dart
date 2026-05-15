import 'package:sqlite3/sqlite3.dart';
import '../../domain/product.dart';

class ProductRepository {
  final Database _db;

  ProductRepository(this._db);

  void insert(Product product) {
    _db.execute(
      'INSERT OR REPLACE INTO products(id,name,description,categoryId,price,stockQuantity) VALUES(?,?,?,?,?,?)',
      [product.id, product.name, product.description, product.categoryId, product.price, product.stockQuantity],
    );
  }

  List<Product> getAll() {
    final rows = _db.select('SELECT * FROM products');
    return rows.map((row) => Product.fromMap(row)).toList();
  }

  Product? getById(String id) {
    final rows = _db.select('SELECT * FROM products WHERE id = ?', [id]);
    return rows.isNotEmpty ? Product.fromMap(rows.first) : null;
  }

  void update(Product product) {
    _db.execute(
      'UPDATE products SET name=?, description=?, categoryId=?, price=?, stockQuantity=? WHERE id=?',
      [product.name, product.description, product.categoryId, product.price, product.stockQuantity, product.id],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM products WHERE id = ?', [id]);
  }

  void updateStock(String productId, int newQuantity) {
    _db.execute('UPDATE products SET stockQuantity = ? WHERE id = ?', [newQuantity, productId]);
  }
}
