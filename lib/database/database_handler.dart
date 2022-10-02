import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static String dbName = "my.db";
  static int dbVersion = 1;
  static String productTable = "Products";
  static String variantsTable = "Variants";
  static String ordersTable = "Orders";
  static String orderItemsTable = "OrderItems";

  // columns
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDesc = 'desc';
  static const columnStockCount = 'stock_count';
  static const columnProductId = 'product_id';
  static const columnPrice = 'price';
  static const columnUnitValue = 'unit';
  static const columnTotal = 'total';
  static const createAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const columnVariantId = 'variant_id';
  static const columnOrderId = 'order_id';
  static const columnQuantity = 'quantity';
  static const columnVariantName = 'variant_name';
  static const columnProductName = 'product_name';

  // make this a singleton class
  DatabaseHandler._privateConstructor();

  static final DatabaseHandler instance = DatabaseHandler._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  Future<int> insert(String tableName, {Map<String, dynamic>? data}) async {
    Database? db = await instance.database;
    Map<String, dynamic> insertData = data!;
    insertData[createAt] = DateTime.now().toIso8601String();
    insertData[updatedAt] = DateTime.now().toIso8601String();
    return await db!.insert(tableName, insertData);
  }

  Future<int> updateData(String tableName, int id,
      {Map<String, dynamic>? data}) async {
    Database? db = await instance.database;
    Map<String, dynamic> insertData = data!;
    insertData[updatedAt] = DateTime.now().toIso8601String();
    return await db!.update(
      tableName,
      insertData,
      where: columnId + " = ?",
      whereArgs: [id],
    );
  }

  // get data from table

  Future<List<Map<String, Object?>>> getDataFromTable(String tableName,
      {String? whereColumnName, String? value}) async {
    Database? db = await instance.database;
    if (whereColumnName != null) {
      return await db!.query(tableName,
          where: whereColumnName + " = ?",
          whereArgs: [value],
          orderBy: "$columnId DESC");
    } else {
      return await db!.query(tableName, orderBy: "$columnId DESC");
    }
  }

  Future<List<Map<String, Object?>>> getDataByJoiningTables(
      String table1, String table2) async {
    Database? db = await instance.database;
    return await db!.rawQuery("SELECT $table1.$columnName,$table1.$columnDesc, "
        "$table1.$columnId,$table2.$columnId"
        ",$table2.$columnName"
        ",$table2.$columnDesc,$table2.$columnProductId,"
        "$table2.$columnPrice,$table2.$columnUnitValue FROM $table1 JOIN $table2 ON $table1.$columnId=$table2.$columnProductId");
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $productTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnDesc TEXT NOT NULL,
            $columnStockCount num,
            $createAt DATETIME,
            $updatedAt DATETIME
                        
          )
          ''');

    await db.execute('''
          CREATE TABLE $variantsTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnDesc TEXT NOT NULL,
            $columnProductId INTEGER NOT NULL,
            $columnPrice num NOT NULL,
            $columnUnitValue num NOT NULL,
              $createAt DATETIME,
            $updatedAt DATETIME
          )
          ''');
    await db.execute('''
          CREATE TABLE $ordersTable (
            $columnId num PRIMARY KEY,
            $columnTotal num NOT NULL,
            $createAt DATETIME,
            $updatedAt DATETIME
            
          )
          ''');

    await db.execute('''
          CREATE TABLE $orderItemsTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnVariantId INTEGER NOT NULL,
            $columnQuantity num NOT NULL,
            $columnPrice num NOT NULL,
            $columnVariantName TEXT NOT NULL,
            $columnUnitValue num NOT NULL,
            $columnOrderId INTEGER NOT NULL,
            $columnProductId INTEGER NOT NULL,
            $columnProductName TEXT NOT NULL,
            $createAt DATETIME,
            $updatedAt DATETIME
          )
          ''');
  }

  // delete
  Future<int> deleteData(String tableName, int id) async {
    Database? db = await instance.database;
    return await db!.delete(tableName, where: "id=?", whereArgs: [id]);
  }
}
