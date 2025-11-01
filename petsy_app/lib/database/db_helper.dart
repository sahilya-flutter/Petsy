// SQLite database helper class
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('petsy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Pets Table
    await db.execute('''
      CREATE TABLE pets (
        id $idType,
        userId $textType,
        name $textType,
        species $textType,
        breed $textType,
        gender $textType,
        birthday $textType,
        imageUrl TEXT,
        createdAt $textType
      )
    ''');

    // Appointments Table
    await db.execute('''
      CREATE TABLE appointments (
        id $idType,
        userId $textType,
        petId $integerType,
        title $textType,
        type $textType,
        date $textType,
        time $textType,
        location TEXT,
        notes TEXT,
        createdAt $textType
      )
    ''');

    // Reminders Table
    await db.execute('''
      CREATE TABLE reminders (
        id $idType,
        userId $textType,
        petId $integerType,
        title $textType,
        description TEXT,
        date $textType,
        time $textType,
        isCompleted $integerType,
        createdAt $textType
      )
    ''');
  }

  // Pet CRUD Operations
  Future<int> insertPet(Map<String, dynamic> pet) async {
    final db = await database;
    return await db.insert('pets', pet);
  }

  Future<List<Map<String, dynamic>>> getPets(String userId) async {
    final db = await database;
    return await db.query(
      'pets',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
  }

  Future<int> updatePet(int id, Map<String, dynamic> pet) async {
    final db = await database;
    return await db.update('pets', pet, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePet(int id) async {
    final db = await database;
    return await db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  // Appointment CRUD Operations
  Future<int> insertAppointment(Map<String, dynamic> appointment) async {
    final db = await database;
    return await db.insert('appointments', appointment);
  }

  Future<List<Map<String, dynamic>>> getAppointments(String userId) async {
    final db = await database;
    return await db.query(
      'appointments',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, time DESC',
    );
  }

  Future<int> updateAppointment(
    int id,
    Map<String, dynamic> appointment,
  ) async {
    final db = await database;
    return await db.update(
      'appointments',
      appointment,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAppointment(int id) async {
    final db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  // Reminder CRUD Operations
  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder);
  }

  Future<List<Map<String, dynamic>>> getReminders(String userId) async {
    final db = await database;
    return await db.query(
      'reminders',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, time DESC',
    );
  }

  Future<int> updateReminder(int id, Map<String, dynamic> reminder) async {
    final db = await database;
    return await db.update(
      'reminders',
      reminder,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
