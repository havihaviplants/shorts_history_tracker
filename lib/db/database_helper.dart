import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // 🔹 싱글턴 패턴 적용 (단일 인스턴스 사용)
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor(); // Private 생성자

  // 🔹 데이터베이스 가져오기 (없으면 생성)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 🔹 SQLite 데이터베이스 초기화
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // 최초 실행 시 테이블 생성
    );
  }

  // 🔹 테이블 생성 쿼리 실행
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT UNIQUE,
        folder TEXT,
        dateTime TEXT
      )
    ''');
  }
}

