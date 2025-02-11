import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();

    if (oldVersion < 2) {
      batch.execute('ALTER TABLE orders ADD COLUMN isCompleted INTEGER DEFAULT 0');
    }
    if (oldVersion < 3) {
      try {
        batch.execute('ALTER TABLE orders DROP COLUMN orderId');
      } catch (e) {
        // Column might not exist, continue
      }
      batch.execute('ALTER TABLE orders ADD COLUMN orderId INTEGER');
      batch.execute('CREATE UNIQUE INDEX IF NOT EXISTS idx_orderId ON orders (orderId)');
    }
    if (oldVersion < 4) {
      batch.execute('ALTER TABLE orders ADD COLUMN displayOrderId TEXT');
    }
    if (oldVersion < 5) {
      try {
        final tableInfo = await db.rawQuery("PRAGMA table_info(orders)");
        final hasAddress = tableInfo.any((column) => column['name'] == 'address');
        if (!hasAddress) {
          batch.execute('ALTER TABLE orders ADD COLUMN address TEXT');
        }
      } catch (e) {
        print('Error checking/adding address column: $e');
      }
    }

    try {
      await batch.commit();
    } catch (e) {
      print('Error during database upgrade: $e');
    }
  }

  Future _createDB(Database db, int version) async {
    const orderTable = '''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT,
        deliveryDate TEXT NOT NULL,
        products TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        orderId INTEGER,
        displayOrderId TEXT UNIQUE
      )
    ''';
    await db.execute(orderTable);
    await db.execute('CREATE UNIQUE INDEX IF NOT EXISTS idx_orderId ON orders (orderId)');
  }

  Future<String> getNextDisplayOrderId() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT MAX(CAST(SUBSTR(displayOrderId, 2) AS INTEGER)) as maxId FROM orders');
    int nextId = 1;
    if (result.first['maxId'] != null) {
      nextId = (result.first['maxId'] as int) + 1;
    }
    return '#${nextId.toString().padLeft(5, '0')}';
  }

  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await instance.database;
    return await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> fetchOrdersByDate(String date, {bool excludeCompleted = false}) async {
    final db = await instance.database;
    String query = 'SELECT * FROM orders WHERE deliveryDate LIKE ?';
    if (excludeCompleted) {
      query += ' AND (isCompleted = 0 OR isCompleted IS NULL)';
    }
    query += ' ORDER BY displayOrderId DESC';
    return await db.rawQuery(query, ['$date%']);
  }

  Future<void> updateOrderCompletionStatus(String displayOrderId, bool isCompleted) async {
    final db = await instance.database;
    await db.update(
      'orders',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'displayOrderId = ?',
      whereArgs: [displayOrderId],
    );
  }

  // Single updateOrder method with error handling
  Future<int> updateOrder(Map<String, dynamic> order, String displayOrderId) async {
    try {
      final db = await instance.database;
      return await db.update(
        'orders',
        order,
        where: 'displayOrderId = ?',
        whereArgs: [displayOrderId],
      );
    } catch (e) {
      print('Error updating order: $e');
      throw e;
    }
  }

  Future<void> deleteOrder(String displayOrderId) async {
    final db = await instance.database;
    await db.delete(
      'orders',
      where: 'displayOrderId = ?',
      whereArgs: [displayOrderId],
    );
  }
}