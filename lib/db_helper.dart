import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'smart_cart_assets_v3.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE master_products(
            id TEXT PRIMARY KEY,
            name TEXT,
            price REAL,
            description TEXT,
            image_path TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE local_cart(
            id TEXT PRIMARY KEY,
            product_id TEXT,
            name TEXT,
            price REAL,
            image_path TEXT,
            quantity INTEGER
          )
        ''');

        await db.insert('master_products', {
          'id': '1',
          'name': 'Laptop ASUS VivoBook',
          'price': 8499000.0,
          'description': '14" | Core i5 | 8GB | 512GB',
          'image_path': 'assets/laptop.jpg',
        });
        await db.insert('master_products', {
          'id': '2',
          'name': 'Samsung Galaxy A55',
          'price': 5999000.0,
          'description': '6.5" | 8GB | 256GB',
          'image_path': 'assets/samsung.jpg',
        });
        await db.insert('master_products', {
          'id': '3',
          'name': 'Sony WH-CH720N',
          'price': 2199000.0,
          'description': 'Headphone Noise Cancelling',
          'image_path': 'assets/sony.jpg',
        });
        await db.insert('master_products', {
          'id': '4',
          'name': 'Smart TV Samsung 43"',
          'price': 4500000.0,
          'description': '4K UHD | Smart Hub',
          'image_path': 'assets/smarttv.jpg',
        });
      },
    );
  }

  Future<void> insertProduct(Product p) async {
    final dbClient = await db;
    await dbClient.insert(
      'master_products',
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getProducts() async {
    final dbClient = await db;
    final res = await dbClient.query('master_products');
    return res.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> insertCartItem(CartItem item) async {
    final dbClient = await db;
    await dbClient.insert(
      'local_cart',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartItem>> getCartItems() async {
    final dbClient = await db;
    final res = await dbClient.query('local_cart');
    return res.map((e) => CartItem.fromMap(e)).toList();
  }

  Future<void> updateCartQuantity(String id, int quantity) async {
    final dbClient = await db;
    if (quantity <= 0) {
      await deleteCartItem(id);
    } else {
      await dbClient.update(
        'local_cart',
        {'quantity': quantity},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> deleteCartItem(String id) async {
    final dbClient = await db;
    await dbClient.delete('local_cart', where: 'id = ?', whereArgs: [id]);
  }
}
