import 'package:cycletowork/src/database/table_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class LocalDatabase {
  static final LocalDatabase db = LocalDatabase._internal();
  Database? _db;

  bool _isOpen = false;
  bool get isOpen => _isOpen;
  // static final Localstore _database = Localstore.instance;
  // static Localstore get database => _database;

  factory LocalDatabase() => LocalDatabase._internal();

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await open();
    return _db!;
  }

  _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _onCreate(Database db, int version) async {
    var batch = db.batch();
    for (String q in TableDatabase.getTables(version: version)) {
      batch.execute(q);
    }
    // var values = InitialDatabase.getValues(version: version);
    // for (var value in values) {
    //   for (var item in value.items) {
    //     batch.insert(
    //       value.tableName,
    //       item,
    //       conflictAlgorithm: ConflictAlgorithm.replace,
    //     );
    //   }
    // }
    await batch.commit();
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion; i <= newVersion; i++) {
      for (String q in TableDatabase.getTables(version: i)) {
        await db.execute(q);
      }
    }
  }

  _onOpen(Database db) {
    _isOpen = true;
  }

  /// Open database.
  ///
  /// [dbName] is name of database (optional).
  Future<Database> open({String dbName = 'cycle2work.db'}) async {
    var databasesPath = await getDatabasesPath();
    var _path = join(databasesPath, dbName);
    return await openDatabase(
      _path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: _onOpen,
    );
  }

  /// Close database.
  Future close() async {
    _db!.close();
    _isOpen = false;
  }

  /// Insert item into the database.
  ///
  /// Insert into [tableName], property must be non-null
  ///
  /// [item] is the item that insert into table. Item should be Map<String, dynamic> and non-null.
  ///
  /// Return the id of last row.
  Future<int> insertData({
    required String tableName,
    required Map<String, dynamic> item,
  }) async {
    final db = await database;
    var result = await db.insert(
      tableName,
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  /// Insert items into the database.
  ///
  /// Insert into [tableName]
  ///
  /// [items] are all items that insert into table. Items should be List<Map>.
  ///
  /// Return void.
  Future<void> insertAll({
    required String tableName,
    required List<Map<String, dynamic>> items,
  }) async {
    items.map(
      (item) async {
        await insertData(
          tableName: tableName,
          item: item,
        );
      },
    );
  }

  /// Get item from the database.
  ///
  /// Get item from [tableName]
  ///
  /// [whereCondition] filter declaring which rows to return, formatted as an SQL
  ///            WHERE clause (excluding the WHERE itself). Passing null will
  ///            return all rows for the given URL.
  ///
  /// [orderBy] How to order the rows, formatted as an SQL ORDER BY clause
  ///            (excluding the ORDER BY itself). Passing null will use the
  ///            default sort order, which may be unordered.
  /// [limit] Limits the number of rows returned by the query,
  ///
  /// Return List<Map> of items.
  Future<List<Map>> getData({
    required String tableName,
    String? whereCondition,
    String? orderBy,
    int? limit,
    List? whereArgs,
    int? offset,
  }) async {
    final db = await database;
    var result = await db.query(
      tableName,
      where: whereCondition,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return result;
  }

  /// Convenience method for updating rows in the database.
  ///
  /// Update [tableName] with [item], a map from column names to new column
  /// values. null is a valid value that will be translated to NULL.
  ///
  /// [where] is the optional WHERE clause to apply when updating.
  /// Passing null will update all rows.
  ///
  /// Return the id of last row.
  Future<int> updateData({
    required String tableName,
    required Map<String, dynamic> item,
    String? whereCondition,
    List? whereArgs,
  }) async {
    final db = await database;
    var result = await db.update(
      tableName,
      item,
      where: whereCondition,
      whereArgs: whereArgs,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  /// Convenience method for deleting rows in the database.
  ///
  /// Delete from [tableName]
  ///
  /// [where] is the optional WHERE clause to apply when updating. Passing null
  /// will update all rows.
  ///
  /// Returns the number of rows affected if a whereClause is passed in, 0
  /// otherwise. To remove all rows and get a count pass "1" as the
  /// whereClause.
  Future<int> deleteData({
    required String tableName,
    String? whereCondition,
  }) async {
    final db = await database;
    var result = await db.delete(
      tableName,
      where: whereCondition,
    );
    return result;
  }

  Future<List<Map>> rawQuery(String query) async {
    final db = await database;
    return await db.rawQuery(query);
  }
}
