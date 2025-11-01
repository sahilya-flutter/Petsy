import 'package:pesty/data/models/pet_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'petsy.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imageUrl TEXT,
        breed TEXT,
        age INTEGER,
        type TEXT
      )
    ''');
  }

  Future<int> insertPet(PetModel pet) async {
    Database db = await database;
    return await db.insert('pets', pet.toMap());
  }

  Future<List<PetModel>> getPets() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pets');
    return List.generate(maps.length, (i) => PetModel.fromMap(maps[i]));
  }

  Future<int> deletePet(int id) async {
    Database db = await database;
    return await db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }
}
