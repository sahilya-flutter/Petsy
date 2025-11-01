import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

// Main App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<DatabaseService>(
    () async => await DatabaseService().init(),
  );
  runApp(const PetsyApp());
}

class PetsyApp extends StatelessWidget {
  const PetsyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'Petsy',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xFF6366F1),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) {
              return controller.isLoggedIn.value
                  ? const HomeScreen()
                  : const AuthScreen();
            },
          ),
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const AuthScreen()),
            GetPage(name: '/home', page: () => const HomeScreen()),
            GetPage(name: '/pet-profile', page: () => const PetProfileScreen()),
            GetPage(
              name: '/appointments',
              page: () => const AppointmentsScreen(),
            ),
            GetPage(name: '/reminders', page: () => const RemindersScreen()),
          ],
        );
      },
    );
  }
}

// ==================== DATABASE SERVICE ====================
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late Database _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<DatabaseService> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'petsy.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            email TEXT UNIQUE,
            password TEXT,
            profileImage TEXT,
            createdAt TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE pets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            name TEXT,
            species TEXT,
            breed TEXT,
            birthday TEXT,
            weight REAL,
            profileImage TEXT,
            createdAt TEXT,
            FOREIGN KEY(userId) REFERENCES users(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE appointments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            petId INTEGER,
            title TEXT,
            description TEXT,
            appointmentDate TEXT,
            veterinarian TEXT,
            clinic TEXT,
            status TEXT,
            createdAt TEXT,
            FOREIGN KEY(petId) REFERENCES pets(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE reminders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            petId INTEGER,
            title TEXT,
            description TEXT,
            reminderDate TEXT,
            reminderTime TEXT,
            isCompleted INTEGER,
            createdAt TEXT,
            FOREIGN KEY(petId) REFERENCES pets(id)
          )
        ''');
      },
      version: 1,
    );
    return this;
  }

  Database get database => _database;

  // User Operations
  Future<int> createUser(Map<String, dynamic> user) =>
      _database.insert('users', user);

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final result = await _database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final result = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Pet Operations
  Future<int> createPet(Map<String, dynamic> pet) =>
      _database.insert('pets', pet);

  Future<List<Map<String, dynamic>>> getPetsByUser(int userId) =>
      _database.query('pets', where: 'userId = ?', whereArgs: [userId]);

  Future<int> updatePet(int id, Map<String, dynamic> pet) =>
      _database.update('pets', pet, where: 'id = ?', whereArgs: [id]);

  Future<int> deletePet(int id) =>
      _database.delete('pets', where: 'id = ?', whereArgs: [id]);

  // Appointment Operations
  Future<int> createAppointment(Map<String, dynamic> appointment) =>
      _database.insert('appointments', appointment);

  Future<List<Map<String, dynamic>>> getAppointmentsByPet(int petId) =>
      _database.query(
        'appointments',
        where: 'petId = ?',
        whereArgs: [petId],
        orderBy: 'appointmentDate',
      );

  Future<int> updateAppointment(int id, Map<String, dynamic> appointment) =>
      _database.update(
        'appointments',
        appointment,
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<int> deleteAppointment(int id) =>
      _database.delete('appointments', where: 'id = ?', whereArgs: [id]);

  // Reminder Operations
  Future<int> createReminder(Map<String, dynamic> reminder) =>
      _database.insert('reminders', reminder);

  Future<List<Map<String, dynamic>>> getRemindersByPet(int petId) =>
      _database.query(
        'reminders',
        where: 'petId = ?',
        whereArgs: [petId],
        orderBy: 'reminderDate',
      );

  Future<int> updateReminder(int id, Map<String, dynamic> reminder) =>
      _database.update('reminders', reminder, where: 'id = ?', whereArgs: [id]);

  Future<int> deleteReminder(int id) =>
      _database.delete('reminders', where: 'id = ?', whereArgs: [id]);
}

// ==================== MODELS ====================
class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? profileImage;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

class PetModel {
  final int? id;
  final int userId;
  final String name;
  final String species;
  final String breed;
  final DateTime birthday;
  final double weight;
  final String? profileImage;

  PetModel({
    this.id,
    required this.userId,
    required this.name,
    required this.species,
    required this.breed,
    required this.birthday,
    required this.weight,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'species': species,
      'breed': breed,
      'birthday': birthday.toIso8601String(),
      'weight': weight,
      'profileImage': profileImage,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  int get ageInYears {
    return DateTime.now().year - birthday.year;
  }
}

class AppointmentModel {
  final int? id;
  final int petId;
  final String title;
  final String description;
  final DateTime appointmentDate;
  final String veterinarian;
  final String clinic;
  final String status;

  AppointmentModel({
    this.id,
    required this.petId,
    required this.title,
    required this.description,
    required this.appointmentDate,
    required this.veterinarian,
    required this.clinic,
    this.status = 'scheduled',
  });

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'title': title,
      'description': description,
      'appointmentDate': appointmentDate.toIso8601String(),
      'veterinarian': veterinarian,
      'clinic': clinic,
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

class ReminderModel {
  final int? id;
  final int petId;
  final String title;
  final String description;
  final DateTime reminderDate;
  final TimeOfDay reminderTime;
  final bool isCompleted;

  ReminderModel({
    this.id,
    required this.petId,
    required this.title,
    required this.description,
    required this.reminderDate,
    required this.reminderTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'title': title,
      'description': description,
      'reminderDate': reminderDate.toIso8601String(),
      'reminderTime':
          '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}',
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

// ==================== CONTROLLERS ====================
class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;

  final _db = Get.find<DatabaseService>();

  Future<void> signup(String name, String email, String password) async {
    try {
      isLoading.value = true;
      final user = UserModel(name: name, email: email, password: password);
      final userId = await _db.createUser(user.toMap());
      currentUser.value = UserModel(
        id: userId,
        name: name,
        email: email,
        password: password,
      );
      isLoggedIn.value = true;
      Get.offNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Signup failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _db.getUserByEmail(email);
      if (user != null && user['password'] == password) {
        currentUser.value = UserModel(
          id: user['id'],
          name: user['name'],
          email: user['email'],
          password: user['password'],
        );
        isLoggedIn.value = true;
        Get.offNamed('/home');
      } else {
        Get.snackbar('Error', 'Invalid email or password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    currentUser.value = null;
    Get.offNamed('/');
  }
}

class PetController extends GetxController {
  final pets = <PetModel>[].obs;
  final isLoading = false.obs;
  final _db = Get.find<DatabaseService>();
  final authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      isLoading.value = true;
      if (authController.currentUser.value?.id != null) {
        final petMaps = await _db.getPetsByUser(
          authController.currentUser.value!.id!,
        );
        pets.value = petMaps
            .map(
              (p) => PetModel(
                id: p['id'],
                userId: p['userId'],
                name: p['name'],
                species: p['species'],
                breed: p['breed'],
                birthday: DateTime.parse(p['birthday']),
                weight: p['weight'],
                profileImage: p['profileImage'],
              ),
            )
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPet(PetModel pet) async {
    try {
      await _db.createPet(pet.toMap());
      await loadPets();
      Get.snackbar('Success', 'Pet added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add pet: $e');
    }
  }

  Future<void> updatePet(int id, PetModel pet) async {
    try {
      await _db.updatePet(id, pet.toMap());
      await loadPets();
      Get.snackbar('Success', 'Pet updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update pet: $e');
    }
  }

  Future<void> deletePet(int id) async {
    try {
      await _db.deletePet(id);
      await loadPets();
      Get.snackbar('Success', 'Pet deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete pet: $e');
    }
  }
}

class AppointmentController extends GetxController {
  final appointments = <AppointmentModel>[].obs;
  final isLoading = false.obs;
  final _db = Get.find<DatabaseService>();

  Future<void> loadAppointments(int petId) async {
    try {
      isLoading.value = true;
      final appointmentMaps = await _db.getAppointmentsByPet(petId);
      appointments.value = appointmentMaps
          .map(
            (a) => AppointmentModel(
              id: a['id'],
              petId: a['petId'],
              title: a['title'],
              description: a['description'],
              appointmentDate: DateTime.parse(a['appointmentDate']),
              veterinarian: a['veterinarian'],
              clinic: a['clinic'],
              status: a['status'],
            ),
          )
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    try {
      await _db.createAppointment(appointment.toMap());
      await loadAppointments(appointment.petId);
      Get.snackbar('Success', 'Appointment booked successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to book appointment: $e');
    }
  }

  Future<void> updateAppointment(int id, AppointmentModel appointment) async {
    try {
      await _db.updateAppointment(id, appointment.toMap());
      await loadAppointments(appointment.petId);
      Get.snackbar('Success', 'Appointment updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update appointment: $e');
    }
  }

  Future<void> cancelAppointment(int id, int petId) async {
    try {
      await _db.deleteAppointment(id);
      await loadAppointments(petId);
      Get.snackbar('Success', 'Appointment cancelled');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel appointment: $e');
    }
  }
}

class ReminderController extends GetxController {
  final reminders = <ReminderModel>[].obs;
  final isLoading = false.obs;
  final _db = Get.find<DatabaseService>();

  Future<void> loadReminders(int petId) async {
    try {
      isLoading.value = true;
      final reminderMaps = await _db.getRemindersByPet(petId);
      reminders.value = reminderMaps.map((r) {
        final timeParts = r['reminderTime'].split(':');
        return ReminderModel(
          id: r['id'],
          petId: r['petId'],
          title: r['title'],
          description: r['description'],
          reminderDate: DateTime.parse(r['reminderDate']),
          reminderTime: TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          ),
          isCompleted: r['isCompleted'] == 1,
        );
      }).toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createReminder(ReminderModel reminder) async {
    try {
      await _db.createReminder(reminder.toMap());
      await loadReminders(reminder.petId);
      Get.snackbar('Success', 'Reminder created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create reminder: $e');
    }
  }

  Future<void> completeReminder(int id, int petId) async {
    try {
      await _db.updateReminder(id, {'isCompleted': 1});
      await loadReminders(petId);
      Get.snackbar('Success', 'Reminder marked as complete');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update reminder: $e');
    }
  }

  Future<void> deleteReminder(int id, int petId) async {
    try {
      await _db.deleteReminder(id);
      await loadReminders(petId);
      Get.snackbar('Success', 'Reminder deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete reminder: $e');
    }
  }
}

// ==================== SCREENS ====================
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authController = Get.put(AuthController());
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Text(
                'Petsy',
                style: TextStyle(
                  fontSize: 8.w,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6366F1),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                _isSignup ? 'Create Account' : 'Welcome Back',
                style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4.h),
              if (_isSignup)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              if (_isSignup) SizedBox(height: 2.h),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => SizedBox(
                  width: 100.w,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                            if (_isSignup) {
                              authController.signup(
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                              );
                            } else {
                              authController.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isSignup ? 'Sign Up' : 'Log In',
                            style: TextStyle(
                              fontSize: 4.w,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignup
                        ? 'Already have an account? '
                        : 'Don\'t have an account? ',
                    style: TextStyle(fontSize: 3.5.w),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isSignup = !_isSignup),
                    child: Text(
                      _isSignup ? 'Log In' : 'Sign Up',
                      style: TextStyle(
                        fontSize: 3.5.w,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    Get.put(PetController());
    Get.put(AppointmentController());
    Get.put(ReminderController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Pets',
          style: TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Pets',
              style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            GetBuilder<PetController>(
              init: Get.find<PetController>(),
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return controller.pets.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(height: 5.h),
                            Text(
                              'No pets yet',
                              style: TextStyle(
                                fontSize: 4.w,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 15.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.pets.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.pets.length) {
                              return Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: GestureDetector(
                                  onTap: () => Get.toNamed(
                                    '/pet-profile',
                                    arguments: {'isNew': true},
                                  ),
                                  child: Container(
                                    width: 25.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(2.w),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 8.w,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            final pet = controller.pets[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: GestureDetector(
                                onTap: () => Get.toNamed(
                                  '/pet-profile',
                                  arguments: {'pet': pet, 'isNew': false},
                                ),
                                child: Container(
                                  width: 25.w,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _getSpeciesEmoji(pet.species),
                                        style: TextStyle(fontSize: 10.w),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        pet.name,
                                        style: TextStyle(
                                          fontSize: 3.5.w,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
            SizedBox(height: 4.h),
            Text(
              'Services',
              style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 2.w,
              crossAxisSpacing: 2.w,
              children: [
                _ServiceTile(
                  icon: '🏥',
                  label: 'Appointments',
                  onTap: () => Get.toNamed('/appointments'),
                ),
                _ServiceTile(
                  icon: '🔔',
                  label: 'Reminders',
                  onTap: () => Get.toNamed('/reminders'),
                ),
                _ServiceTile(icon: '💉', label: 'Vaccine', onTap: () {}),
                _ServiceTile(icon: '🛁', label: 'Grooming', onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getSpeciesEmoji(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return '🐕';
      case 'cat':
        return '🐈';
      case 'rabbit':
        return '🐰';
      default:
        return '🐾';
    }
  }
}

class _ServiceTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Text(icon, style: TextStyle(fontSize: 8.w)),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(fontSize: 3.w, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({Key? key}) : super(key: key);

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;
  late DateTime _selectedBirthday;

  final petController = Get.find<PetController>();
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    final isNew = arguments?['isNew'] ?? true;
    final pet = arguments?['pet'] as PetModel?;

    if (isNew) {
      _nameController = TextEditingController();
      _speciesController = TextEditingController();
      _breedController = TextEditingController();
      _weightController = TextEditingController();
      _selectedBirthday = DateTime.now();
    } else {
      _nameController = TextEditingController(text: pet?.name);
      _speciesController = TextEditingController(text: pet?.species);
      _breedController = TextEditingController(text: pet?.breed);
      _weightController = TextEditingController(text: pet?.weight.toString());
      _selectedBirthday = pet?.birthday ?? DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final isNew = arguments?['isNew'] ?? true;
    final pet = arguments?['pet'] as PetModel?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNew ? 'Add Pet' : 'Edit Pet',
          style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Center(
                  child: Text(
                    _getSpeciesEmoji(_speciesController.text),
                    style: TextStyle(fontSize: 15.w),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Pet Information',
              style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            _buildTextField('Pet Name', _nameController, 'e.g., Luna'),
            SizedBox(height: 2.h),
            _buildTextField('Species', _speciesController, 'e.g., Dog'),
            SizedBox(height: 2.h),
            _buildTextField(
              'Breed',
              _breedController,
              'e.g., Golden Retriever',
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              'Weight (kg)',
              _weightController,
              'e.g., 25.5',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            Text(
              'Birthday',
              style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(_selectedBirthday),
                      style: TextStyle(fontSize: 4.w),
                    ),
                    Icon(Icons.calendar_today, size: 5.w),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: 100.w,
              child: ElevatedButton(
                onPressed: () => _savePet(isNew, pet),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
                child: Text(
                  isNew ? 'Add Pet' : 'Update Pet',
                  style: TextStyle(
                    fontSize: 4.w,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (!isNew) ...[
              SizedBox(height: 2.h),
              SizedBox(
                width: 100.w,
                child: ElevatedButton(
                  onPressed: () => _deletePet(pet!.id!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  child: Text(
                    'Delete Pet',
                    style: TextStyle(
                      fontSize: 4.w,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 2.h,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() => _selectedBirthday = picked);
    }
  }

  void _savePet(bool isNew, PetModel? pet) {
    if (_nameController.text.isEmpty ||
        _speciesController.text.isEmpty ||
        _breedController.text.isEmpty ||
        _weightController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    final newPet = PetModel(
      id: pet?.id,
      userId: authController.currentUser.value!.id!,
      name: _nameController.text,
      species: _speciesController.text,
      breed: _breedController.text,
      birthday: _selectedBirthday,
      weight: double.parse(_weightController.text),
    );

    if (isNew) {
      petController.addPet(newPet);
    } else {
      petController.updatePet(pet!.id!, newPet);
    }

    Get.back();
  }

  void _deletePet(int petId) {
    Get.defaultDialog(
      title: 'Delete Pet',
      content: Text(
        'Are you sure you want to delete this pet?',
        style: TextStyle(fontSize: 4.w),
      ),
      onConfirm: () {
        petController.deletePet(petId);
        Get.back();
        Get.back();
      },
      onCancel: () {},
    );
  }

  String _getSpeciesEmoji(String species) {
    switch (species.toLowerCase()) {
      case 'dog':
        return '🐕';
      case 'cat':
        return '🐈';
      case 'rabbit':
        return '🐰';
      default:
        return '🐾';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final appointmentController = Get.find<AppointmentController>();
  final petController = Get.find<PetController>();
  late int selectedPetId;

  @override
  void initState() {
    super.initState();
    selectedPetId = petController.pets.isNotEmpty
        ? petController.pets[0].id!
        : 0;
    if (selectedPetId != 0) {
      appointmentController.loadAppointments(selectedPetId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointments',
          style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Pet',
                  style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 1.h),
                DropdownButton<int>(
                  value: selectedPetId,
                  isExpanded: true,
                  items: petController.pets
                      .map(
                        (pet) => DropdownMenuItem(
                          value: pet.id,
                          child: Text(pet.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedPetId = value);
                      appointmentController.loadAppointments(value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (appointmentController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (appointmentController.appointments.isEmpty) {
                return Center(
                  child: Text(
                    'No appointments',
                    style: TextStyle(fontSize: 4.w, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: appointmentController.appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointmentController.appointments[index];
                  return _AppointmentCard(
                    appointment: appointment,
                    onCancel: () => appointmentController.cancelAppointment(
                      appointment.id!,
                      selectedPetId,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookingDialog(),
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showBookingDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final veterinarianController = TextEditingController();
    final clinicController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    Get.defaultDialog(
      title: 'Book Appointment',
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Appointment Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: veterinarianController,
              decoration: const InputDecoration(
                hintText: 'Veterinarian Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: clinicController,
              decoration: const InputDecoration(
                hintText: 'Clinic Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      onConfirm: () {
        final appointment = AppointmentModel(
          petId: selectedPetId,
          title: titleController.text,
          description: descriptionController.text,
          appointmentDate: selectedDate,
          veterinarian: veterinarianController.text,
          clinic: clinicController.text,
        );
        appointmentController.bookAppointment(appointment);
        Get.back();
      },
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onCancel;

  const _AppointmentCard({required this.appointment, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appointment.title,
                style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: appointment.status == 'scheduled'
                      ? Colors.green[100]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    fontSize: 3.w,
                    color: appointment.status == 'scheduled'
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Date: ${DateFormat('MMM dd, yyyy').format(appointment.appointmentDate)}',
            style: TextStyle(fontSize: 3.5.w),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Vet: ${appointment.veterinarian} | Clinic: ${appointment.clinic}',
            style: TextStyle(fontSize: 3.5.w, color: Colors.grey),
          ),
          SizedBox(height: 1.5.h),
          GestureDetector(
            onTap: onCancel,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 3.5.w,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final reminderController = Get.find<ReminderController>();
  final petController = Get.find<PetController>();
  late int selectedPetId;

  @override
  void initState() {
    super.initState();
    selectedPetId = petController.pets.isNotEmpty
        ? petController.pets[0].id!
        : 0;
    if (selectedPetId != 0) {
      reminderController.loadReminders(selectedPetId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Pet',
                  style: TextStyle(fontSize: 4.w, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 1.h),
                DropdownButton<int>(
                  value: selectedPetId,
                  isExpanded: true,
                  items: petController.pets
                      .map(
                        (pet) => DropdownMenuItem(
                          value: pet.id,
                          child: Text(pet.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedPetId = value);
                      reminderController.loadReminders(value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (reminderController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (reminderController.reminders.isEmpty) {
                return Center(
                  child: Text(
                    'No reminders',
                    style: TextStyle(fontSize: 4.w, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: reminderController.reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminderController.reminders[index];
                  return _ReminderCard(
                    reminder: reminder,
                    onComplete: () => reminderController.completeReminder(
                      reminder.id!,
                      selectedPetId,
                    ),
                    onDelete: () => reminderController.deleteReminder(
                      reminder.id!,
                      selectedPetId,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReminderDialog(),
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showReminderDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    Get.defaultDialog(
      title: 'Create Reminder',
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Reminder Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      onConfirm: () {
        final reminder = ReminderModel(
          petId: selectedPetId,
          title: titleController.text,
          description: descriptionController.text,
          reminderDate: selectedDate,
          reminderTime: selectedTime,
        );
        reminderController.createReminder(reminder);
        Get.back();
      },
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: reminder.isCompleted ? Colors.green : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(2.w),
        color: reminder.isCompleted ? Colors.green[50] : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reminder.title,
                  style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.bold,
                    decoration: reminder.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              Checkbox(
                value: reminder.isCompleted,
                onChanged: (_) => onComplete(),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Date: ${DateFormat('MMM dd, yyyy').format(reminder.reminderDate)} at ${reminder.reminderTime.format(context)}',
            style: TextStyle(fontSize: 3.5.w, color: Colors.grey),
          ),
          SizedBox(height: 1.h),
          Text(reminder.description, style: TextStyle(fontSize: 3.5.w)),
          SizedBox(height: 1.5.h),
          GestureDetector(
            onTap: onDelete,
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 3.5.w,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
