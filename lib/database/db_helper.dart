import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/friend.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB("splitmoney.db");
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE friends(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        balance REAL NOT NULL
      )
    ''');
  }

  // CRUD Operations

  Future<int> addFriend(Friend friend) async {
    final db = await database;
    return await db.insert('friends', friend.toMap());
  }

  Future<List<Friend>> getFriends() async {
    final db = await database;
    final result = await db.query('friends');
    return result.map((json) => Friend.fromMap(json)).toList();
  }

  Future<int> updateFriend(Friend friend) async {
    final db = await database;
    return await db.update(
      'friends',
      friend.toMap(),
      where: 'id = ?',
      whereArgs: [friend.id],
    );
  }

  Future<int> deleteFriend(int id) async {
    final db = await database;
    return await db.delete(
      'friends',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
