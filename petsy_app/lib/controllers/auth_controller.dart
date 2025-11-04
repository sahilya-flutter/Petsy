import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petsy_app/model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  RxBool isAuthenticated = false.obs;
  RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Firebase auth state changes listen kar
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  @override
  void onReady() {
    super.onReady();
    // ✅ App start zalyavr initial check kar
    _checkInitialAuthState();
  }

  Future<void> _checkInitialAuthState() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // User logged in ahe
        await _loadUserData(user.uid);
        isAuthenticated.value = true;
        isInitialized.value = true;
        Get.offAllNamed('/home');
      } else {
        // User logged out ahe
        isAuthenticated.value = false;
        isInitialized.value = true;
        Get.offAllNamed('/signin');
      }
    } catch (e) {
      print('Error checking auth state: $e');
      isInitialized.value = true;
      Get.offAllNamed('/signin');
    }
  }

  // Initial screen set kar based on auth state
  Future<void> _setInitialScreen(User? user) async {
    if (!isInitialized.value) return;
    if (user == null) {
      isAuthenticated.value = false;
      currentUser.value = null;
    } else {
      isAuthenticated.value = true;
      await _loadUserData(user.uid);
    }
  }

  // Firestore madhun user data load kar
  // ✅ Public method - SplashScreen madhun call honar
  Future<void> loadUserData(String uid) async {
    await _loadUserData(uid);
  }

  // Firestore madhun user data load kar
  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = uid; // UID add kar

        // ✅ Null checks kar BEFORE UserModel create karyapurvi
        if (data['email'] != null &&
            data['fullName'] != null &&
            data['phoneNumber'] != null &&
            data['createdAt'] != null) {
          currentUser.value = UserModel.fromMap(data);
          isAuthenticated.value = true;
          print('✅ User data loaded successfully: ${data['email']}');
        } else {
          print('❌ Error: Missing required fields in Firestore');
          print('Data: $data');

          // ✅ Agar fields missing ahet tar user logout kar
          await signOut();
        }
      } else {
        print('❌ Error: User document does not exist for UID: $uid');

        // ✅ Document exist nahi tar logout kar
        await signOut();
      }
    } catch (e) {
      print('❌ Error loading user data: $e');

      // ✅ Error aala tar pan logout kar
      await signOut();
    }
  }

  // Sign Up with Email & Password
  // Sign Up with Email & Password
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      isLoading.value = true;

      // Firebase madhe user create kar
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim().toLowerCase(),
            password: password,
          );

      // User model create kar
      final newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email.trim().toLowerCase(),
        password: '',
        fullName: fullName.trim(),
        phoneNumber: phoneNumber.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );

      // Firestore madhe user data save kar
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': newUser.email,
        'fullName': newUser.fullName,
        'phoneNumber': newUser.phoneNumber,
        'createdAt': newUser.createdAt,
      });

      // Display name set kar
      await userCredential.user!.updateDisplayName(fullName.trim());

      // ✅ CHANGE: Sign up success message
      Get.snackbar(
        'Success',
        'Account created successfully! Please sign in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // ✅ CHANGE: User sign out kar (navigation handle karaychi sign in screen la)
      await _auth.signOut();

      // ✅ CHANGE: Login screen var navigate kar
      Get.offAllNamed('/signin');
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password खूप weak आहे!';
          break;
        case 'email-already-in-use':
          errorMessage = 'हा email already registered आहे!';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address!';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign In with Email & Password
  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;

      // Firebase madhe sign in kar
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      // User data load kar
      await _loadUserData(userCredential.user!.uid);

      Get.snackbar(
        'Success',
        'Signed in successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'User नाही मिळाला!';
          break;
        case 'wrong-password':
          errorMessage = 'चुकीचा password!';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address!';
          break;
        case 'user-disabled':
          errorMessage = 'हा account disabled केला आहे!';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed('/signin');
  }

  // Reset Password (Email send hoil)
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());

      Get.snackbar(
        'Success',
        'Password reset email पाठवला आहे. Email check करा.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'हा email registered नाही!';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address!';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process request',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Update user profile
  Future<void> updateProfile({String? fullName, String? phoneNumber}) async {
    try {
      if (currentUser.value == null) return;

      Map<String, dynamic> updates = {};

      if (fullName != null) {
        updates['fullName'] = fullName;
        await _auth.currentUser?.updateDisplayName(fullName);
      }

      if (phoneNumber != null) {
        updates['phoneNumber'] = phoneNumber;
      }

      // Firestore update kar
      await _firestore
          .collection('users')
          .doc(currentUser.value!.uid)
          .update(updates);

      // Local data update kar
      final updatedUser = currentUser.value!.copyWith(
        fullName: fullName ?? currentUser.value!.fullName,
        phoneNumber: phoneNumber ?? currentUser.value!.phoneNumber,
      );

      currentUser.value = updatedUser;

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (_auth.currentUser == null) return;

      // Re-authenticate (security sathi)
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: oldPassword,
      );

      await _auth.currentUser!.reauthenticateWithCredential(credential);

      // New password set kar
      await _auth.currentUser!.updatePassword(newPassword);

      Get.snackbar(
        'Success',
        'Password changed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password चुकीचा आहे!';
          break;
        case 'weak-password':
          errorMessage = 'नवा password खूप weak आहे!';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      if (_auth.currentUser == null) return;

      String uid = _auth.currentUser!.uid;

      // Firestore madhil data delete kar
      await _firestore.collection('users').doc(uid).delete();

      // Firebase Auth account delete kar
      await _auth.currentUser!.delete();

      currentUser.value = null;
      isAuthenticated.value = false;

      Get.snackbar(
        'Success',
        'Account deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed('/signin');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Get.snackbar(
          'Error',
          'Account delete करण्यासाठी पुन्हा login करा!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete account: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete account',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Get current user details
  String? get userEmail => currentUser.value?.email ?? _auth.currentUser?.email;
  String? get userName =>
      currentUser.value?.fullName ?? _auth.currentUser?.displayName;
  String? get userPhone => currentUser.value?.phoneNumber;
  String? get userId => currentUser.value?.uid ?? _auth.currentUser?.uid;
}
