// services/database_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String USERS_COLLECTION = 'users';
  static const String PETS_COLLECTION = 'pets';
  static const String APPOINTMENTS_COLLECTION = 'appointments';
  static const String REMINDERS_COLLECTION = 'reminders';

  // SharedPreferences keys
  static const String SESSION_USER_ID = 'session_user_id';
  static const String SESSION_LOGIN_TIME = 'session_login_time';

  DatabaseHelper._init();

  // ==================== USER AUTHENTICATION METHODS ====================

  // Create User (Sign Up) - Firestore madhe
  Future<void> createUser(Map<String, dynamic> user) async {
    try {
      String uid = user['uid'];

      // Password remove kar (Firebase Auth handle karel)
      user.remove('password');

      await _firestore.collection(USERS_COLLECTION).doc(uid).set(user);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get User by Email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(USERS_COLLECTION)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        data['uid'] = querySnapshot.docs.first.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  // Get User by UID
  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    try {
      final docSnapshot = await _firestore
          .collection(USERS_COLLECTION)
          .doc(uid)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data()!;
        data['uid'] = uid;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by UID: $e');
    }
  }

  // Update User
  Future<void> updateUser(String uid, Map<String, dynamic> user) async {
    try {
      // Password ani uid remove kar (update nahi karaycha)
      user.remove('password');
      user.remove('uid');

      await _firestore.collection(USERS_COLLECTION).doc(uid).update(user);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete User (All data delete karel)
  Future<void> deleteUser(String uid) async {
    try {
      // Batch delete for all user data
      WriteBatch batch = _firestore.batch();

      // Delete user's pets
      final petsSnapshot = await _firestore
          .collection(PETS_COLLECTION)
          .where('userId', isEqualTo: uid)
          .get();

      for (var doc in petsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete user's appointments
      final appointmentsSnapshot = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .where('userId', isEqualTo: uid)
          .get();

      for (var doc in appointmentsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete user's reminders
      final remindersSnapshot = await _firestore
          .collection(REMINDERS_COLLECTION)
          .where('userId', isEqualTo: uid)
          .get();

      for (var doc in remindersSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete user document
      batch.delete(_firestore.collection(USERS_COLLECTION).doc(uid));

      // Commit batch
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Change Password - Firebase Auth handle karel, he method optional ahe
  Future<void> changePassword(String uid, String newPassword) async {
    // Firebase Auth directly password change karel
    // He method keep compatibility sathi
    print('Password change Firebase Auth ne handle hot ahe');
  }

  // ==================== SESSION MANAGEMENT ====================

  // Save Session (SharedPreferences madhe)
  Future<void> saveSession(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SESSION_USER_ID, userId);
      await prefs.setString(
        SESSION_LOGIN_TIME,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw Exception('Failed to save session: $e');
    }
  }

  // Get Current Session
  Future<String?> getCurrentSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(SESSION_USER_ID);
    } catch (e) {
      return null;
    }
  }

  // Clear Session (Logout)
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SESSION_USER_ID);
      await prefs.remove(SESSION_LOGIN_TIME);
    } catch (e) {
      throw Exception('Failed to clear session: $e');
    }
  }

  // Check if Session Exists
  Future<bool> hasActiveSession() async {
    final session = await getCurrentSession();
    return session != null && session.isNotEmpty;
  }

  // ==================== PET CRUD OPERATIONS ====================

  // Insert Pet
  Future<String> insertPet(Map<String, dynamic> pet) async {
    try {
      final docRef = await _firestore.collection(PETS_COLLECTION).add(pet);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to insert pet: $e');
    }
  }

  // Get Pets by User ID
  Future<List<Map<String, dynamic>>> getPets(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(PETS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get pets: $e');
    }
  }

  // Get Pets Stream (Real-time updates)
  Stream<List<Map<String, dynamic>>> getPetsStream(String userId) {
    return _firestore
        .collection(PETS_COLLECTION)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            var data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // Get Pet by ID
  Future<Map<String, dynamic>?> getPetById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(PETS_COLLECTION)
          .doc(id)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data()!;
        data['id'] = id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get pet: $e');
    }
  }

  // Update Pet
  Future<void> updatePet(String id, Map<String, dynamic> pet) async {
    try {
      pet.remove('id'); // ID remove kar
      await _firestore.collection(PETS_COLLECTION).doc(id).update(pet);
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  // Delete Pet (with related data)
  Future<void> deletePet(String id) async {
    try {
      WriteBatch batch = _firestore.batch();

      // Delete related appointments
      final appointmentsSnapshot = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .where('petId', isEqualTo: id)
          .get();

      for (var doc in appointmentsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete related reminders
      final remindersSnapshot = await _firestore
          .collection(REMINDERS_COLLECTION)
          .where('petId', isEqualTo: id)
          .get();

      for (var doc in remindersSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete pet
      batch.delete(_firestore.collection(PETS_COLLECTION).doc(id));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }

  // Get total pets count
  Future<int> getPetsCount(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(PETS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  // ==================== APPOINTMENT CRUD OPERATIONS ====================

  // Insert Appointment
  Future<String> insertAppointment(Map<String, dynamic> appointment) async {
    try {
      final docRef = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .add(appointment);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to insert appointment: $e');
    }
  }

  // Get Appointments
  Future<List<Map<String, dynamic>>> getAppointments(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  // Get Appointments Stream
  Stream<List<Map<String, dynamic>>> getAppointmentsStream(String userId) {
    return _firestore
        .collection(APPOINTMENTS_COLLECTION)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            var data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // Get Appointments by Pet
  Future<List<Map<String, dynamic>>> getAppointmentsByPet(String petId) async {
    try {
      final querySnapshot = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .where('petId', isEqualTo: petId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  // Get Upcoming Appointments
  Future<List<Map<String, dynamic>>> getUpcomingAppointments(
    String userId,
  ) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final querySnapshot = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: today)
          .orderBy('date')
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get upcoming appointments: $e');
    }
  }

  // Update Appointment
  Future<void> updateAppointment(
    String id,
    Map<String, dynamic> appointment,
  ) async {
    try {
      appointment.remove('id');
      await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .doc(id)
          .update(appointment);
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  // Delete Appointment
  Future<void> deleteAppointment(String id) async {
    try {
      await _firestore.collection(APPOINTMENTS_COLLECTION).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }

  // ==================== REMINDER CRUD OPERATIONS ====================

  // Insert Reminder
  Future<String> insertReminder(Map<String, dynamic> reminder) async {
    try {
      final docRef = await _firestore
          .collection(REMINDERS_COLLECTION)
          .add(reminder);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to insert reminder: $e');
    }
  }

  // Get Reminders
  Future<List<Map<String, dynamic>>> getReminders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(REMINDERS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get reminders: $e');
    }
  }

  // Get Reminders Stream
  Stream<List<Map<String, dynamic>>> getRemindersStream(String userId) {
    return _firestore
        .collection(REMINDERS_COLLECTION)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            var data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // Get Reminders by Pet
  Future<List<Map<String, dynamic>>> getRemindersByPet(String petId) async {
    try {
      final querySnapshot = await _firestore
          .collection(REMINDERS_COLLECTION)
          .where('petId', isEqualTo: petId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get reminders: $e');
    }
  }

  // Get Pending Reminders
  Future<List<Map<String, dynamic>>> getPendingReminders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(REMINDERS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: 0)
          .orderBy('date')
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get pending reminders: $e');
    }
  }

  // Update Reminder
  Future<void> updateReminder(String id, Map<String, dynamic> reminder) async {
    try {
      reminder.remove('id');
      await _firestore
          .collection(REMINDERS_COLLECTION)
          .doc(id)
          .update(reminder);
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  // Mark Reminder Complete
  Future<void> markReminderComplete(String id) async {
    try {
      await _firestore.collection(REMINDERS_COLLECTION).doc(id).update({
        'isCompleted': 1,
      });
    } catch (e) {
      throw Exception('Failed to mark reminder complete: $e');
    }
  }

  // Delete Reminder
  Future<void> deleteReminder(String id) async {
    try {
      await _firestore.collection(REMINDERS_COLLECTION).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }

  // ==================== UTILITY METHODS ====================

  // Get all user data (for export/backup)
  Future<Map<String, dynamic>> getAllUserData(String userId) async {
    try {
      final user = await getUserByUid(userId);
      final pets = await getPets(userId);
      final appointments = await getAppointments(userId);
      final reminders = await getReminders(userId);

      return {
        'user': user,
        'pets': pets,
        'appointments': appointments,
        'reminders': reminders,
      };
    } catch (e) {
      throw Exception('Failed to get all user data: $e');
    }
  }

  // Delete all user data (except user profile)
  Future<void> deleteAllUserData(String userId) async {
    try {
      WriteBatch batch = _firestore.batch();

      // Delete pets
      final petsSnapshot = await _firestore
          .collection(PETS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in petsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete appointments
      final appointmentsSnapshot = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in appointmentsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete reminders
      final remindersSnapshot = await _firestore
          .collection(REMINDERS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in remindersSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all user data: $e');
    }
  }

  // Get Dashboard Stats
  Future<Map<String, int>> getDashboardStats(String userId) async {
    try {
      // Pets count
      final petsSnapshot = await _firestore
          .collection(PETS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .get();

      // Appointments count
      final appointmentsSnapshot = await _firestore
          .collection(APPOINTMENTS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .get();

      // Pending reminders count
      final remindersSnapshot = await _firestore
          .collection(REMINDERS_COLLECTION)
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: 0)
          .get();

      return {
        'pets': petsSnapshot.docs.length,
        'appointments': appointmentsSnapshot.docs.length,
        'reminders': remindersSnapshot.docs.length,
      };
    } catch (e) {
      return {'pets': 0, 'appointments': 0, 'reminders': 0};
    }
  }

  // Get Dashboard Stats Stream (Real-time)
  Stream<Map<String, int>> getDashboardStatsStream(String userId) {
    return Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
      return await getDashboardStats(userId);
    });
  }
}
