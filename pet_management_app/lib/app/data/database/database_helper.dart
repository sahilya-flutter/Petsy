import 'package:pet_management_app/app/data/model/appointment_model.dart';
import 'package:pet_management_app/app/data/model/pet_model.dart';
import 'package:pet_management_app/app/data/model/reminder_model.dart';
import 'package:pet_management_app/app/data/model/user_model.dart';
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
    const intType = 'INTEGER NOT NULL';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        email $textType UNIQUE,
        password $textType,
        created_at $textType
      )
    ''');

    // Pets table
    await db.execute('''
      CREATE TABLE pets (
        id $idType,
        user_id $intType,
        name $textType,
        species $textType,
        breed $textType,
        birthday $textType,
        image_url TEXT,
        notes TEXT,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Appointments table
    await db.execute('''
      CREATE TABLE appointments (
        id $idType,
        user_id $intType,
        pet_id $intType,
        title $textType,
        description TEXT,
        appointment_date $textType,
        location $textType,
        is_completed INTEGER DEFAULT 0,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE
      )
    ''');

    // Reminders table
    await db.execute('''
      CREATE TABLE reminders (
        id $idType,
        user_id $intType,
        pet_id INTEGER,
        title $textType,
        description TEXT,
        reminder_date $textType,
        frequency $textType,
        is_active INTEGER DEFAULT 1,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE SET NULL
      )
    ''');
  }

  // User operations
  Future<int> createUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // Pet operations
  Future<int> createPet(PetModel pet) async {
    final db = await database;
    return await db.insert('pets', pet.toMap());
  }

  Future<List<PetModel>> getPetsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'pets',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PetModel.fromMap(map)).toList();
  }

  Future<int> updatePet(PetModel pet) async {
    final db = await database;
    return await db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  Future<int> deletePet(int id) async {
    final db = await database;
    return await db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  // Appointment operations
  Future<int> createAppointment(AppointmentModel appointment) async {
    final db = await database;
    return await db.insert('appointments', appointment.toMap());
  }

  Future<List<AppointmentModel>> getAppointmentsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'appointments',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'appointment_date ASC',
    );
    return maps.map((map) => AppointmentModel.fromMap(map)).toList();
  }

  Future<int> updateAppointment(AppointmentModel appointment) async {
    final db = await database;
    return await db.update(
      'appointments',
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> deleteAppointment(int id) async {
    final db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  // Reminder operations
  Future<int> createReminder(ReminderModel reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<ReminderModel>> getRemindersByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'reminders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'reminder_date ASC',
    );
    return maps.map((map) => ReminderModel.fromMap(map)).toList();
  }

  Future<int> updateReminder(ReminderModel reminder) async {
    final db = await database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
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
