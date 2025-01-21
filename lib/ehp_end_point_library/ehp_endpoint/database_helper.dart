import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE person_vt_test_result (
        person_vt_test_result_id INTEGER PRIMARY KEY AUTOINCREMENT,
        cid TEXT,
        person_vt_datetime TEXT,
        person_vt_type_id INTEGER,
        person_vt_test_result_decimal REAL,
        person_vt_test_result_text TEXT,
        officer_cid TEXT,
        person_vt_note TEXT,
        device_manufacturer TEXT,
        device_model TEXT,
        device_serial_no TEXT,
        location_latitude TEXT,
        location_longitude TEXT,
        ref_value1 REAL,
        ref_value2 REAL,
        eval_text TEXT,
        location_address TEXT
      )
    ''');
  }


  Future<void> truncateTable() async {
    Database db = await database;
    await db.execute('DELETE FROM person_vt_test_result');
    // Optionally, reset the auto-increment counter
    await db.execute('DELETE FROM sqlite_sequence WHERE name="person_vt_test_result"');
  }


  Future<int> deleteTestResultsByDateRange(String startDate, String endDate) async {
  Database db = await database;
  return await db.delete(
    'person_vt_test_result',
    where: 'person_vt_datetime BETWEEN ? AND ?',
    whereArgs: [startDate, endDate],
  );
}

  Future<int> insertTestResult(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('person_vt_test_result', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTestResults() async {
    Database db = await database;
    return await db.query('person_vt_test_result');
  }
}
